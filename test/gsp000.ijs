1:@:(dbr bind Debug)@:(9!:19)2^_44[(prolog [ echo^:ECHOFILENAME) './gsp000.ijs'
NB. = monad -------------------------------------------------------------

f=: 3 : '(scheck t) *. (=p) -: t=: =s=: (2;y)$.p'

c=: ; (i.1+r) <"1@comb&.>r=: 4
f&> c [ p=: (?200$100) { (?100 4 5$2) *    ?  100 4 5 3$2
f&> c [ p=: (?200$100) { (?100 4 5$2) *    ?  100 4 5 3$100
f&> c [ p=: (?100$ 50) { (? 50 4 5$2) * o. ?   50 4 5 3$100
f&> c [ p=: (?100$ 50) { (? 50 4 5$2) * j./?2  50 4 5 3$100

c=: ; (i.1+r) <"1@comb&.>r=: 3
f&> c [ p=:                          ?100 4 5$1000
f&> c [ p=:                   0 (0)} ?100 4 5$1000
f&> c [ p=:                   0 (9)} ?100 4 5$1000
f&> c [ p=:                   0    * ?100 4 5$1000
f&> c [ p=: (?200$100) {             ?100 4 5$1000
f&> c [ p=: (?200$100) {(?100 4$2) * ?100 4 5$1000

(=$.p) -: =p=: i.0
(=$.p) -: =p=: i.0 5
(=$.p) -: =p=: i.5 0


NB. =  dyad -------------------------------------------------------------

f=: 4 : '(scheck t) *. (p=q) -: t=: ((2;x)$.p) = (2;y)$.q'

p=: ?2 4 5 3$2
q=: ?2 4 5 3$2
c=: ; (i.1+r) <"1@comb&.>r=:#$p
f&>/~c

p=: ?2 4 5 3$4
q=: ?2 4 5 3$4
c=: ; (i.1+r) <"1@comb&.>r=:#$p
f&>/~c

p=: o.?2 4 5 3$4
q=: o.?2 4 5 3$4
c=: ; (i.1+r) <"1@comb&.>r=:#$p
f&>/~c

p=: j./?2 2 4 5 3$4
q=: j./?2 2 4 5 3$4
c=: ; (i.1+r) <"1@comb&.>r=:#$p
f&>/~c


4!:55 ;:'c f p q r s t'


