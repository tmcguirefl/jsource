1:@:(dbr bind Debug)@:(9!:19)2^_44[(prolog [ echo^:ECHOFILENAME) './gspx.ijs'
NB. 3!: -----------------------------------------------------------------

1024  -: 3!:0 $.  ?10    $2
4096  -: 3!:0 $.  ?10 3  $20
8192  -: 3!:0 $.o.?10 3 4$20
16384 -: 3!:0 $.j.?10 2  $20

x=: 1$.1e8 2e8 3e8;0 1;o.0
x -: 3!:2 (3!:1) x
x -: 3!:2 (3!:3) x

c=: ; (i.1+r) <"1@comb&.>r=:4

f=: 3 : '(*./ scheck t) *. d -: t=: (3!:2)   (3!:1) s=:(2;y)$.d'
g=: 3 : '(*./ scheck t) *. d -: t=: (3!:2)   (3!:3) s=:(2;y)$.d'

f&>c [ d=: (?5 7  $2) * ?(r$5 7 3 2)$4
g&>c
f&>c [ d=: o. d
g&>c
f&>c [ d=: (?(_2}.$d)$2) * j./?(2,$d)$4
g&>c
f&>c [ d=: (?(_2}.$d)$2) * ?($d)$2
g&>c

f=: 3 : '(*./ scheck t) *. d -: t=: (3!:2) 0&(3!:1) s=:(2;y)$.d'
g=: 3 : '(*./ scheck t) *. d -: t=: (3!:2) 0&(3!:3) s=:(2;y)$.d'

f&>c [ d=: (?(_2}.$d)$2) * ?(r$5 7 3 2)$4
g&>c
f&>c [ d=: o. d
g&>c
f&>c [ d=: (?(_2}.$d)$2) * j./?(2,$d)$4
g&>c
f&>c [ d=: (?(_2}.$d)$2) * ?($d)$2
g&>c

f=: 3 : '(*./ scheck t) *. d -: t=: (3!:2) 1&(3!:1) s=:(2;y)$.d'
g=: 3 : '(*./ scheck t) *. d -: t=: (3!:2) 1&(3!:3) s=:(2;y)$.d'

f&>c [ d=: (?(_2}.$d)$2) * ?(r$5 7 3 2)$4
g&>c
f&>c [ d=: o. d
g&>c
f&>c [ d=: (?(_2}.$d)$2) * j./?(2,$d)$4
g&>c
f&>c [ d=: (?(_2}.$d)$2) * ?($d)$2
g&>c

f=: 3 : '(*./ scheck t) *. d -: t=: (3!:2) 10&(3!:1) s=:(2;y)$.d'
g=: 3 : '(*./ scheck t) *. d -: t=: (3!:2) 10&(3!:3) s=:(2;y)$.d'

f&>c [ d=: (?(_2}.$d)$2) * ?(r$5 7 3 2)$4
g&>c
f&>c [ d=: o. d
g&>c
f&>c [ d=: (?(_2}.$d)$2) * j./?(2,$d)$4
g&>c
f&>c [ d=: (?(_2}.$d)$2) * ?($d)$2
g&>c

f=: 3 : '(*./ scheck t) *. d -: t=: (3!:2) 11&(3!:1) s=:(2;y)$.d'
g=: 3 : '(*./ scheck t) *. d -: t=: (3!:2) 11&(3!:3) s=:(2;y)$.d'

f&>c [ d=: (?(_2}.$d)$2) * ?(r$5 7 3 2)$4
g&>c
f&>c [ d=: o. d
g&>c
f&>c [ d=: (?(_2}.$d)$2) * j./?(2,$d)$4
g&>c
f&>c [ d=: (?(_2}.$d)$2) * ?($d)$2
g&>c


NB. 128!: ---------------------------------------------------------------

'nonce error' -: 128!:0 etx $.  ?10 3$2
'nonce error' -: 128!:0 etx $.  ?10 3$20
'nonce error' -: 128!:0 etx $.o.?10 3$20
'nonce error' -: 128!:0 etx $.j.?10 3$20

('nonce error';'non-unique sparse elements') e.~< 128!:1 etx $.  ?10 10$2
('nonce error';'non-unique sparse elements') e.~< 128!:1 etx $.  ?10 10$20
('nonce error';'non-unique sparse elements') e.~< 128!:1 etx $.o.?10 10$20
('nonce error';'non-unique sparse elements') e.~< 128!:1 etx $.j.?10 10$20


4!:55 ;:'c d f g r s t x'


