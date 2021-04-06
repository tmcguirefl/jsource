/* Copyright 1990-2018, Jsoftware Inc.  All rights reserved.               */
/* Licensed use only. Any other use is in violation of copyright.          */
/*                                                                         */
/* Global Variables                                                        */

#include "j.h"
#include "jversion.h"
#include "gemm.h"
#include <math.h>
#pragma warning(disable : 4056)  // negative infinity overflow

// globals start - set by globinit in initialization
struct Bd2 {I hdr[AKXR(0)/SZI]; D v[2];};
#define CREBLOCKATOMV2(name,t,v1,v2) struct Bd2 B##name={{AKXR(0),(t)&TRAVERSIBLE,0,(t),ACPERMANENT,1,0},{v1,v2}};
CREBLOCKATOMV2(a0j1,CMPX,0.0,1.0)  // 0j1
#if SY_64
#define CBAIVAL(t,v) {7*SZI,(t)&TRAVERSIBLE,0,(t),ACPERMANENT,1,0,(v)}
#else
#define CBAIVAL(t,v) {8*SZI,(t)&TRAVERSIBLE,0,(t),ACPERMANENT,1,0,0,(v)}
#endif
#define CREBLOCKATOMI(name,t,v) I __attribute__((aligned(CACHELINESIZE))) B##name[9-SY_64]=CBAIVAL(t,v);
#define CREBLOCKVEC0(name,t) I __attribute__((aligned(CACHELINESIZE))) B##name[8]={8*SZI,(t)&TRAVERSIBLE,0,(t),ACPERMANENT,0,1,0};  // no padding at end - no atoms should be referenced
CREBLOCKVEC0(aqq,LIT)  // ''
CREBLOCKVEC0(mtv,B01)  // i.0 boolean
#define CREBLOCKATOMV1(name,t,v1) struct Bd1 __attribute__((aligned(CACHELINESIZE))) B##name={{AKXR(0),(t)&TRAVERSIBLE,0,(t),ACPERMANENT,1,0},{v1}};
CREBLOCKATOMV1(onehalf,FL,0.5)  // 0.5
CREBLOCKATOMV1(ainf,FL,INFINITY)  // _
CREBLOCKATOMV1(pie,FL,PI)  // PI
CREBLOCKATOMI(asgnlocsimp,ASGN+ASGNLOCAL+ASGNTONAME,CASGN)    // =. flagged as LOCAL+NAME
CREBLOCKATOMI(asgngloname,ASGN+ASGNTONAME,CGASGN)    // =: flagged as NAME
CREBLOCKATOMI(asgnforcegloname,ASGN+ASGNTONAME,CASGN)  // =. converted to global+NAME
CREBLOCKATOMI(asgnforceglo,ASGN,CASGN)  // =. converted to global
CREBLOCKATOMI(mark,MARK,0)  // parser mark, also used generally as a special value
CREBLOCKATOMI(imax,INT,IMAX)  // max positive value
CREBLOCKATOMI(chrcolon,LIT,':')  // the one character
CREBLOCKATOMI(chrspace,LIT,' ')  // the one character
D   inf=INFINITY;                /* _                                    */
D   infm=-INFINITY;               /* __                                   */
#define CREBLOCKVEC1I(name,t,v) I __attribute__((aligned(CACHELINESIZE))) B##name[9]={(7+1)*SZI,(t)&TRAVERSIBLE,0,(t),ACPERMANENT,1,1,1,(v)};
CREBLOCKVEC1I(iv0,INT,0)    /* ,0   also extended integer 0                                */
CREBLOCKVEC1I(iv1,INT,1)     /* ,1   also extended integer 1                                */
#define CREBLOCKVEC2I(name,t) I __attribute__((aligned(CACHELINESIZE)))  B##name[9]={(7+2)*SZI,(t)&TRAVERSIBLE,0,(t),ACPERMANENT,0,2,0,0};
CREBLOCKVEC2I(mtm,B01)    /* ,0   also extended integer 0                                */
D   jnan=NAN;               /* _.                                   */
A   mnuvxynam[6]={0,0,0,0,0,0};   // name blocks for all arg names
// validitymask is used mostly to set a sequence of all1/all0 words in a ymm reg.  We also use it as a read-only area containing
// 0 or 1 fields.  We put all those fields over validitymask so that we use just one cacheline for all the uses.  The mappings into
// validitymask are in jtype.h
#if !SY_64
long long validitymask[16]={-1, -1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 0,0,0,0,0};  // maskload expect s64x2 mask
#elif C_AVX || EMU_AVX || EMU_AVX2
I __attribute__((aligned(CACHELINESIZE))) validitymask[16]={-1, -1, -1, -1, 0, 0, 0, 0, -1, -1, -1, -1,0,0,0,0};  // allows inverted mask
#else
I __attribute__((aligned(CACHELINESIZE))) validitymask[16]={-1, -1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 0,0,0,0,0};  // native ss2/neon register is s64x2
#endif

