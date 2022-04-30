/* Copyright 1990-2006, Jsoftware Inc.  All rights reserved.               */
/* Licensed use only. Any other use is in violation of copyright.          */
/*                                                                         */

// Threads and Tasks
#include "j.h"
// burn some time, approximately n nanoseconds
NOINLINE I delay(I n){I johnson=0x1234; do{johnson ^= (johnson<<1) ^ johnson>>(BW-1);}while(--n); R johnson;}

#if SY_WIN32
struct timezone {
    int tz_minuteswest;
    int tz_dsttime;
};

// Tip o'hat to Michaelangel007 on StackOverflow
// MSVC defines this in winsock2.h!?
typedef struct timeval {
    long tv_sec;
    long tv_usec;
} timeval;
extern int gettimeofday(struct timeval * tp, struct timezone * tzp);
#else
#include <sys/time.h>
#endif

// Extend a hashtable/data table under lock.  abuf is the pointer to the block to be extended (*abuf will hold the new block address).
// *alock is the lock to use.  We hold a writelock on *alock on entry, but we may relinquish inside this routine.
// On exit we hold the write lock UNLESS there was an error, in which case we return NOT holding the lock (to allow the caller to abort on error)
// flags&1 is 1 if *abuf is a hashtable.  In that case, fill it with -1 and set AM to 0 to indicate a rehash is needed.  Otherwise copy the old contents to the beginning of the resized table.
// flags&2 is set to suppress freeing the old block after setting the new one
// flags&4 is set when flags&1 is set to indicate the hash table should fill with 0 rather than -1 (for address rather than index hashes)
// flags&8 is  set if the block has rank 1 and needs to keep AS[0] unchanged so it can be used in J verbs
// result is 0 if we hit an error, otherwise the table has been resized, but not necessarily by us & it might not have enough space.
// The tables resized here are allocated with any rank.  AN()/AS() (if present) gives the current allocation, and AM() gives the number of items actually in use
// When a table is resized, it is mf()'d without recurring to contents.  This means it must not be in use otherwise, for example as a result or a backer
I jtextendunderlock(J jt, A *abuf, US *alock, I flags){A z;
 I oldn=AN(*abuf);   // get the previous allocated size
 I t=AT(*abuf);  // get the type of the allocation
 WRITEUNLOCK(*alock);  // relinquish lock while we allocate the new area
 GA0(z,t,2*oldn,AR(*abuf)); ACINITZAP(z); // allocate a new block, bigger than the previous one; make it permanent.  This is the only error exit from this routine
 WRITELOCK(*alock);  // reacquire lock
 A obuf=*abuf;  // current buffer after reacquiring lock
 AFLAGINIT(z,AFLAG(obuf));  // preserve the recursive status of the block since we are transferring contents
 if(AN(obuf)==oldn){
  // normal case where no one else resized the block before we did.  Transfer the data and counts from the old block to the new
  I itemsize;
  I nvaliditems=AM(obuf);  // remember number of valid items in the old block
  I datasize=allosize(z);  // number of bytes in data area
  I alloatoms=datasize>>bplg(t);   // advance AN to max allocation - leaving no buffer at the end
  // if this allocation is a table, fill in AN and AS[0] (otherwise AN is all we need)
  // if there are elements of the shape beyond AS[0], they must be parameters or item shape and they are just copied.  If rank=1, AS[0] is also such a parameter
  if(AR(z)>1){itemsize=AN(obuf)/AS(obuf)[0]; AS(z)[0]=alloatoms/itemsize; AN(z)=AS(z)[0]*itemsize; DONOUNROLL(AR(z)-1, AS(z)[i+1]=AS(obuf)[i+1];)
  }else{itemsize=1; AN(z)=alloatoms; AS(z)[0]=flags&8?AS(obuf)[0]:alloatoms;}  // if rank=1, AS[0] may be a user field.  If rank=0 it will be overwritten
  // if the type is boxed, and we extended the allocation, we had better clear the added atoms in case we ever free the block elsewhere
  if(unlikely(t&BOX))mvc((AN(z)-2*oldn)*BOXSIZE,AAV(z)+2*oldn,1,MEMSET00);
  if(flags&1){
   // If the block is a hashtable, it will be rebuilt from scratch and we just initialize it to -1 pointers
   mvc(datasize,voidAV(z),1,(flags&4)?MEMSET00:MEMSETFF);  // fill the entire table
   AM(z)=0;  // indicate the whole hash is invalid after resize
  }else{
   MC(voidAV(z),voidAV(obuf),itemsize*(nvaliditems<<bplg(t)));  // copy the valid data.  Rest can be left garbage
   AM(z)=nvaliditems;  // transfer the count of allocated atoms, now valid
  }
  // release the old block.  We assume that freeing a block will not permanently block this thread
  __atomic_store_n(abuf,z,__ATOMIC_RELEASE); if(!(flags&2))mf(obuf);  // mf, not fa, so we don't recur to recursible children that have been copied and are still valid.   The free is optional
 }else{
  // somebody else has already resized the block.  We just back off and hope they resized it enough.
  mf(z);  // discard the block we allocated
 }
 R 1;  // normal return
}

// ************************ system lock **********************************
#define POLLDELAY delay(20);
#if PYXES
#define YIELD sched_yield();  // if we are spinning on other threads, give them a chance to run in case they might be on this core
#else
#define YIELD ;   // if no other processes, no reason to delay
#endif

