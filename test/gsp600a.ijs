1:@:(dbr bind Debug)@:(9!:19)2^_44[(prolog [ echo^:ECHOFILENAME) './gsp600a.ijs'
NB. " agreement ---------------------------------------------------------

f=: 4 : 0
 s=: (2;x)$.xx
 t=: (2;y)$.yy
 b=. (xx cat"1 yy) -: q=: s cat"1 t
 if. b *. 0<#$q do. *./ scheck q else. b end.
)

cat  =: 4 : 'x , y'

c=: ; (i.1+r) <"1@comb&.>r=:3
d=: ; (i.1+r) <"1@comb&.>r=:2

xx=: (?7 2$2)*?7 2 2$1000
yy=: (?7 2$2)*?7 2  $1000  
c f&>/d

xx=: (0=?17 4$5)*?17 4 2$1000
yy=: (0=?17 4$5)*?17 4  $1000  
c f&>/d

xx=: (0=?17 4$5)*?17 4 2$1000
yy=:              17 4  $0  
c f&>/d

xx=:              17 4 2$0
yy=: (0=?17 4$5)*?17 4  $1000  
c f&>/d

xx=:              17 4 2$0
yy=:              17 4  $0  
c f&>/d

c=: ; (i.1+r) <"1@comb&.>r=:2
d=: ; (i.1+r) <"1@comb&.>r=:3

xx=: (?7 2$2)*?7 2  $1000
yy=: (?7 2$2)*?7 2 2$1000  
c f&>/d

xx=: (0=?17 4$5)*?17 4  $1000
yy=: (0=?17 4$5)*?17 4 2$1000  
c f&>/d

xx=: (0=?17 4$5)*?17 4  $1000
yy=:              17 4 2$0  
c f&>/d

xx=:              17 4  $0
yy=: (0=?17 4$5)*?17 4 2$1000  
c f&>/d

xx=:              17 4  $0
yy=:              17 4 2$0  
c f&>/d

c=: ; (i.1+r) <"1@comb&.>r=:4
d=: ; (i.1+r) <"1@comb&.>r=:3

xx=: (0=?11 3 2$6)*?11 3 2 4$1000
yy=: (0=?11 3  $6)*?11 3   5$1000  
c f&>/d

xx=: (0=?11 3 2$6)*?11 3 2 4$1000
yy=: (   11 3  $0)*?11 3   5$1000  
c f&>/d

xx=: (   11 3 2$0)*?11 3 2 4$1000
yy=: (0=?11 3  $6)*?11 3   5$1000  
c f&>/d

xx=: (   11 3 2$0)*?11 3 2 4$1000
yy=: (   11 3  $0)*?11 3   5$1000  
c f&>/d

c=: ; (i.1+r) <"1@comb&.>r=:3
d=: ; (i.1+r) <"1@comb&.>r=:4

xx=: (0=?11 3  $6)*?11 3   5$1000  
yy=: (0=?11 3 2$6)*?11 3 2 4$1000
c f&>/d

xx=: (   11 3  $0)*?11 3   5$1000  
yy=: (0=?11 3 2$6)*?11 3 2 4$1000
c f&>/d

xx=: (0=?11 3  $6)*?11 3   5$1000  
yy=: (   11 3 2$0)*?11 3 2 4$1000
c f&>/d

xx=: (   11 3  $0)*?11 3   5$1000  
yy=: (   11 3 2$0)*?11 3 2 4$1000
c f&>/d


4!:55 ;:'c cat d f q r s t xx yy'


