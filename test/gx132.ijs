1:@:(dbr bind Debug)@:(9!:19)2^_44[(prolog [ echo^:ECHOFILENAME) './gx132.ijs'
NB. %: on extended integers ---------------------------------------------

0 1 _ -: 0x %: 0 1 2x
0 1 _ -: 0  %: 0 1 2

(i:5) (%: -: %:&x:) 0
(i:5) (%: -: %:&x:) 1

0 (%: -: %:&x:) i.5
1 (%: -: %:&x:) i:5

2 (%: -: %:&x:) - 0 1 
2 (%: -: %:&x:) - 4 5 6
3 (%: -: %:&x:) - 0 1 
3 (%: -: %:&x:) - 4 5 6

(%:%2) -: _2 %: 2x 

test=: 4 : 0
 n=: x: x
 r=: x: y
 yy=: r^n
 assert. r     = n    %: yy
 assert. (r-1) = n <.@%: yy-1
 assert. (r+1) = n >.@%: yy+1
 1
)

test/       1+?100 1000x 
test/ 1+2 1*  ?100 1000x 
test/ 1+2 1*1+?100 1000x 

5 6x         test"0 ] 11^309x
12343 12344x test"0 ] 2x

4!:55 ;:'n r test yy'