// perform the action for state n.  In the leader, set ct/advance/act/wait  In others, wait/act/decr ct.  When we finish all actors have performed the action for state n
#define DOINSTATE(l,n,expr) \
 {if(l){__atomic_store_n(&JT(jt,systemlocktct),nrunning-1,__ATOMIC_RELEASE); __atomic_store_n(&JT(jt,systemlock),(n),__ATOMIC_RELEASE);}else while(__atomic_load_n(&JT(jt,systemlock),__ATOMIC_ACQUIRE)!=(n))YIELD  \
  expr \
  if(l)while(__atomic_load_n(&JT(jt,systemlocktct),__ATOMIC_ACQUIRE)!=0)YIELD else __atomic_fetch_sub(&JT(jt,systemlocktct),1,__ATOMIC_ACQ_REL); \
 }

// Similar function, for systemlockaccept
#define DOINSTATEA(n,expr) {while(__atomic_load_n(&JT(jt,systemlock),__ATOMIC_ACQUIRE)!=(n))YIELD expr __atomic_fetch_sub(&JT(jt,systemlocktct),1,__ATOMIC_ACQ_REL);}
 
// Take lock on the entire system, waiting till all threads acknowledge
// priority is the priority of the request.  lockedfunction is the function to call when the lock has been agreed.
// if multiple requesters ask for a lock, the function will be called in only one of them
// lockedfunction should return 0 for error, otherwise the value to use.  The return to the caller depends on jerr and
// whether the thread ran the function: in the thread that ran the function, value/error from lockedfunction is passed through;
// in other threads, 1 is returned always with no error signaled
A jtsystemlock(J jt,I priority,A (*lockedfunction)()){A z;C res;
 // If the system is already in systemlock, the system is essentially single-threaded.  Just execute the user's function.
 // This would happen if a sentence executed in debug suspension needed symbols, or had an error
 if(__atomic_load_n(&JT(jt,systemlock),__ATOMIC_ACQUIRE)>2){R (*lockedfunction)(jt);}
 // Process the request.  We don't know what the highest-priority request is until we have heard from all the
 // threads.  Thus, it is possible that our request will still be pending whe we finish.  In that case, loop till it is satisfied
 while(priority!=0){
  S xxx=0; I leader=__atomic_compare_exchange_n(&JT(jt,systemlock), &xxx, (S)1, 0, __ATOMIC_ACQ_REL, __ATOMIC_RELAXED);  // go to state 1; set leader if we are the first to do so
  I nrunning=0; JTT *jjbase=JTTHREAD0(jt);  // #running threads, base of thread blocks
  // In the leader task only, go through all tasks (including master), turning on the SYSLOCK task flag in each thread.  Count how many are running after the flag is set
  if(leader){DONOUNROLL(MAXTASKS, nrunning+=(__atomic_fetch_or(&jjbase[i].taskstate,TASKSTATELOCKACTIVE,__ATOMIC_ACQ_REL)>>TASKSTATERUNNINGX)&1;)}
  // state 2: lock requesters indicate request priority and we wait for all tasks to come to a stop
  C oldpriority; DOINSTATE(leader,2,oldpriority=__atomic_fetch_or(&JT(jt,adbreak)[1],priority,__ATOMIC_ACQ_REL);)  // remember priority before we made our request
  // state 3: all threads get the final request priorities
  C finalpriority; DOINSTATE(leader,3,finalpriority=__atomic_load_n(&JT(jt,adbreak)[1],__ATOMIC_ACQUIRE);)
  I winningpri=LOWESTBIT(finalpriority); I executor=winningpri&priority&~oldpriority;  // priority to execute: were we the first to request it?
  // state 4: transfer nrunning to executor and run the locked function.  Other tasks must do nothing and wait for state 5.
  if(leader){__atomic_store_n(&JT(jt,systemlocktct),nrunning,__ATOMIC_RELEASE); __atomic_store_n(&JT(jt,systemlock),4,__ATOMIC_RELEASE);}  // leader advances to state 4
  if(executor){  // if we were the first to request the winning priority
   // This is the winning thread.  Perform the function and save the error status
   while(__atomic_load_n(&JT(jt,systemlock),__ATOMIC_ACQUIRE)!=4)YIELD nrunning=__atomic_load_n(&JT(jt,systemlocktct),__ATOMIC_ACQUIRE);  // executor waits for state 4 and picks up nrunning.  Not actually necessary, but otherwise we have to guarantee tct unchanged by function
   // remove the lock request from the break field so that it doesn't cause the function to think a lock is requested
   __atomic_store_n(&JT(jt,adbreak)[1],0,__ATOMIC_RELEASE);
   z=(*lockedfunction)(jt);  // perform the locked function
   __atomic_store_n(&((C*)&JT(jt,breakbytes))[1],jt->jerr,__ATOMIC_RELEASE);  // make the error status available to all threads
  }
  // state 5: everybody gets the result of the operation
  DOINSTATE(executor,5,res=__atomic_load_n(&((C*)&JT(jt,breakbytes))[1],__ATOMIC_ACQUIRE);)
  // Now wind down the lock.  taskct is known to be 0.  Turn off all the LOCK bits and then set state to 0.  Other tasks will
  // wait for state to move off 5.  There is no guarantee they will see state 0 of the next systemlock, but state cannot advance beyond 1 until they have finished this one.
  // There is also no guarantee they will see their LOCK removed
  if(executor){
   __atomic_store_n(&((C*)&JT(jt,breakbytes))[1],0,__ATOMIC_RELEASE);  // clear the error flag from the interrupt request
   // go through all threads, turning off SYSLOCK in each.  This allows other tasks to run and new tasks to start
   DO(MAXTASKS, __atomic_fetch_and(&jjbase[i].taskstate,~TASKSTATELOCKACTIVE,__ATOMIC_ACQ_REL);)
   // set the systemlock to 0, completing the operation
   __atomic_store_n(&JT(jt,systemlock),0,__ATOMIC_RELEASE);
  }else{
   // outside the executor, we wait for state to move off 5
   while(__atomic_load_n(&JT(jt,systemlock),__ATOMIC_ACQUIRE)==5)YIELD
   z=(A)1;  // just use a value of 1 to indicate we were not the executing thread.  The real z goes to the executor
   // NOTE that a non-executor thread here does not use the error status
  }
  priority&=~winningpri;  // if our request was serviced, remove it, regardless of who serviced it
 }
 // here a request was processed at the level we requested.  We have the value to return; error
 // is available but has been signaled to the executor only
 R z;  // ewturn to requester
}

