1:@:(dbr bind Debug)@:(9!:19)2^_44[(prolog [ echo^:ECHOFILENAME) './gx.ijs'
NB. x. ------------------------------------------------------------------
1: (0 : 0)
old=: 9!:48 ''
9!:49]1

jnc =: 4!:0
jnl =: 4!:1

x. =. i.12
0  -: jnc <'x.'
(<'x.') e. jnl i.4

x. =. 1 : 'x./\'
1 -: jnc <'x.'
(<'x.') e. jnl i.4

x. =. 2 : 'x.&y. + x.@y.'
2 -: jnc <'x.'
(<'x.') e. jnl i.4

x. =. +/
3 -: jnc <'x.'
(<'x.') e. jnl i.4

4!:55 <'x.'
_1 -: jnc <'x.'
-. (<'x.') e. jnl i.4

4!:55 ;:'x.'

9!:49 old

4!:55 ;:'jnc jnl old'
)

