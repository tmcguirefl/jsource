1:@:(dbr bind Debug)@:(9!:19)2^_44[(prolog [ echo^:ECHOFILENAME) './g5x30.ijs'
NB. 5!:30 ---------------------------------------------------------------

9!:17 (0 0)
cr  =: 13{a.
lf  =: 10{a.
crlf=: 13 10{a.

f   =: 5!:30

dtb =: -@(+/"1)@(*./\."1)@(' '&=) <@}."_1 ]
g   =: ; @: (,&lf&.>) @: dtb @: (1 1&}.) @: (_1 _1&}.) @: ": @: <

t=: 0 250 _ _ f x=: i.4 5
t -: ,(":i.4 5),.lf

t=: 0 250 5 10 f x=: i.300
t -: (250{.":x),'...',lf

t=: 0 _ _ _ f x=: ?2 3 4 5 3$1e6
t -: g x

t=: 0 250 5 10 f i.40 1
16 = +/ t=lf
t -: (,' ',.'01234',.lf),'...',lf,,(2":30+i.10 1),.lf

t=: 0 _ 5 10 f x=: lf (100?2000)}2000$'x'
16 = +/ t=lf
i =: 1 i.~ '...' E. t
t -: (i{.x),'...',lf,(((5+i)-#t){.x),lf

('a',LF,LF,'b',LF,'c',LF) -: (0 40 1 1) 5!:30 'a',LF,LF,'b',LF,'c'
('a',LF,LF,'bc',LF,'c',LF) -: (0 40 1 1) 5!:30 'a',LF,LF,'bc',LF,'c'
('a',LF,'...',LF,'c',LF) -: (0 40 1 1) 5!:30 'a',LF,LF,'bcd',LF,'c'
('a',CR,LF,CR,LF,'b',CR,LF,'c',CR,LF) -: (1 40 1 1) 5!:30 'a',LF,LF,'b',LF,'c'
('a',CR,LF,'...',CR,LF,'c',CR,LF) -: (1 40 1 1) 5!:30 'a',LF,LF,'bc',LF,'c'

NB. literal2
u1 =: (u: 16b03c0),'r2'
u2 =: 'abc'
(207 128 114 50 10 97 98 99 10 { a.) -: (0 40 20 20)  5!:30 u1,:u2
(207 128 114 50 10 97 32 32 10 97 98 99 10 10 98 10{a.) -: 0 40 20 20 (5!:30) (u1,LF,'a') ,: u2,CR,CRLF,'b'

NB. literal4
u1 =: (10&u: 16b03c0),'r2'
u2 =: 'abc'
(207 128 114 50 10 97 98 99 10 { a.) -: (0 40 20 20)  5!:30 u1,:u2
(207 128 114 50 10 97 32 32 10 97 98 99 10 10 98 10 { a.) -: 0 40 20 20 (5!:30) (u1,LF,'a') ,: u2,CR,CRLF,'b'

NB. symbol
(96 66 10 { a.) -: (0 60 20 20) 5!:30 [ s: a.{~ 0 66

NB. atoms are equal but storage type and display different
NB. only one of them is present in the global string table
((96 194 190 10 { a.);(96 190 10 { a.)) e.~ < (0 60 20 20) 5!:30 [ s: a.{~ 0 190
((96 194 190 10 { a.);(96 190 10 { a.)) e.~ < (0 60 20 20) 5!:30 [ s: u: 0 190

(96 196 172 10 { a.) -: (0 60 20 20) 5!:30 [ s: u: 0 300
(96 240 159 152 128 10 { a.) -: (0 60 20 20) 5!:30 [ s: 10&u: 0 16b1f600

u1 =: s: (a.{~ 0 66 ),(u: 0 290 0 30000 30001), (10&u: 0 16b1f600 0 30002 0 292)
(96 66 32 96 196 162 32 96 231 148 176 231 148 177 32 96 240 159 152 128 32 96 231 148 178 32 96 196 164 10 { a.) -: (0 60 20 20) 5!:30 u1
(96 66 32 32 32 32 96 196 162 32 32 10 96 231 148 176 231 148 177 32 96 240 159 152 128 10 { a.) -: (0 60 20 20) 5!:30 [ 2 2 $ u1
({&a.)@:". ;._2 (0 : 0) -: (0 60 20 20) 5!:30 [ 3 5 $ u1
 96  66  32  32  96 196 162  32  96 231
148 176 231 148 177  32  96 240 159 152
128  32  32  32  96 231 148 178  32  32
 10  96 196 164  32  32  96  66  32  96
196 162  32  32  32  32  96 231 148 176
231 148 177  32  96 240 159 152 128  32
 32  10  96 231 148 178  32  96 196 164
 32  96  66  32  32  32  32  96 196 162
 32  32  32  32  96 231 148 176 231 148
177  32  10
)

bc =: 9!:6 ''
9!:7 (16+i.11) { a.

226 148 140 226 148 128 226 148 128 226 148 144 10 226 148 130 240 159 152 128 226 148 130 10 226 148 148 226 148 128 226 148 128 226 148 152 10 -: a.i.(0 40 20 20) (5!:30) < 10&u: 16b1f600

u1 =: (u: 16b03c0),'r2'
(0 : 0) -: (0 40 20 20)  5!:30 <u1
┌───┐
│πr2│
└───┘
)
(0 : 0) -: (0 40 20 20)  5!:30  ,.~(<'abcdéf'),:<>'ab';'aéé';'asdf'
┌──────┬──────┐
│abcdéf│abcdéf│
├──────┼──────┤
│ab    │ab    │
│aéé   │aéé   │
│asdf  │asdf  │
└──────┴──────┘
)
(0 : 0) -: (0 40 20 20)  5!:30  ,.~(<'aéf'),:<>'ab';'aéé';'asdf'
┌─────┬─────┐
│aéf  │aéf  │
├─────┼─────┤
│ab   │ab   │
│aéé  │aéé  │
│asdf │asdf │
└─────┴─────┘
)
(0 : 0) -: (0 40 20 20)  5!:30  ('abcdéf';2 4$'aéc'),.(<'é'),:<>'ab';'aéé';'asdf';'é';,'é'
┌──────┬─────┐
│abcdéf│é    │
├──────┼─────┤
│aéc   │ab   │
│aéc   │aéé  │
│      │asdf │
│      │é    │
│      │é    │
└──────┴─────┘
)
   9!:17 (1 0)

(0 : 0) -: (0 40 20 20)  5!:30     ('abcdéf';2 4$'aéc'),.(<'é'),:<>'ab';'aéé';'asdf';'é';,'é'
┌──────┬─────┐
│abcdéf│é    │
├──────┼─────┤
│      │ab   │
│aéc   │aéé  │
│aéc   │asdf │
│      │é    │
│      │é    │
└──────┴─────┘
)
   9!:17 (2 0)

(0 : 0) -: (0 40 20 20)  5!:30     ('abcdéf';2 4$'aéc'),.(<'é'),:<>'ab';'aéé';'asdf';'é';,'é'
┌──────┬─────┐
│abcdéf│é    │
├──────┼─────┤
│      │ab   │
│      │aéé  │
│      │asdf │
│aéc   │é    │
│aéc   │é    │
└──────┴─────┘
)
   9!:17 (0 1)

(0 : 0) -: (0 40 20 20)  5!:30     ('abcdéf';2 4$'aéc'),.(<'é'),:<>'ab';'aéé';'asdf';'é';,'é'
┌──────┬─────┐
│abcdéf│  é  │
├──────┼─────┤
│ aéc  │ab   │
│ aéc  │aéé  │
│      │asdf │
│      │é    │
│      │é    │
└──────┴─────┘
)
   9!:17 (0 2)

(0 : 0) -: (0 40 20 20)  5!:30     ('abcdéf';2 4$'aéc'),.(<'é'),:<>'ab';'aéé';'asdf';'é';,'é'
┌──────┬─────┐
│abcdéf│    é│
├──────┼─────┤
│   aéc│ab   │
│   aéc│aéé  │
│      │asdf │
│      │é    │
│      │é    │
└──────┴─────┘
)
   9!:17 (1 1)

(0 : 0) -: (0 40 20 20)  5!:30     ('abcdéf';2 4$'aéc'),.(<'é'),:<>'ab';'aéé';'asdf';'é';,'é'
┌──────┬─────┐
│abcdéf│  é  │
├──────┼─────┤
│      │ab   │
│ aéc  │aéé  │
│ aéc  │asdf │
│      │é    │
│      │é    │
└──────┴─────┘
)
   9!:17 (2 2)

(0 : 0) -: (0 40 20 20)  5!:30     ('abcdéf';2 4$'aéc'),.(<'é'),:<>'ab';'aéé';'asdf';'é';,'é'
┌──────┬─────┐
│abcdéf│    é│
├──────┼─────┤
│      │ab   │
│      │aéé  │
│      │asdf │
│   aéc│é    │
│   aéc│é    │
└──────┴─────┘
)
   9!:17 (1 2)

(0 : 0) -: (0 40 20 20)  5!:30     ('abcdéf';2 4$'aéc'),.(<'é'),:<>'ab';'aéé';'asdf';'é';,'é'
┌──────┬─────┐
│abcdéf│    é│
├──────┼─────┤
│      │ab   │
│   aéc│aéé  │
│   aéc│asdf │
│      │é    │
│      │é    │
└──────┴─────┘
)
9!:17 (0 0)
(0 : 0) -: (0 40 20 20)  (5!:30)    1 ; (i. 4 2) ;< ('abcdéf';2 4$'aéc'),.(<'é'),:<>'ab';'aéé';'asdf';'é';,'é'
┌─┬───┬──────────────┐
│1│0 1│┌──────┬─────┐│
│ │2 3││abcdéf│é    ││
│ │4 5│├──────┼─────┤│
│ │6 7││aéc   │ab   ││
│ │   ││aéc   │aéé  ││
│ │   ││      │asdf ││
│ │   ││      │é    ││
│ │   ││      │é    ││
│ │   │└──────┴─────┘│
└─┴───┴──────────────┘
)

(0 : 0) -: (0 60 20 20) 5!:30 [ < 3 3$s: <;._1'/a/bc/de/fghi'
┌───────────────┐
│`a    `bc   `de│
│`fghi `a    `bc│
│`de   `fghi `a │
└───────────────┘
)

(0 : 0) -: (0 60 20 20) 5!:30 [ < 3 3$s: <;._1'/a/bc/dé/fghi'
┌────────────────┐
│`a    `bc   `dé│
│`fghi `a    `bc │
│`dé   `fghi `a │
└────────────────┘
)


9!:7 bc

'domain error' -: 'abc'       5!:30 etx 4 5 6
'domain error' -: (1 2 3 4.5) 5!:30 etx 4 5 6
'domain error' -: (1 2 3 4j5) 5!:30 etx 4 5 6
'domain error' -: (1 2 3 4r5) 5!:30 etx 4 5 6
'domain error' -: (1;2;3;455) 5!:30 etx 4 5 6

'domain error' -: (0 _1 9 9 ) 5!:30 etx 4 5 6
'domain error' -: (0 9 _1 9 ) 5!:30 etx 4 5 6
'domain error' -: (0 9 9 _1 ) 5!:30 etx 4 5 6

'rank error'   -: (1        ) 5!:30 etx 4 5 6
'rank error'   -: (,:1 2 3 4) 5!:30 etx 4 5 6

'length error' -: (i.5      ) 5!:30 etx 4 5 6
'length error' -: (i.3      ) 5!:30 etx 4 5 6

'index error'  -: (3 10 10 9) 5!:30 etx 4 5 6


4!:55 ;:'bc cr crlf dtb f g i lf t u1 u2 x'