// Allow a system lock to proceed.  Called by a running thread when it notices the broadcast system-lock request at its priority or higher
// priority is mask indicating the priorities for which this accept is valid.  smaller bit-values have higher priority
// Result is 0 if the lock processing failed
I jtsystemlockaccept(J jt, I priority){
 do{C finalpriority; C res;
  DOINSTATEA(2,)  // state 2: requests at different priorities
  DOINSTATEA(3,finalpriority=__atomic_load_n(&JT(jt,adbreak)[1],__ATOMIC_ACQUIRE);)  // state 3: get winning priority
  // state 4: transfer nrunning to executor and run the function.  Other threads wait for the result
  DOINSTATEA(5,res=__atomic_load_n(&((C*)&JT(jt,breakbytes))[1],__ATOMIC_ACQUIRE);)// state 5: everybody gets the result of the operation
  while(__atomic_load_n(&JT(jt,systemlock),__ATOMIC_ACQUIRE)==5)YIELD  // wait for state to move off 5, indicating completion
  ASSERT(res==0,res)  // if there was an error, signal it in all acceptor threads
  // this thread is free to continue.  systemlock has been cleared
  // loop back if there is another request that this can tolerate
  I winningpri=LOWESTBIT(finalpriority); finalpriority&=~winningpri; priority&=finalpriority; // final<-remaining requests; leave priority as the ones we are OK with
 }while(priority);  // if our priority was SYM-only and the remaining request is DEBUG, we have to return to get to a DEBUG point
 R 1;
}

#if ARTIFPYX
// w is a block that will become the contents of a box.  Put it inside a pyx and return the address of the pyx.
// aflag is the boxing flag of the block the result is going to go into.  w has been prepared for that type
A jtartiffut(J jt,A w,I aflag){A z;
 GAT0(z,BOX,1,0); AFLAG(z)|=BOX; AAV0(z)[0]=w; AT(z)|=PYX; if(aflag&BOX){ra(z);}else{ACIPNO(z); ra(w);}  // just one of z/w must be adjusted to the recursion environment
 R z;
}
#endif
// ****************************** waiting for values *******************************
#if PYXES
typedef struct condmutex{
 pthread_cond_t cond;
 pthread_mutex_t mutex;
} WAITBLOK;
#endif

typedef struct pyxcondmutex{
 A pyxvalue;  // the A block of the pyx, when it is filled in.  It is 0 until then.
 float pyxmaxwt;  // max time to wait for this pyx in seconds
 S pyxorigthread;  // thread number that is working on this pyx, or _1 if the value is available
 C errcode;  // 0 if no error, or error code
#if PYXES
 WAITBLOK pyxwb;  // sync info
#endif
} PYXBLOK;

#if PYXES

// Install a value/errcode into a (recursive) pyx, and broadcast to anyone waiting on it.  fa() the pyx to indicate that the thread has released the pyx
// If the value has been previously installed (invalid, and possible only with user pyxes), return abort code 0, otherwise 1
static I jtsetpyxval(J jt, A pyx, A z, C errcode){I res=1;
 S prevthread=__atomic_exchange_n(&((PYXBLOK*)AAV0(pyx))->pyxorigthread,-1,__ATOMIC_ACQ_REL);  // set pyx no longer running
 if(unlikely(prevthread<0))R 0;  // the pyx is read-only once written
 __atomic_store_n(&((PYXBLOK*)AAV0(pyx))->errcode,errcode,__ATOMIC_RELEASE);  // copy failure code.  Must be non0 - if not that is itself an error
 if(likely(z!=0))ra(z);  // since the pyx is recursive, we must ra the result we store into it
 __atomic_store_n(&((PYXBLOK*)AAV0(pyx))->pyxvalue,z,__ATOMIC_RELEASE);  // set result value
 // broadcast to wake up any tasks waiting for the result
 pthread_mutex_lock(&((PYXBLOK*)AAV0(pyx))->pyxwb.mutex); pthread_cond_broadcast(&((PYXBLOK*)AAV0(pyx))->pyxwb.cond); pthread_mutex_unlock(&((PYXBLOK*)AAV0(pyx))->pyxwb.mutex);
 // unprotect pyx.  It was raised when it was assigned to this owner; now it belongs to the system
 fa(pyx);
 R 1;
}

// Allocate a pyx, marked as owned by (thread).  Set usecount to 2, counting the thread as one owner
static A jtcreatepyx(J jt, I thread,D timeout){A pyx;
 // Allocate.  Init value, cond, and mutex to idle
 GAT0(pyx,INT,((sizeof(PYXBLOK)+(SZI-1))>>LGSZI)+1,0); AAV0(pyx)[0]=0; // allocate the result pointer (1), and the cond/mutex for the pyx.
 pthread_cond_init(&((PYXBLOK*)AAV0(pyx))->pyxwb.cond,0); pthread_mutex_init(&((PYXBLOK*)AAV0(pyx))->pyxwb.mutex,0);
 // Init the pyx to a recursive box, with raised usecount.  AN=1 always.  But set the value/errcode to NULL/no error and the thread# to the executing thread
 AT(pyx)=BOX+PYX; AFLAG(pyx)=BOX; ACINIT(pyx,ACUC2); AN(pyx)=1; ((PYXBLOK*)AAV0(pyx))->pyxvalue=0; ((PYXBLOK*)AAV0(pyx))->pyxorigthread=thread; ((PYXBLOK*)AAV0(pyx))->errcode=0;  ((PYXBLOK*)AAV0(pyx))->pyxmaxwt=timeout;
 // The pyx's usecount of 2 is one for the owning thread and one for the current thread, which has a tpop for the pyx.  When the pyx is filled in the owner will fa().
 R pyx;
}