I Bnum[22][9-SY_64] = {  // the numbers we keep at hand.  0 and 1 are B01, the rest INT; but the first 2 are integer forms of 0 and 1
CBAIVAL(INT,0), CBAIVAL(INT,1),
CBAIVAL(INT,-10), CBAIVAL(INT,-9), CBAIVAL(INT,-8), CBAIVAL(INT,-7), CBAIVAL(INT,-6), CBAIVAL(INT,-5), CBAIVAL(INT,-4), CBAIVAL(INT,-3), CBAIVAL(INT,-2), CBAIVAL(INT,-1), 
CBAIVAL(B01,0), CBAIVAL(B01,1),
CBAIVAL(INT,2), CBAIVAL(INT,3), CBAIVAL(INT,4), CBAIVAL(INT,5), CBAIVAL(INT,6), CBAIVAL(INT,7), CBAIVAL(INT,8), CBAIVAL(INT,9)
};

struct Bd1 Bnumvr[3] = {  // floating-point 0, 1, and 2, used for constants
{{AKXR(0),FL&TRAVERSIBLE,0,FL,ACPERMANENT,1,0},0.0},
{{AKXR(0),FL&TRAVERSIBLE,0,FL,ACPERMANENT,1,0},1.0},
{{AKXR(0),FL&TRAVERSIBLE,0,FL,ACPERMANENT,1,0},2.0}
};
//I   v00[2]={0,0};         // vector value to use for rank 0 0
A   __attribute__((aligned(32))) fillvalues[4]={(A)0x20,mtv,iv0,iv1};  // values to use for fills: char, box, xnum, rat
D   pf=0;                 /* performance frequency                */
// we now take zeroQ out of fillvalues Q   zeroQ={iv0,iv1};          /* 0r1                                  */
DX  zeroDX={0,0,iv1};       /* 0                                    */
Z   zeroZ={0,0};          /* 0j0                                  */
I   iotavec[IOTAVECLEN];  // return values for i. small
uint64_t g_cpuFeatures;   // blis
UC  hwaes=0;              // hardware aes support
UC  hwfma=0;              // blis cpu tuning
// globals end

// global const start -  do not need globinit
//!      I   v00[2]={0,0};         // vector value to use for rank 0 0
// const UC  bit[8]={(UC)0x80, (UC)0x40, (UC)0x20, (UC)0x10, (UC)0x08, (UC)0x04, (UC)0x02, (UC)0x01};
const double dzero=0.0;   // used by gemm
const dcomplex zone={1.0,0.0};  // used gy gemm
const dcomplex zzero={0.0,0.0};
I oneone[2]={1,1};  // used by PROD

// For each Type, the length of a data-item of that type.  The order
// here is by number of trailing 0s in the (32-bit) type; aka the bit-number index.
// Example: LITX is 1, so location 1 contains sizeof(C)
#define TPSZ(name) [name##X] = name##SIZE
const __attribute__((aligned(32))) UC typesizes[32] = {
TPSZ(B01), TPSZ(LIT), TPSZ(INT), TPSZ(FL), TPSZ(CMPX), TPSZ(BOX), TPSZ(XNUM), TPSZ(RAT), 
TPSZ(SB01), TPSZ(SLIT), TPSZ(SINT), TPSZ(SFL), TPSZ(SCMPX), TPSZ(SBOX), TPSZ(SBT), TPSZ(C2T), 
TPSZ(C4T), TPSZ(ASGN), TPSZ(MARK), TPSZ(NAME), TPSZ(SYMB), TPSZ(CONW), TPSZ(LPAR), TPSZ(RPAR), 
[ADVX] = INTSIZE, [CONJX] = INTSIZE, [VERBX] = INTSIZE  // note ACV sizes are in INTs
};

// global const end 


#if SY_64
#define bits "64"
#else
#define bits "32"
#endif

#if C_AVX2
#define hw "avx2"
#else
#if C_AVX
#define hw "avx"
#else
#define hw ""
#endif
#endif

const char jeversion[]= "je9!:14 j"jversion"/j"bits""hw"/"jplatform"/"jtype"/"jlicense"/"jbuilder"/"__DATE__"T"__TIME__;

F1(jtversq){
 char m[1000];char d[21]; char months[] = "Jan01Feb02Mar03Apr04May05Jun06Jul07Aug08Sep09Oct10Nov11Dec12"; C* p; C* q;
 ASSERTMTV(w);
 strcpy(m,jeversion+8);
 p= m+strlen(m)-20;
 strcpy(d,p);
 *p=0;
 if(' '== d[4]) d[4] = '0';
 strncat(p,d+7,4);
 strcat(p,"-");
 d[3] = 0;
 q= strstr(months,d);
 strncat(p,3 + strstr(months,d),2);
 strcat(p,"-");
 strncat(p,d + 4,2);
 strcat(p,d+11);
#if defined(__clang__)
 strcat(p, "/clang-");
 sprintf(p + strlen(p), "%i", __clang_major__);
 strcat(p, "-");
 sprintf(p + strlen(p), "%i", __clang_minor__);
 strcat(p, "-");
 sprintf(p + strlen(p), "%i", __clang_patchlevel__);
#elif defined(_MSC_FULL_VER)
 strcat(p, "/ms-");
 sprintf(p + strlen(p), "%i", _MSC_FULL_VER);
#elif defined(__GNUC__)
 strcat(p, "/gcc-");
 sprintf(p + strlen(p), "%i", __GNUC__);
 strcat(p, "-");
 sprintf(p + strlen(p), "%i", __GNUC_MINOR__);
#endif
 
#if SLEEF
 strcat(p,"/SLEEF=1");
#else
 strcat(p,"/SLEEF=0");
#endif
 R cstr(m);
}
