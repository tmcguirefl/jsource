1:@:(dbr bind Debug)@:(9!:19)2^_44[(prolog [ echo^:ECHOFILENAME) './gsp421.ijs'
NB. #/. -----------------------------------------------------------------

d=: (?1000$2) * ?1000 2 3$10
c=: ; (i.1+r) <"1@comb&.>r=:#$d

f=: 3 : 'assert. (#/.~ d) -: #/.~ s=: (2;y)$.d'
f&> c

f=: 3 : 'assert. (#/.~ $.^:_1 s) -: #/.~ s=: (b=:   ?1000 2$ 2) * (2;y)$.d'
f&> c

f=: 3 : 'assert. (#/.~ $.^:_1 s) -: #/.~ s=: (b=: 0=?1000 2$10) * (2;y)$.d'
f&> c

'length error' -: ($. i.9) #/.~ etx i.8
'length error' -: ($. i.9) #/.~ etx 1

i=: 1+?1e3$2e9
x=: ?1e3$100
s=: x i} 1 $. 2e9 ; 0 ; 2-2
t=: #/.~ s
b=: 0~:x
t -: ((#s)-+/b),#/.~ (b#x)/:b#i


NB. f/. -----------------------------------------------------------------

d=: (?947 2$2) * ?947 2 3$8
c=: ; (i.1+r) <"1@comb&.>r=:#$d
y=: ?((#d),4)$1000

f=: 1 : (':'; '(d u/.y) -: s u/.y [ s=: (2;x)$.d')
c <  f&> <y
c +/ f&> <y
c |. f&> <y

j=: ?100$~#d
f=: 1 : (':'; '((0 j}d) u/.y) -: s u/.y [ s=: 0 j}(2;x)$.d')
c <  f&> <y
c +/ f&> <y
c |. f&> <y


4!:55 ;:'b c d f i j r s t x y'