// w is an A holding a pyx value.  Return its value when it has been resolved.  If it times out
A jtpyxval(J jt,A pyx){A res; C errcode;
 D maxtime=tod()+((PYXBLOK*)AAV0(pyx))->pyxmaxwt+0.000001;  // get the time when we have to give up on this pyx, min 1usec
 // read the pyx value.  Since the creating thread has a release barrier after creation and another after final resolution, we can be sure
 // that if we read nonzero the pyx has been resolved, even without an acquire barrier
 while((res=__atomic_load_n(&((PYXBLOK*)AAV0(pyx))->pyxvalue,__ATOMIC_ACQUIRE))==0&&(errcode=__atomic_load_n(&((PYXBLOK*)AAV0(pyx))->errcode,__ATOMIC_ACQUIRE))==0){  // repeat till defined
  I adbreak=__atomic_load_n((US*)&JT(jt,adbreak)[0],__ATOMIC_ACQUIRE);  // break requests
  // wait till the value is defined.  We have to make one last check inside the lock to make sure the value is still unresolved
  // The wait may time out because another thread is requesting a system lock.  If so, we accept it now
  if(unlikely(adbreak>>8)!=0){jtsystemlockaccept(jt,LOCKPRISYM+LOCKPRIDEBUG); continue;}  // process lock and keep waiting
  // or, the user may be requesting a BREAK interrupt for deadlock or other slow execution.  In that case fail the pyx.  It will not be deleted until the value has been stored
  if(unlikely((adbreak&0xff)>1)){errcode=EVBREAK; break;}  // JBREAK: fail the pyx and exit
  // if the pyx has a max time, see if that is exceeded
  if(unlikely(maxtime<tod())){errcode=EVTIME; break;}  // timeout: fail the pyx and exit
  pthread_mutex_lock(&((PYXBLOK*)AAV0(pyx))->pyxwb.mutex);
  if((res=__atomic_load_n(&((PYXBLOK*)AAV0(pyx))->pyxvalue,__ATOMIC_ACQUIRE))==0&&(errcode=__atomic_load_n(&((PYXBLOK*)AAV0(pyx))->errcode,__ATOMIC_ACQUIRE))==0){
   struct timeval nowtime;
   gettimeofday(&nowtime,0);  // system time now
   I tousec=nowtime.tv_usec+200000;
   struct timespec endtime={nowtime.tv_usec+(tousec>=1000000),tousec-1000000*(tousec>=1000000)};  // system time when we give up.  The struct says it uses nsec but it seems to use usec
   pthread_cond_timedwait(&((PYXBLOK*)AAV0(pyx))->pyxwb.cond,&((PYXBLOK*)AAV0(pyx))->pyxwb.mutex,&endtime);
  }
  pthread_mutex_unlock(&((PYXBLOK*)AAV0(pyx))->pyxwb.mutex);
 }
 // res now contains the certified value of the pyx.
 if(likely(res!=0))R res;   // valid value, use it
 ASSERT(0,errcode)   // if error, return the error code
}

// ************************************* Locks **************************************
// take a readlock on *alock.  We come here only if a writelock was requested or running.  We have incremented the readlock
void readlock(S *alock, S prev){
 // loop until we get the lock
 do{
  __atomic_fetch_sub(alock,1,__ATOMIC_ACQ_REL);  // rescind our read request.  The writer may hitch slightly when he sees our request, but we won't put it up more than once
  // spin until any write request has gone away
  I nspins=50;  // good upper bound on the amount of time a write could reasonably take, in poll delays
  while(prev&-WLOCKBIT){
   // we are delaying while a writer finishes.  Usually this will be fairly short, as controlled by nspins.  The danger is that the
   // writer will be preempted, leaving us in a tight spin.  If the spin counter goes to 0, we decide this must have happened, and we
   // do a low-power delay for a little while (method TBD)
   if(--nspins==0){nspins=50; YIELD}
   POLLDELAY  // delay a little to reduce bus traffic while we wait for the writer to finish
   prev=__atomic_load_n(alock,__ATOMIC_ACQUIRE);
  }
  // try to reacquire the lock, loop if can't
 }while(__atomic_fetch_add(alock,1,__ATOMIC_ACQ_REL)<0);
}

// take a writelock on *alock.  We have turned on the write request; we come here only if the lock was in use.  The previous value was prev
void writelock(S *alock, S prev){
 // loop until we get the lock
 I nspins;
 while(prev&(S)-WLOCKBIT) {
 // Another writer requested.  They win.  wait until they finish.  As above, back off if it looks like they were preempted
  nspins=prev&0x7fff?50+10:50;  // max expected writer delay, plus reader delay if there are readers, in 20-ns units
  while(prev&(S)-WLOCKBIT){
   if(--nspins==0){nspins=50; YIELD}
   POLLDELAY  // delay a little to reduce bus traffic while we wait for the writer to finish
   prev=__atomic_load_n(alock,__ATOMIC_ACQUIRE);  // loop without RFO cycle till the other writer goes away
  }
  // try to reacquire the writelock
#if WLOCKBIT==0x8000
  prev=__atomic_fetch_or(alock,(S)WLOCKBIT,__ATOMIC_ACQ_REL);
#else
  prev=__atomic_fetch_add(alock,WLOCKBIT,__ATOMIC_ACQ_REL);
#endif
  // that repeats our request
 }
 // We are the owner of the current write request.  When the reads finish, we have the lock
 nspins=20;  // max expected reader delay, in poll delays.  They are all running in parallel
 while(prev&(WLOCKBIT-1)){  // wait until reads complete
  if(--nspins==0){nspins=20; YIELD}  // delay if a thread seems to have been preempted
  POLLDELAY  // delay a little to reduce bus traffic while we wait for the readers to finish
  prev=__atomic_load_n(alock,__ATOMIC_ACQUIRE);
 }
 // the lock is now 8000 and we have it.  It may go off 8000 while we run, but we won't look
}

