1:@:(dbr bind Debug)@:(9!:19)2^_44[(prolog [ echo^:ECHOFILENAME) './g200a.ijs'
NB. B ^ B ---------------------------------------------------------------

x=: ?100$2
y=: ?100$2
(x^y) -: (#.x,.y){1 0 1 1
(x^y) -: (z+x)^z+y   [ z=:{.0 4.5
(x^y) -: (z*x)^z*y   [ z=:{.1 4j5
(z^y) -: (($y)$z)^y  [ z=:?2
(x^z) -: x^($x)$z    [ z=:?2

(x^y) -: (40$"0 x)^y [ x=: ?10$2    [ y=: ?10 40$2
(x^y) -: x^40$"0 y   [ x=: ?10 40$2 [ y=: ?10$2

1 0 1 1 -: 0 0 1 1 ^ 0 1 0 1


NB. B ^ I ---------------------------------------------------------------

x=: ?100$2
y=: _1e5+?100$2e5
(x^y) -: (z+x)^z+y   [ z=:{.0 4.5
(x^y) -: (z*x)^z*y   [ z=:{.1 4j5
(z^y) -: (($y)$z)^y  [ z=:?2
(x^z) -: x^($x)$z    [ z=:_1e5+?2e5

(x^y) -: (40$"0 x)^y [ x=: ?10$2    [ y=: _1e5+?10 40$2e5
(x^y) -: x^40$"0 y   [ x=: ?10 40$2 [ y=: _1e5+?10$2e5

_ 0 1 1 -: 0 0 1 1 ^ _4 3 4 _3


NB. B ^ D ---------------------------------------------------------------

x=: ?100$2
y=: o._1e5+?100$2e5
(x^y) -: (z+x)^z+y   [ z=:{.0 4.5
(x^y) -: (z*x)^z*y   [ z=:{.1 4j5
(z^y) -: (($y)$z)^y  [ z=:?2
(x^z) -: x^($x)$z    [ z=:o._1e5+?2e5

(x^y) -: (40$"0 x)^y [ x=: ?10$2    [ y=: o._1e5+?10 40$2e5
(x^y) -: x^40$"0 y   [ x=: ?10 40$2 [ y=: o._1e5+?10$2e5

_ 0 1 1 -: 0 0 1 1 ^ _2.5 1.2 _2.5 1.2


NB. I ^ B ---------------------------------------------------------------

x=: _1e5+?100$2e5
y=: ?100$2
(x^y) -: (z+x)^z+y   [ z=:{.0 4.5
(x^y) -: (z*x)^z*y   [ z=:{.1 4j5
(z^y) -: (($y)$z)^y  [ z=:_1e5+?2e5
(x^z) -: x^($x)$z    [ z=:?2

(x^y) -: (40$"0 x)^y [ x=: _1e5+?10$2e5    [ y=: ?10 40$2
(x^y) -: x^40$"0 y   [ x=: _1e5+?10 40$2e5 [ y=: ?10$2

1 0 1 1  1 _3 1 4 -: 0 0 1 1  _3 _3 4 4 ^ 0 1 0 1  0 1 0 1   
1 2147483647 1 _2147483648 -: 2147483647 2147483647 _2147483648 _2147483648 ^ 0 1 0 1


NB. I ^ I ---------------------------------------------------------------

x=: _1e5+?100$2e5
y=: _10+?100$20
(x^y) -: (z+x)^z+y   [ z=:{.0 4.5
(x^y) -: (z*x)^z*y   [ z=:{.1 4j5
(z^y) -: (($y)$z)^y  [ z=:?2e6
(x^z) -: x^($x)$z    [ z=:_1e5+?2e5

(x^y) -: (40$"0 x)^y [ x=: _1e5+?10   $2e5 [ y=: _10+?10 40$20
(x^y) -: x^40$"0 y   [ x=: _1e5+?10 40$2e5 [ y=: _10+?10   $20

1r9 0.25 1 6 49 -: 3 4 5 6 7 ^ _2 _1 0 1 2
1 _5 1 6 -: _5 _5 6 6 ^ 0 1 0 1+4-4
1  10 100  1000 1e4  1e5 1e6  1e7 1e8  1e9 -:  10^i.10
1 _10 100 _1000 1e4 _1e5 1e6 _1e7 1e8 _1e9 -: _10^i.10


NB. I ^ D ---------------------------------------------------------------

x=: _1e5+?100$2e5
y=: 1e_4*_1e5+?100$2e5
(x^y) -: (z+x)^z+y   [ z=:{.0 4.5
(x^y) -: (z*x)^z*y   [ z=:{.1 4j5
(z^y) -: (($y)$z)^y  [ z=:?2e6
(x^z) -: x^($x)$z    [ z=:1e_4*_1e5+?2e5

(x^y) -: (40$"0 x)^y [ x=: _1e5+?10   $2e5 [ y=: 1e_4*_1e5+?10 40$2e5
(x^y) -: x^40$"0 y   [ x=: _1e5+?10 40$2e5 [ y=: 1e_4*_1e5+?10   $2e5

0j1 0 1 -: _1 0 1^0.5
1.41421356237309504880 -: 2^0.5
1.61803398874989482820 -: -:>:5^0.5


NB. D ^ B ---------------------------------------------------------------

x=: o._1e5+?100$2e5
y=: ?100$2
(x^y) -: (z+x)^z+y   [ z=:{.0 4.5
(x^y) -: (z*x)^z*y   [ z=:{.1 4j5
(z^y) -: (($y)$z)^y  [ z=:o._1e5+?2e5
(x^z) -: x^($x)$z    [ z=:?2

(x^y) -: (40$"0 x)^y [ x=: o._1e5+?10   $2e5 [ y=: ?10 40$2
(x^y) -: x^40$"0 y   [ x=: o._1e5+?10 40$2e5 [ y=: ?10   $2

 0.25 1 -:  0.25 ^ 1 0
_0.25 1 -: _0.25 ^ 1 0


NB. D ^ I ---------------------------------------------------------------

x=: o._1e5+?100$2e5
y=: _10+?100$20
(x^y) -: (z+x)^z+y   [ z=:{.0 4.5
(x^y) -: (z*x)^z*y   [ z=:{.1 4j5
(z^y) -: (($y)$z)^y  [ z=:o._1e5+?2e5
(x^z) -: x^($x)$z    [ z=:_10+?20

(x^y) -: (40$"0 x)^y [ x=: o._1e5+?10   $2e5 [ y=: _10+?10 40$20
(x^y) -: x^40$"0 y   [ x=: o._1e5+?10 40$2e5 [ y=: _10+?10   $20

4  2 1  0.5 0.25 -:  0.5 ^ _2 _1 0 1 2                 
4 _2 1 _0.5 0.25 -: _0.5 ^ _2 _1 0 1 2                 


NB. D ^ D ---------------------------------------------------------------

x=: o._1e5+?100$2e5
y=: 1e_4*_1e5+?100$2e5
(x^y) -: (z+x)^z+y   [ z=:{.0 4.5
(x^y) -: (z*x)^z*y   [ z=:{.1 4j5
(z^y) -: (($y)$z)^y  [ z=:1e_4*_1e5+?2e5
(x^z) -: x^($x)$z    [ z=:1e_4*_1e5+?2e5

(x^y) -: (40$"0 x)^y [ x=: o._1e5+?10   $2e5 [ y=: 1e_4*_1e5+?10 40$2e5
(x^y) -: x^40$"0 y   [ x=: o._1e5+?10 40$2e5 [ y=: 1e_4*_1e5+?10   $2e5

0j1.41421356237309504880 4 -: _2 0.5 ^ 0.5 _2

4!:55 ;:'x y z'


