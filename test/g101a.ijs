1:@:(dbr bind Debug)@:(9!:19)2^_44[(prolog [ echo^:ECHOFILENAME) './g101a.ijs'
NB. B +. B --------------------------------------------------------------

x=: ?100$2
y=: ?100$2
(x+.y) -: (#.x,.y){0 1 1 1
(x+.y) -: (z+x)+.z+y   [ z=:{.0 4.5
(z+.y) -: (($y)$z)+.y  [ z=:?2
(x+.z) -: x+.($x)$z    [ z=:?2

(x+.y) -: (40$"0 x)+.y [ x=: ?10$2    [ y=: ?10 40$2
(x+.y) -: x+.40$"0 y   [ x=: ?10 40$2 [ y=: ?10$2

0 1 1 1 -: 0 0 1 1 +. 0 1 0 1


NB. B +. I --------------------------------------------------------------

x=: ?100$2
y=: ?100$2e5
(x+.y) -: (z+x)+.z+y   [ z=:{.0 4.5
(z+.y) -: (($y)$z)+.y  [ z=:?2
(x+.z) -: x+.($x)$z    [ z=:?2e5

(x+.y) -: (40$"0 x)+.y [ x=: ?10$2    [ y=: _1e5+?10 40$2e5
(x+.y) -: x+.40$"0 y   [ x=: ?10 40$2 [ y=: _1e5+?10$2e5

0 1 1 1 -: 0 0 1 1 +. 0 1 0 1+4-4


NB. I +. B --------------------------------------------------------------

x=: _1e5+?100$2e5
y=: ?100$2
(x+.y) -: (z+x)+.z+y   [ z=:{.0 4.5
(z+.y) -: (($y)$z)+.y  [ z=:_1e5+?2e5
(x+.z) -: x+.($x)$z    [ z=:?2

(x+.y) -: (40$"0 x)+.y [ x=: _1e5+?10$2e5    [ y=: ?10 40$2
(x+.y) -: x+.40$"0 y   [ x=: _1e5+?10 40$2e5 [ y=: ?10$2

0 1 1 1 -: (0 0 1 1+3-3) +. 0 1 0 1


NB. I +. I --------------------------------------------------------------

x=: _1e5+?100$2e5
y=: _1e5+?100$2e5
(x+.y) -: (z+x)+.z+y   [ z=:{.0 4.5
(z+.y) -: (($y)$z)+.y  [ z=:_1e5+?2e5
(x+.z) -: x+.($x)$z    [ z=:_1e5+?2e5

(x+.y) -: (40$"0 x)+.y [ x=: _1e5+?10$2e5    [ y=: _1e5+?10 40$2e5
(x+.y) -: x+.40$"0 y   [ x=: _1e5+?10 40$2e5 [ y=: _1e5+?10$2e5

0 1 1 1 -: (0 0 1 1+3-3) +. 0 1 0 1+3-3

'domain error' -: 1   +. etx 'chthonic'
'domain error' -: 0 0 +. etx ;:'sui generis'
'domain error' -: 1   +. etx u:'chthonic'
'domain error' -: 0 0 +. etx u:&.> ;:'sui generis'
'domain error' -: 1   +. etx 10&u:'chthonic'
'domain error' -: 0 0 +. etx 10&u:&.> ;:'sui generis'
'domain error' -: 1   +. etx s:@<"0 'chthonic'
'domain error' -: 0 0 +. etx s:@<"0&.> ;:'sui generis'
'domain error' -: 0 0 +. etx <"0@s: ;:'sui generis'

4!:55 ;:'x y z'