// *********************** task creation ********************************

// The RUNNING flag must not be changed while a system lock is in progress, because the lock owner knows how many active tasks there are
// set running, returning 1 if it wasn't set already
I jtsettaskrunning(J jt){
 // go to RUNNING state; but we are not allowed to change state if LOCKACTIVE has been set in our task.  In that
 // case someone has started a system lock and our running status has been captured.  LOCKACTIVE is set in state 1 and removed in state 5.  We must
 // first wait for the lock to clear and then wait to get out of state 5 (so that we don't do a systemlock request and think we are single-threaded)
 S oldstate; while(oldstate=0, !__atomic_compare_exchange_n(&jt->taskstate, &oldstate, TASKSTATERUNNING, 0, __ATOMIC_ACQ_REL, __ATOMIC_RELAXED)){
  if(oldstate&TASKSTATERUNNING)R 0;   // if for some reason we are called with the bit already set, keep it set and indicate it wasn't us that set it
  if(oldstate&TASKSTATELOCKACTIVE){YIELD delay(1000);}
 }
 while(__atomic_load_n(&JT(jt,systemlock),__ATOMIC_ACQUIRE)==5)YIELD
 R 1;
}
void jtclrtaskrunning(J jt){S oldstate;
 // go back to non-RUNNING state, but if SYSTEMLOCK has been started with us counted active go handle it
 while(oldstate=TASKSTATERUNNING, !__atomic_compare_exchange_n(&jt->taskstate, &oldstate, 0, 0, __ATOMIC_ACQ_REL, __ATOMIC_RELAXED)){
  if(!(oldstate&TASKSTATERUNNING))R;   // if for some reason we are called with the bit already off, keep it off
  if(likely(oldstate&TASKSTATELOCKACTIVE)){jtsystemlockaccept(jt,LOCKPRIDEBUG|LOCKPRISYM);}else{YIELD delay(1000);}
 }
}

// Processing loop for thread.  Create a wait block for the thread, and wait on it.  Each loop runs one user task
static void* jtthreadmain(void * arg){J jt=(J)arg; WAITBLOK wblok;
 // allocate condition & mutex here in a struct & initialize
 pthread_cond_init(&wblok.cond,0); pthread_mutex_init(&wblok.mutex,0);
 A *old=jt->tnextpushp;  // we leave a clear stack when we go
 // get/set stack limits
// not supported on Windows if(pthread_attr_getstackaddr(0,(void **)&jt->cstackinit)!=0)R 0;
 jt->cstackinit=(UI)&wblok;  // use a local as a surrogate for the stack pointer
 jt->cstackmin=jt->cstackinit-(CSTACKSIZE-CSTACKRESERVE);  // init stack as for main thread
   // Note: we use cstackinit as an indication that this thread is ready to use.  It is actually a few cycles away from that.  Thus it is possible, but extremely unlikely,
   // that this task will not be seen first time u t. v is used
 while(1){
  // put pointer to our cond/mutex into commregion so other tasks can see it
  // take our mutex
  // put our thread on the thread queue
  TASKAWAITBLOK(jt)=&wblok; J mjt=MTHREAD(JJTOJ(jt));
  pthread_mutex_lock(&wblok.mutex);  // must lock mutex before we reveal that we are ready
   WRITELOCK(mjt->tasklock);  jt->taskidleq=mjt->taskidleq; mjt->taskidleq=THREADID(jt); WRITEUNLOCK(mjt->tasklock);   // install our thread at head of chain
   pthread_cond_wait(&wblok.cond,&wblok.mutex);  // wait, then release mutex
  pthread_mutex_unlock(&wblok.mutex);
  // When we get here we have been made ready to run
  // extract task parameters: args & pyx block.  Their usecount was raised before we started.  The self here is for u t. v so that we can get to the v 
  A arg1=__atomic_load_n(&TASKCOMMREGION(jt)[0],__ATOMIC_ACQUIRE); A arg2=TASKCOMMREGION(jt)[1]; A arg3=TASKCOMMREGION(jt)[2]; A pyx=TASKCOMMREGION(jt)[3];
  // initialize the non-parameter part of task block
  memset(&jt->uflags.us.uq,0,offsetof(JTT,ranks)-offsetof(JTT,uflags.us.uq));    // clear what should be cleared
  jt->iepdo=0; jt->xmode=0;  jt->recurstate=RECSTATEBUSY; RESETRANK; jt->locsyms=JT(jt,emptylocale); jt->currslistx=-1;  // init what needs initing.  Notably clear the local symbols
  jtsettaskrunning(jt);  // go to RUNNING state, perhaps after waiting for system lock to finish
  // run the task, raising & lowering the locale execct.  Bivalent
  I4 savcallstack = jt->callstacknext;   // starting callstack
  A startloc=jt->global;  // point to current global locale
  if(likely(startloc!=0))INCREXECCT(startloc);  // raise usecount of current locale to protect it while running
  I dyad=!(AT(arg2)&VERB); A self=dyad?arg3:arg2;  // the call is either noun self x or noun noun self.  See which set dyad flag and select self.
  // Get the arg2/arg3 to use for u .  These will be the self of u, possibly repeated if there is no a
  A uarg3=FAV(self)->fgh[0], uarg2=arg2; uarg2=dyad?uarg2:uarg3;  // get self, positioned after the last noun arg
  A z=(FAV(FAV(self)->fgh[0])->valencefns[dyad])(jt,arg1,uarg2,uarg3);  // execute the u in u t. v
  if(likely(startloc!=0))DECREXECCT(startloc);  // remove protection from executed locale.  This may result in its deletion
  jtstackepilog(jt, savcallstack); // handle any remnant on the call stack

  // put the result into the result block.  If there was an error, use the error code as the result.  But make sure the value is non0 so the pyx doesn't wait forever
  C errcode=0;
  if(unlikely(z==0)){errcode=jt->jerr; errcode=(errcode==0)?EVSYSTEM:errcode;}else{rifv(z);}  // realize virtual result before returning it
  jtsetpyxval(jt,pyx,z,errcode);  // report the value and wake up waiting tasks.  Cannot fail.  This protects the arguments in the pyx and frees the pyx from the owner's point of view
  fa(arg1); fa(arg2); if(dyad){fa(arg3);}  // unprotect args only after they have been safely installed
  jtclrtaskrunning(jt);  // clear RUNNING state, possibly after finishing system locks (which is why we wait till the value has been signaled)
  jttpop(jt,old); // clear anything left on the stack after execution, including z
  RESETERR  // we had to keep the error till now; remove it for next time
  // loop back to wait for next task
 }
} 

