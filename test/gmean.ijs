1:@:(dbr bind Debug)@:(9!:19)2^_44[(prolog [ echo^:ECHOFILENAME) './gmean.ijs'
NB. (+/%#)"r ------------------------------------------------------------

mean=: 3 : '(+/y)%#y'

f=: 4 : 0
 r=: x
 yy=: y
 assert. (mean"r -: (+/%#)"r) y
 if. r do.
  assert. (mean"r -: (+/%#)"r) 0{."r y
  assert. (mean"r -: (+/%#)"r) 1{."r y
  assert. (mean"r -: (+/%#)"r) 2{."r y
  assert. (mean"r -: (+/%#)"r) 3{."r y
 end.
 1
)

0 1 2 3 f"0 _ t=:       13 17 37 ?@$ 2
0 1 2 3 f"0 _ t=:       13 17 37 ?@$ 2000
0 1 2 3 f"0 _ t=:       13 17 37 ?@$ 4e8
0 1 2 3 f"0 _ t=: 0.1 * 13 17 37 ?@$ 1e4
0 1 2 3 f"0 _ t=: j./ 2 13 17 37 ?@$ 1e4
0 1 2 3 f"0 _ t=: x:    2 3 5 ?@$ 1e4
0 1 2 3 f"0 _ t=: 3r7 * 2 3 5 ?@$ 1e4
  1 2 3 f"0 _ t=: $.       (2 3 5 ?@$ 2000) * 2 3 5 ?@$ 2 
  1 2 3 f"0 _ t=: $. 0.1 * (2 3 5 ?@$ 2000) * 2 3 5 ?@$ 2 
1 [ 9!:57 (1)  NB. disable auditing, since next line is slow
0 1 2 3 f"0 _ t=: x:    13 17 37 ?@$ 1e4
0 1 2 3 f"0 _ t=: 3r7 * 13 17 37 ?@$ 1e4
  1 2 3 f"0 _ t=: $.       (13 17 37 ?@$ 2000) * 13 17 37 ?@$ 2 
  1 2 3 f"0 _ t=: $. 0.1 * (13 17 37 ?@$ 2000) * 13 17 37 ?@$ 2 
1 [ 9!:57 (2)


NB. (+/%#)/. ------------------------------------------------------------

f=: 4 : 0
 xx=: x {~ 1000 ?@$ #x
 yy=: y {~ 1000 ?@$ #y
 assert. xx (mean/. -: (+/%#)/.) yy
 1
)

f&>/~ 0 1;(i.100);(1e7*i.100);(0.1*i.100);((j. |.) i. 100);(i. 100x); (i. 100x) % 2
(0 1;(i.100);1e7*i.100) f&>/ (,  (x: ; 4r7&+)@(1&{::) (,<) ^@o.@j.@(2&{::)) (<200 2) ?@$&.> 2 2e9 0


4!:55 ;:'f mean r t xx yy'