// Create worker thread n, and call its threadmain to start it in wait state
static I jtthreadcreate(J jt,I n){
 pthread_attr_t attr;  // attributes for the task we will start
 // create thread
 ASSERT(pthread_attr_init(&attr)==0,EVFACE);
 ASSERT(pthread_attr_setdetachstate(&attr,PTHREAD_CREATE_DETACHED)==0,EVFACE)  // default parms, except for DETACHED (which means we will never join() )
 size_t stksiz=CSTACKSIZE;
#if defined(__APPLE__)
 stksiz=pthread_get_stacksize_np(pthread_self());
#elif defined(__linux__) && defined(_GNU_SOURCE)
 pthread_attr_t tattr;  // attributes for the current task
 if(pthread_getattr_np(pthread_self(),&tattr)==0) if(pthread_attr_getstacksize(&tattr,&stksiz)!=0)stksiz=CSTACKSIZE;
#endif
 ASSERT(pthread_attr_setstacksize(&attr,stksiz)==0,EVFACE)    // request sufficient stack size
 ASSERT(pthread_create(&JTFORTHREAD(jt,n)->pthreadid,&attr,jtthreadmain,JTFORTHREAD(jt,n))==0,EVFACE)  // create the thread, save its threadid (by passing its jt into jtthreadmain)
 // since the user may try to use the thread right away, delay until it is available for use.  We use cstackmin as a 99.999% proxy for 'ready'
 while(__atomic_load_n(&JTFORTHREAD(jt,n)->cstackmin,__ATOMIC_ACQUIRE)==0){delay(10000);}  // task startup takes a while
 R 1;
}

// execute the user's task.  Result is a box or a pyx.  Bivalent
static A jttaskrun(J jt,A arg1, A arg2, A arg3){A pyx;
 ARGCHK2(arg1,arg2);  // the verb is not the issue
 I dyad=!(AT(arg2)&VERB); A self=dyad?arg3:arg2;  // the call is either noun self x or noun noun self.  See which set dyad flag and select self.
 // take a thread to run.  if none, just execute & return
 J mjt=MTHREAD(JJTOJ(jt));
 WRITELOCK(mjt->tasklock); J exjt=JTFORTHREAD(jt,mjt->taskidleq); mjt->taskidleq=exjt->taskidleq; WRITEUNLOCK(mjt->tasklock);   // exjt is thread to run; remove from idle q.  If no idle, exjt==mjt
 if(exjt==mjt){
  // there is no idle thread.  Just run the verb in this thread, creating a simple boxed result
  // Get the arg2/arg3 to use for u .  These will be the self of u, possibly repeated if there is no a
  A uarg3=FAV(self)->fgh[0], uarg2=arg2; uarg2=dyad?uarg2:uarg3;  // get self, positioned after the last noun arg
  pyx=(FAV(FAV(self)->fgh[0])->valencefns[dyad])(jt,arg1,uarg2,uarg3);  // execute the u in u t. v
 }else{
  // there is a thread.  start a task there
  // realize virtual arguments; raise the usecount of the arguments including self
  rifv(arg1); ra(arg1); rifv(arg2); ra(arg2); if(dyad){rifv(arg3); ra(arg3);}
  // allocate a result pyx, owned by the executing task, with no timeout limit
  if(unlikely((pyx=jtcreatepyx(jt,THREADID(exjt),inf))==0)){
   // error creating pyx.  Restore the thread to the queue and fail
   WRITELOCK(mjt->tasklock); exjt->taskidleq=mjt->taskidleq; mjt->taskidleq=THREADID(exjt); WRITEUNLOCK(mjt->tasklock); R 0;  // put exjt back on the threas queue and fail.  We could run in our own thread but the system is really sick
  }
  // initialize the task parameters.  First, the ones inherited from this jt
  memcpy(exjt,jt,offsetof(JTT,uflags.us.uq));  // the inherited area
  // Now, the args and pyx
  TASKCOMMREGION(exjt)[0]=arg1; TASKCOMMREGION(exjt)[1]=arg2; TASKCOMMREGION(exjt)[2]=arg3; __atomic_store_n(&TASKCOMMREGION(exjt)[3],pyx,__ATOMIC_RELEASE); 
  // Grab the thread's mutex and wake it up
  WAITBLOK *exwblok=__atomic_load_n(&TASKAWAITBLOK(exjt),__ATOMIC_ACQUIRE);  // get the address of the task's waitblok
  pthread_mutex_lock(&exwblok->mutex); pthread_cond_signal(&exwblok->cond); pthread_mutex_unlock(&exwblok->mutex);
 }
 R pyx;
}
#else
static A jttaskrun(J jt,A arg1, A arg2, A arg3){A pyx;
 ARGCHK2(arg1,arg2);  // the verb is not the issue
 I dyad=!(AT(arg2)&VERB); A self=dyad?arg3:arg2;  // the call is either noun self x or noun noun self.  See which set dyad flag and select self.
 A uarg3=FAV(self)->fgh[0], uarg2=arg2; uarg2=dyad?uarg2:uarg3;  // get self, positioned after the last noun arg
 pyx=(FAV(FAV(self)->fgh[0])->valencefns[dyad])(jt,arg1,uarg2,uarg3);  // execute the u in u t. v
 R pyx;
}
static I jtthreadcreate(J jt,I n){ASSERT(0,EVFACE)}
#endif

// u t. n - start a task.  We just create a verb to handle the arguments, performing <@u
F2(jttdot){F2PREFIP;
 ASSERTVN(a,w);
 ASSERT(AR(w)==1,EVRANK) ASSERT(AN(w)==0,EVLENGTH)  // only '' is allowed as an argument for now
 R atco(ds(CBOX),fdef(0,CTDOT,VERB,jttaskrun,jttaskrun,a,w,0,VFLAGNONE,RMAX,RMAX,RMAX));  // use <@: to get BOXATOP flags
}

// credentials.  These are installed into AM of a synco to indicate the type of a synco
#define CREDMUTEX 0x582a9524c923485f

// x T. y - various thread and task operations
F2(jttcapdot2){A z;
 ARGCHK2(a,w)
 I m; RE(m=i0(a))   // get the x argument, which must be an atom
 switch(m){
 case 4: { // rattle the boxes of y and return status of each
  ASSERT((SGNIF(AT(w),BOXX)|(AN(w)-1))<0,EVDOMAIN)   // must be boxed or empty
  GATV(z,INT,AN(w),AR(w),AS(w)) I *zv=IAV(z); A *wv=AAV(w); // allocate result, zv->result area, wv->input boxes
  DONOUNROLL(AN(w), if(unlikely(!(AT(wv[i])&PYX)))zv[i]=-1001;  // not pyx: _1001
                    else if(((PYXBLOK*)AAV0(wv[i]))->pyxorigthread>=0)zv[i]=((PYXBLOK*)AAV0(wv[i]))->pyxorigthread;  // running pyx: the running thread
                    else if(((PYXBLOK*)AAV0(wv[i]))->errcode>0)zv[i]=-((PYXBLOK*)AAV0(wv[i]))->errcode;  // finished with error: -error code
                    else zv[i]=-1000;  // finished with no error: _1000
  )
  break;}
 case 5: { // create a user pyx.  y is the timeout in seconds
#if PYXES
  ASSERT(AN(w)==1,EVLENGTH) w=cvt(FL,w); D *atimeout=DAV(w); atimeout=*atimeout==0?&inf:atimeout;  // get the timeout value.  If 0, use infinity
  z=box(jtcreatepyx(jt,THREADID(jt),*atimeout));  // create the recursive pyx, owned by this thread
#else
ASSERT(0,EVNONCE)
#endif
  break;}
 case 6: { // set value of pyx.  y is pyx;value
#if PYXES
  ASSERT(AR(w)==1,EVRANK) ASSERT(AN(w)==2,EVLENGTH)  // must be pyx and value
  A pyx=AAV(w)[0], val=C(AAV(w)[1]);  // get the components to store
  ASSERT(AT(pyx)&PYX,EVDOMAIN)
  RZ(jtsetpyxval(jt,pyx,val,0))  // install value.  Will fail if previously set
  z=mtm;  // good quiet value
#else
ASSERT(0,EVNONCE)
#endif
  break;}
 case 7: { // signal error in pyx
#if PYXES
  // set value of pyx.  y is pyx;value
  ASSERT(AR(w)==1,EVRANK) ASSERT(AN(w)==2,EVLENGTH)  // must be pyx and value
  A pyx=AAV(w)[0], val=C(AAV(w)[1]);  // get the components to store
  ASSERT(AT(pyx)&PYX,EVDOMAIN) I err=i0(val); ASSERT(BETWEENC(err,0,255),EVDOMAIN)  // get the error number
  RZ(jtsetpyxval(jt,pyx,0,err))  // install value.  Will fail if previously set
  z=mtm;  // good quiet value
#else
ASSERT(0,EVNONCE)
#endif
  break;}
 case 2:  { // return list of idle threads
  ASSERT(AR(w)==1,EVRANK) ASSERT(AN(w)==0,EVLENGTH)  // only '' is allowed as an argument for now
  GA0(z,INT,MAXTASKS,1) I *zv=IAV1(z);  // Don't allocate under lock, and list may change: so allocate max possible.  Don't use GAT in case MAXTASKS is too big for it
  I threadct=0;  J mjt=MTHREAD(JJTOJ(jt)); J currjt=mjt;  // # threads, master thread, current thread
  WRITELOCK(mjt->tasklock);  while(currjt->taskidleq){zv[threadct++]=currjt->taskidleq; currjt=JTFORTHREAD(jt,currjt->taskidleq);} WRITEUNLOCK(mjt->tasklock);   // copy idle threads to result.  The master can never be idle
  AN(z)=AS(z)[0]=threadct;  // install # idles found
  break;}
 case 3: { // return current thread #
  ASSERT(AR(w)==1,EVRANK) ASSERT(AN(w)==0,EVLENGTH)  // only '' is allowed as an argument for now
  RZ(z=sc(THREADID(jt)))
  break;}
 case 1: { // return number of threads created
  ASSERT(AR(w)==1,EVRANK) ASSERT(AN(w)==0,EVLENGTH)  // only '' is allowed as an argument for now
  RZ(z=sc(JT(jt,nwthreads)))
  break;}
 case 0:  { // create a thread and start it
  ASSERT(AR(w)==1,EVRANK) ASSERT(AN(w)==0,EVLENGTH)  // only '' is allowed as an argument for now
  // reserve a thread#, verify we have enough thread blocks for it
  I resthread=__atomic_add_fetch(&JT(jt,nwthreads),1,__ATOMIC_ACQ_REL);
  if(resthread>=MAXTASKS){__atomic_store_n(&JT(jt,nwthreads),MAXTASKS-1,__ATOMIC_RELEASE); ASSERT(0,EVLIMIT);} //  this leaves the tiniest of timing windows, bfd
  // Try to allocate a thread in the OS and start it running
  I threadstatus=jtthreadcreate(jt,resthread);
  if(threadstatus==0){__atomic_add_fetch(&JT(jt,nwthreads),-1,__ATOMIC_ACQ_REL); z=0;  // if error, restore thread count; error signaled earlier
  }else{
   RZ(z=sc(resthread))  // thread# is result.  The thread installs itself into the idleq when it waits
  }
  break;}
 case 10: {  // create a mutex.  w indicates recursive status
#if PYXES
  I recur; RE(recur=i0(w)) ASSERT((recur&~1)==0,EVDOMAIN)  // recur must be 0 or 1
  GAT0(z,INT,(sizeof(pthread_mutex_t)+SZI-1)>>LGSZI,0); ACINITZAP(z); AM(z)=CREDMUTEX;  // allocate mutex, make it immortal, install credential
  pthread_mutexattr_t mutexattr; ASSERT(pthread_mutexattr_init(&mutexattr)==0,EVFACE) if(recur)ASSERT(pthread_mutexattr_settype(&mutexattr,PTHREAD_MUTEX_RECURSIVE)==0,EVFACE)
  pthread_mutex_init((pthread_mutex_t*)IAV0(z),&mutexattr);
#else
  ASSERT(0,EVNONCE)
#endif
  break;}
 case 11: {  // lock mutex.  w is mutex[;timeout]
#if PYXES
  A mutex=w; D timeout=0.0; I lockfail=0;
  if(AT(w)&BOX){
   ASSERT(AR(w)<=1,EVRANK); ASSERT(BETWEENC(AN(w),1,2),EVLENGTH) mutex=AAV(w)[0];  // pull out mutex
   if(AN(w)==2){A tob=AAV(w)[1]; ASSERT(AN(tob)==1,EVLENGTH) if(!(AT(tob)&FL))RZ(tob=cvt(FL,tob)) timeout=DAV(tob)[0];}  // pull out timeout
  }
  ASSERT(AT(mutex)&INT,EVDOMAIN); ASSERT(AM(mutex)==CREDMUTEX,EVDOMAIN);  // verify valid mutex
  if(timeout==0.0){  // is there a max timeout?
   ASSERT(pthread_mutex_lock((pthread_mutex_t*)IAV0(mutex))==0,EVFACE);
  }else{
   struct timeval nowtime;
   gettimeofday(&nowtime,0);  // system time now
   I tosec=floor(timeout)+nowtime.tv_sec;
   I tousec=(I)(1000000.*(timeout-floor(timeout)))+nowtime.tv_usec;
   struct timespec endtime={tosec+(tousec>=1000000),tousec-1000000*(tousec>=1000000)};  // system time when we give up.  The struct says it uses nsec but it seems to use usec
   I lockrc=pthread_mutex_timedlock((pthread_mutex_t*)IAV0(mutex),&endtime);
   lockfail=lockrc==ETIMEDOUT;  // timeout is a soft failure
   ASSERT((lockrc&(lockfail-1))==0,EVFACE);  // any other non0 is a hard failure
  }
  z=num(lockfail);
#else
  ASSERT(0,EVNONCE)
#endif
  break;}
 case 12: {  // conditionally lock mutex.  w is mutex.  Result is 0 if lock taken, otherwise 1
#if PYXES
  A mutex=w;
  ASSERT(AT(mutex)&INT,EVDOMAIN); ASSERT(AM(mutex)==CREDMUTEX,EVDOMAIN);  // verify valid mutex
  I lockrc=pthread_mutex_trylock((pthread_mutex_t*)IAV0(mutex));
  I lockbusy=lockrc==EBUSY;  // busy is a soft failure
  ASSERT((lockrc&(lockbusy-1))==0,EVFACE);  // any other non0 is a hard failure
  z=num(lockbusy);
#else
  ASSERT(0,EVNONCE)
#endif
  break;}
 case 13: {  // unlock mutex.  w is mutex
#if PYXES
  A mutex=w;
  ASSERT(AT(mutex)&INT,EVDOMAIN); ASSERT(AM(mutex)==CREDMUTEX,EVDOMAIN);  // verify valid mutex
  ASSERT(pthread_mutex_unlock((pthread_mutex_t*)IAV0(mutex))==0,EVFACE);
  z=mtm;
#else
  ASSERT(0,EVNONCE)
#endif
  break;}
 case 14: {  // destroy mutex.  w is mutex
#if PYXES
  A mutex=w;
  ASSERT(AT(mutex)&INT,EVDOMAIN); ASSERT(AM(mutex)==CREDMUTEX,EVDOMAIN);  // verify valid mutex
  ASSERT(pthread_mutex_destroy((pthread_mutex_t*)IAV0(mutex))==0,EVFACE);
  AM(mutex)=0;  // remove credential from modified mutex
  fa(mutex);  // undo the initial INITZAP
  z=mtm;
#else
  ASSERT(0,EVNONCE)
#endif
  break;}
 default: ASSERT(0,EVDOMAIN) break;
 }
 RETF(z);  // return thread#
}
