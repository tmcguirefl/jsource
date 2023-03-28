prolog './g420.ijs'
NB. f/y for atomic verbs ------------------------------------------------

randuni''

NB. test failed on small ct
ct   =: 9!:18''
9!:19[2^_40

insert =: 1 : '{. ` ({. u $:@}.) @. (1&<@#)'     NB. one or more items

(= /t) -: = insert t=: 20 ?@$ 2
(< /t) -: < insert t
(<./t) -: <.insert t
(<:/t) -: <:insert t
(> /t) -: > insert t
(>./t) -: >.insert t
(>:/t) -: >:insert t
(+ /t) -: + insert t
(+./t) -: +.insert t
(+:/t) -: +:insert t
(* /t) -: * insert t
(*./t) -: *.insert t
(*:/t) -: *:insert t
(- /t) -: - insert t
(% /t) -: % insert t
(^ /t) -: ^ insert t
(~:/t) -: ~:insert t
(| /t) -: | insert t
(! /t) -: ! insert t

(= /"1 t) -: = insert"1 t=: #:i.16
(< /"1 t) -: < insert"1 t
(<./"1 t) -: <.insert"1 t
(<:/"1 t) -: <:insert"1 t
(> /"1 t) -: > insert"1 t
(>./"1 t) -: >.insert"1 t
(>:/"1 t) -: >:insert"1 t
(+ /"1 t) -: + insert"1 t
(+./"1 t) -: +.insert"1 t
(+:/"1 t) -: +:insert"1 t
(* /"1 t) -: * insert"1 t
(*./"1 t) -: *.insert"1 t
(*:/"1 t) -: *:insert"1 t
(- /"1 t) -: - insert"1 t
(% /"1 t) -: % insert"1 t
(^ /"1 t) -: ^ insert"1 t
(~:/"1 t) -: ~:insert"1 t
(| /"1 t) -: | insert"1 t
(! /"1 t) -: ! insert"1 t

(= /t) -: = insert t=: 10 17 ?@$2
(< /t) -: < insert t
(<./t) -: <.insert t
(<:/t) -: <:insert t
(> /t) -: > insert t
(>./t) -: >.insert t
(>:/t) -: >:insert t
(+ /t) -: + insert t
(+./t) -: +.insert t
(+:/t) -: +:insert t
(* /t) -: * insert t
(*./t) -: *.insert t
(*:/t) -: *:insert t
(- /t) -: - insert t
(% /t) -: % insert t
(^ /t) -: ^ insert t
(~:/t) -: ~:insert t
(| /t) -: | insert t
(! /t) -: ! insert t

(= /t) -: = insert t=: 10 1 1 1 ?@$2
(< /t) -: < insert t
(<./t) -: <.insert t
(<:/t) -: <:insert t
(> /t) -: > insert t
(>./t) -: >.insert t
(>:/t) -: >:insert t
(+ /t) -: + insert t
(+./t) -: +.insert t
(+:/t) -: +:insert t
(* /t) -: * insert t
(*./t) -: *.insert t
(*:/t) -: *:insert t
(- /t) -: - insert t
(% /t) -: % insert t
(^ /t) -: ^ insert t
(~:/t) -: ~:insert t
(| /t) -: | insert t
(! /t) -: ! insert t

(<./t) -: <.insert t=: ?20 ?@$1e6
(>./t) -: >.insert t
(+ /t) -: + insert t
(+./t) -: +.insert t
(* /t) -: * insert t
(*./t) -: *.insert t
(- /t) -: - insert t
(% /t) -: % insert t

NB. symbol
(<./t) -: <.insert t=: sdot0{~20 ?@$#sdot0
(>./t) -: >.insert t

(<./t) -: <.insert t=:?10 17$1e6
(>./t) -: >.insert t=:?10 17$1e6
(+ /t) -: + insert t=:?10 17$1e6
(+./t) -: +.insert t=:?10 17$1e6
(* /t) -: * insert t=:?10 17$1e6
(*./t) -: *.insert t=:?10 17$1e6
(- /t) -: - insert t=:?10 17$1e6
(% /t) -: % insert t=:?10 17$1e6

(<./t) -: <.insert t=:o.?20$1e6
(>./t) -: >.insert t=:o.?20$1e6
(+ /t) -: + insert t=:o.?20$1e6
(+./t) -: +.insert t=:o.?20$1e6
(* /t) -: * insert t=:o.?20$1e6
(*./t) -: *.insert t=:o.?20$1e6
(- /t) -: - insert t=:o.?20$1e6
(% /t) -: % insert t=:o.?20$1e6

(<./t) -: <.insert t=:o.?10 17$1e6
(>./t) -: >.insert t=:o.?10 17$1e6
(+ /t) -: + insert t=:o.?10 17$1e6
(+./t) -: +.insert t=:o.?10 17$1e6
(* /t) -: * insert t=:o.?10 17$1e6
(*./t) -: *.insert t=:o.?10 17$1e6
(- /t) -: - insert t=:o.?10 17$1e6
(% /t) -: % insert t=:o.?10 17$1e6

(i.53) -: +/@($&1)"0 i.53
*./ (+/ -: {.@(+/)@(,.&0))@:?@($&2)"0 [?29$13193


NB. ,/ ------------------------------------------------------------------

insert =: 1 : '{. ` ({. u $:@}.) @. (1&<@#)'     NB. one or more items

(,/t) -: ,insert t=:7
(,/t) -: ,insert t=:'abc'
(,/t) -: ,insert t=:u:'abc'
(,/t) -: ,insert t=:10&u:'abc'
(,/t) -: ,insert t=:s:@<"0 'abc'
(,/t) -: ,insert t=: ,'a'
(,/t) -: ,insert t=: ,u:'a'
(,/t) -: ,insert t=: ,10&u:'a'
(,/t) -: ,insert t=: ,s:@<"0 'a'
(,/t) -: ,insert t=:?7 0$1000
(,/t) -: ,insert t=:?7 1$1000
(,/t) -: ,insert t=:?7 9$1000
(,/t) -: ,insert t=:?1 7$1000
(,/t) -: ,insert t=:7 2$;:'Cogito, ergo sum.'
(,/t) -: ,insert t=:7 2$(u:&.>) ;:'Cogito, ergo sum.'
(,/t) -: ,insert t=:7 2$(10&u:&.>) ;:'Cogito, ergo sum.'
(,/t) -: ,insert t=:7 2$s:@<"0&.> ;:'Cogito, ergo sum.'
(,/t) -: ,insert t=:7 2$<"0@s: ;:'Cogito, ergo sum.'
(,/t) -: ,insert t=:o.?2 7 3$1000
(,/t) -: ,insert t=:?2 0 7 3$1000
(,/t) -: ,insert t=:r.?7 2 3 1 1$10000

'limit error' -: ,/ etx (>IF64{2e5 1.5e4 0;2e13 1e7  0) $ 0
'limit error' -: ,/ etx (>IF64{1e9 1e9   0;4e18 4e18 0) $ 0


NB. ;/ ------------------------------------------------------------------

(;/a) -: <"_1 a=:?10 20$1000
a=:4 5$(;:'sui generis'),<"0 ?20$1000
(;/a) -: (0{a);(1{a);(2{a);3{a
a=:4 5$((u:&.>) ;:'sui generis'),<"0 ?20$1000
(;/a) -: (0{a);(1{a);(2{a);3{a
a=:4 5$((10&u:&.>) ;:'sui generis'),<"0 ?20$1000
(;/a) -: (0{a);(1{a);(2{a);3{a
a=:4 5$(s:@<"0&.> ;:'sui generis'),<"0 ?20$1000
(;/a) -: (0{a);(1{a);(2{a);3{a
a=:4 5$(<"0@s: ;:'sui generis'),<"0 ?20$1000
(;/a) -: (0{a);(1{a);(2{a);3{a


NB. f/ identity functions -----------------------------------------------

(s$0) -:  +/i.0,s           [ s=:?(?5)$10
(s$0) -:  -/i.0,s           [ s=:?(?5)$10
(s$1) -:  */i.0,s           [ s=:?(?5)$10
(s$1) -:  %/i.0,s           [ s=:?(?5)$10
(s$1) -: %:/i.0,s           [ s=:?(?5)$10
(s$1) -:  =/i.0,s           [ s=:?(?5)$10
(s$0) -: ~:/i.0,s           [ s=:?(?5)$10
(s$0) -:  </i.0,s           [ s=:?(?5)$10
(s$0) -:  >/i.0,s           [ s=:?(?5)$10
(s$1) -: >:/i.0,s           [ s=:?(?5)$10
(s$1) -: <:/i.0,s           [ s=:?(?5)$10
(s$1) -:  ^/i.0,s           [ s=:?(?5)$10
(s$0) -:  |/i.0,s           [ s=:?(?5)$10
(s$1) -:  !/i.0,s           [ s=:?(?5)$10
(s$1) -: *./i.0,s           [ s=:?(?5)$10
(s$0) -: +./i.0,s           [ s=:?(?5)$10

(s$1) -:  1 b./i.0,s        [ s=:?(?5)$10
(s$0) -:  2 b./i.0,s        [ s=:?(?5)$10
(s$0) -:  4 b./i.0,s        [ s=:?(?5)$10
(s$0) -:  6 b./i.0,s        [ s=:?(?5)$10
(s$0) -:  7 b./i.0,s        [ s=:?(?5)$10
(s$1) -:  9 b./i.0,s        [ s=:?(?5)$10
(s$1) -: 11 b./i.0,s        [ s=:?(?5)$10
(s$1) -: 13 b./i.0,s        [ s=:?(?5)$10

-.0 e.,(s$_1e50) >: >./i.0,s [ s=:?(?5)$10
-.0 e.,(s$ 1e50) <: <./i.0,s [ s=:?(?5)$10
(<./'') -: ->./''

(i.0,}.s) -: ,/i.0,s        [ s=:?(?5)$10

f =: =@/:@{.
(f x) -: + / .* /x    [ x=: i.0,?(?5)$10
(f x) -: + / .* /x    [ x=: i.0
(f x) -: +./ .*./x    [ x=: i.0,?(?5)$10
(f x) -: ~:/ .*./x    [ x=: i.0,?(?5)$10
(f x) -:      %./x    [ x=: i.0,?(?5)$10

f =: /:@{.
(f x) -: { /x         [ x=:i.0,?(?5)$10
(f x) -: { /x         [ x=:i.0
(f x) -: C./x         [ x=:i.0,?(?5)$10
(f x) -: C./x         [ x=:i.0

(s$1)   -: +&.^./i.0,s      [ s=:?(?5)$10
(s$<$0) -: ,&.>/i.0,s       [ s=:?(?5)$10
(<$0)   -: ,&.>/''
(s$5)   -: *&.(_4&+)/i.0,s  [ s=:?(?5)$10

(4 5$0) -: +     /i.0 4 5
0       -: +/    /i.0 4 5
(4 5$0) -: *&.^  /i.0 4 5
0       -: *&.^/ /i.0 4 5
(4 5$1) -: *     /i.0 4 5
1       -: */    /i.0 4 5
(4 5$1) -: +&.^. /i.0 4 5
1       -: +&.^.//i.0 4 5


NB. +/b -----------------------------------------------------------------

rand =: 3 : 'x=: y ?@$ 2'
(+/ -: +/@(0&+))@rand"0 i.30
(+/ -: +/@(0&+))@rand"0 ?10$10000

(+/ -: +/"1@|: )@rand"1 [20 20,20 59,61 23,10 10#:i.100
(+/ -: +/"1@|: )@rand"1 ?20 2$1000 50


NB. f/"r y --------------------------------------------------------------

4!:55 ;:'f g x'

g =: 3 : 0
 n=.#y
 if. 0=n do. f/y return. end.
 i=.1
 z=.{:y 
 while. n>:i=.>:i do. z=.((-i){y) f z end.
)

f =: +
((+/   -: f/  ), +/   -: g  ) x =: _1e7+?2 3 7 13$2e7
((+/"1 -: f/"1), +/"1 -: g"1) x
((+/"2 -: f/"2), +/"2 -: g"2) x
((+/"3 -: f/"3), +/"3 -: g"3) x
((+/   -: f/  ), +/   -: g  ) x =: _1e7+?2 3 0 13$2e7
((+/"1 -: f/"1), +/"1 -: g"1) x
((+/"2 -: f/"2), +/"2 -: g"2) x
((+/"3 -: f/"3), +/"3 -: g"3) x
((+/   -:!.1e_12 f/  ), +/   -:!.1e_12 g  ) x =: _1e7+?2 3 1 7$2e7
((+/"1 -:!.1e_12 f/"1), +/"1 -:!.1e_12 g"1) x
((+/"2 -:!.1e_12 f/"2), +/"2 -:!.1e_12 g"2) x
((+/"3 -:!.1e_12 f/"3), +/"3 -:!.1e_12 g"3) x
((+/   -: f/  ), +/   -: g  ) x =: ?2 3 4 5$2e9
((+/"1 -: f/"1), +/"1 -: g"1) x
((+/"2 -: f/"2), +/"2 -: g"2) x
((+/"3 -: f/"3), +/"3 -: g"3) x
((+/   -:!.1e_12 f/  ), +/   -:!.1e_12 g  ) x =: o._1e7+?2 3 4 5$2e7
((+/"1 -:!.1e_12 f/"1), +/"1 -:!.1e_12 g"1) x
((+/"2 -:!.1e_12 f/"2), +/"2 -:!.1e_12 g"2) x
((+/"3 -:!.1e_12 f/"3), +/"3 -:!.1e_12 g"3) x
((+/   -: f/  ), +/   -: g  ) x =: ?3 4 5 7$2
((+/"1 -: f/"1), +/"1 -: g"1) x
((+/"2 -: f/"2), +/"2 -: g"2) x
((+/"3 -: f/"3), +/"3 -: g"3) x

f =: +.
((+./   -: f/  ), +./   -: g  ) x =: _1e7+?2 3 1 7$2e7
((+./"1 -: f/"1), +./"1 -: g"1) x
((+./"2 -: f/"2), +./"2 -: g"2) x
((+./"3 -: f/"3), +./"3 -: g"3) x
((+./   -: f/  ), +./   -: g  ) x =: ?2 3 1 7$2
((+./"1 -: f/"1), +./"1 -: g"1) x
((+./"2 -: f/"2), +./"2 -: g"2) x
((+./"3 -: f/"3), +./"3 -: g"3) x

f =: +:
((+:/   -: f/  ), +:/   -: g  ) x =: ?2 3 1 7$2
((+:/"1 -: f/"1), +:/"1 -: g"1) x
((+:/"2 -: f/"2), +:/"2 -: g"2) x
((+:/"3 -: f/"3), +:/"3 -: g"3) x

f =: -
((-/   -: f/  ), -/   -: g  ) x =: _1e7+?2 3 8 13$2e7
((-/"1 -: f/"1), -/"1 -: g"1) x
((-/"2 -: f/"2), -/"2 -: g"2) x
((-/"3 -: f/"3), -/"3 -: g"3) x
((-/   -: f/  ), -/   -: g  ) x =: ?2 3 8 13$2
((-/"1 -: f/"1), -/"1 -: g"1) x
((-/"2 -: f/"2), -/"2 -: g"2) x
((-/"3 -: f/"3), -/"3 -: g"3) x

f =: *
((*/   -: f/  ), */   -: g  ) x =: >:?2 3 1 7$10
((*/"1 -: f/"1), */"1 -: g"1) x
((*/"2 -: f/"2), */"2 -: g"2) x
((*/"3 -: f/"3), */"3 -: g"3) x
((*/   -: f/  ), */   -: g  ) x =: >:?5 3 1 7$1000
((*/"1 -: f/"1), */"1 -: g"1) x
((*/"2 -: f/"2), */"2 -: g"2) x
((*/"3 -: f/"3), */"3 -: g"3) x
((*/   -: f/  ), */   -: g  ) x =: o._500+?5 3 1 7$1000
((*/"1 -: f/"1), */"1 -: g"1) x
((*/"2 -: f/"2), */"2 -: g"2) x
((*/"3 -: f/"3), */"3 -: g"3) x
((*/   -: f/  ), */   -: g  ) x =: ?3 6 1 8$2
((*/"1 -: f/"1), */"1 -: g"1) x
((*/"2 -: f/"2), */"2 -: g"2) x
((*/"3 -: f/"3), */"3 -: g"3) x

f =: *.
((*./   -: f/  ), *./   -: g  ) x =: >:?2 3 1 7$10
((*./"1 -: f/"1), *./"1 -: g"1) x
((*./"2 -: f/"2), *./"2 -: g"2) x
((*./"3 -: f/"3), *./"3 -: g"3) x
((*./   -: f/  ), *./   -: g  ) x =: >:?5 3 1 7$1000
((*./"1 -: f/"1), *./"1 -: g"1) x
((*./"2 -: f/"2), *./"2 -: g"2) x
((*./"3 -: f/"3), *./"3 -: g"3) x
((*./   -: f/  ), *./   -: g  ) x =: o._500+?5 3 1 7$1000
((*./"1 -: f/"1), *./"1 -: g"1) x
((*./"2 -: f/"2), *./"2 -: g"2) x
((*./"3 -: f/"3), *./"3 -: g"3) x
((*./   -: f/  ), *./   -: g  ) x =: ?3 6 1 8$2
((*./"1 -: f/"1), *./"1 -: g"1) x
((*./"2 -: f/"2), *./"2 -: g"2) x
((*./"3 -: f/"3), *./"3 -: g"3) x

f =: *:
((*:/   -: f/  ), *:/   -: g  ) x =: ?3 6 1 8$2
((*:/"1 -: f/"1), *:/"1 -: g"1) x
((*:/"2 -: f/"2), *:/"2 -: g"2) x
((*:/"3 -: f/"3), *:/"3 -: g"3) x

f =: %
((%/   -: f/  ), %/   -: g  ) x =: >:?3 6 1 8$14
((%/"1 -: f/"1), %/"1 -: g"1) x
((%/"2 -: f/"2), %/"2 -: g"2) x
((%/"3 -: f/"3), %/"3 -: g"3) x
((%/   -: f/  ), %/   -: g  ) x =: o.>:7?3 6 1 8$14
((%/"1 -: f/"1), %/"1 -: g"1) x
((%/"2 -: f/"2), %/"2 -: g"2) x
((%/"3 -: f/"3), %/"3 -: g"3) x
((%/   -: f/  ), %/   -: g  ) x =: ?3 6 1 8$2
((%/"1 -: f/"1), %/"1 -: g"1) x
((%/"2 -: f/"2), %/"2 -: g"2) x
((%/"3 -: f/"3), %/"3 -: g"3) x

f =: =
((=/   -: f/  ), =/   -: g  ) x =: _26+?3 6 1 8$52
((=/"1 -: f/"1), =/"1 -: g"1) x
((=/"2 -: f/"2), =/"2 -: g"2) x
((=/"3 -: f/"3), =/"3 -: g"3) x
((=/   -: f/  ), =/   -: g  ) x =: o._26+?3 6 1 8$52
((=/"1 -: f/"1), =/"1 -: g"1) x
((=/"2 -: f/"2), =/"2 -: g"2) x
((=/"3 -: f/"3), =/"3 -: g"3) x
((=/   -: f/  ), =/   -: g  ) x =: ?3 6 1 8$2
((=/"1 -: f/"1), =/"1 -: g"1) x
((=/"2 -: f/"2), =/"2 -: g"2) x
((=/"3 -: f/"3), =/"3 -: g"3) x

f =: ~:
((~:/   -: f/  ), ~:/   -: g  ) x =: _26+?3 6 1 8$52
((~:/"1 -: f/"1), ~:/"1 -: g"1) x
((~:/"2 -: f/"2), ~:/"2 -: g"2) x
((~:/"3 -: f/"3), ~:/"3 -: g"3) x
((~:/   -: f/  ), ~:/   -: g  ) x =: o._26+?3 6 1 8$52
((~:/"1 -: f/"1), ~:/"1 -: g"1) x
((~:/"2 -: f/"2), ~:/"2 -: g"2) x
((~:/"3 -: f/"3), ~:/"3 -: g"3) x
((~:/   -: f/  ), ~:/   -: g  ) x =: ?3 6 1 8$2
((~:/"1 -: f/"1), ~:/"1 -: g"1) x
((~:/"2 -: f/"2), ~:/"2 -: g"2) x
((~:/"3 -: f/"3), ~:/"3 -: g"3) x

f =: <
((</   -: f/  ), </   -: g  ) x =: _17+?2 3 1 13$34
((</"1 -: f/"1), </"1 -: g"1) x
((</"2 -: f/"2), </"2 -: g"2) x
((</"3 -: f/"3), </"3 -: g"3) x
((</   -: f/  ), </   -: g  ) x =: o._17+?2 3 1 13$34
((</"1 -: f/"1), </"1 -: g"1) x
((</"2 -: f/"2), </"2 -: g"2) x
((</"3 -: f/"3), </"3 -: g"3) x
((</   -: f/  ), </   -: g  ) x =: ?2 3 1 13$2
((</"1 -: f/"1), </"1 -: g"1) x
((</"2 -: f/"2), </"2 -: g"2) x
((</"3 -: f/"3), </"3 -: g"3) x

f =: <.
((<./   -: f/  ), <./   -: g  ) x =: _1e7+?2 3 1 13$2e7
((<./"1 -: f/"1), <./"1 -: g"1) x
((<./"2 -: f/"2), <./"2 -: g"2) x
((<./"3 -: f/"3), <./"3 -: g"3) x
((<./   -: f/  ), <./   -: g  ) x =: o._1e7+?2 3 1 13$2e7
((<./"1 -: f/"1), <./"1 -: g"1) x
((<./"2 -: f/"2), <./"2 -: g"2) x
((<./"3 -: f/"3), <./"3 -: g"3) x
((<./   -: f/  ), <./   -: g  ) x =: ?2 3 1 13$2
((<./"1 -: f/"1), <./"1 -: g"1) x
((<./"2 -: f/"2), <./"2 -: g"2) x
((<./"3 -: f/"3), <./"3 -: g"3) x

f =: <:
((<:/   -: f/  ), <:/   -: g  ) x =: _1e7+?2 3 1 13$2e7
((<:/"1 -: f/"1), <:/"1 -: g"1) x
((<:/"2 -: f/"2), <:/"2 -: g"2) x
((<:/"3 -: f/"3), <:/"3 -: g"3) x
((<:/   -: f/  ), <:/   -: g  ) x =: o._1e7+?2 3 1 13$2e7
((<:/"1 -: f/"1), <:/"1 -: g"1) x
((<:/"2 -: f/"2), <:/"2 -: g"2) x
((<:/"3 -: f/"3), <:/"3 -: g"3) x
((<:/   -: f/  ), <:/   -: g  ) x =: ?2 3 1 13$2
((<:/"1 -: f/"1), <:/"1 -: g"1) x
((<:/"2 -: f/"2), <:/"2 -: g"2) x
((<:/"3 -: f/"3), <:/"3 -: g"3) x

f =: >
((>/   -: f/  ), >/   -: g  ) x =: _1e7+?2 3 1 13$2e7
((>/"1 -: f/"1), >/"1 -: g"1) x
((>/"2 -: f/"2), >/"2 -: g"2) x
((>/"3 -: f/"3), >/"3 -: g"3) x
((>/   -: f/  ), >/   -: g  ) x =: o._1e7+?2 3 1 13$2e7
((>/"1 -: f/"1), >/"1 -: g"1) x
((>/"2 -: f/"2), >/"2 -: g"2) x
((>/"3 -: f/"3), >/"3 -: g"3) x
((>/   -: f/  ), >/   -: g  ) x =: ?2 3 1 13$2
((>/"1 -: f/"1), >/"1 -: g"1) x
((>/"2 -: f/"2), >/"2 -: g"2) x
((>/"3 -: f/"3), >/"3 -: g"3) x

f =: >.
((>./   -: f/  ), >./   -: g  ) x =: _1e7+?2 3 1 13$2e7
((>./"1 -: f/"1), >./"1 -: g"1) x
((>./"2 -: f/"2), >./"2 -: g"2) x
((>./"3 -: f/"3), >./"3 -: g"3) x
((>./   -: f/  ), >./   -: g  ) x =: o._1e7+?2 3 1 13$2e7
((>./"1 -: f/"1), >./"1 -: g"1) x
((>./"2 -: f/"2), >./"2 -: g"2) x
((>./"3 -: f/"3), >./"3 -: g"3) x
((>./   -: f/  ), >./   -: g  ) x =: ?2 3 17 2$2
((>./"1 -: f/"1), >./"1 -: g"1) x
((>./"2 -: f/"2), >./"2 -: g"2) x
((>./"3 -: f/"3), >./"3 -: g"3) x

f =: >:
((>:/   -: f/  ), >:/   -: g  ) x =: _1e7+?2 3 1 13$2e7
((>:/"1 -: f/"1), >:/"1 -: g"1) x
((>:/"2 -: f/"2), >:/"2 -: g"2) x
((>:/"3 -: f/"3), >:/"3 -: g"3) x
((>:/   -: f/  ), >:/   -: g  ) x =: o._1e7+?2 3 1 13$2e7
((>:/"1 -: f/"1), >:/"1 -: g"1) x
((>:/"2 -: f/"2), >:/"2 -: g"2) x
((>:/"3 -: f/"3), >:/"3 -: g"3) x
((>:/   -: f/  ), >:/   -: g  ) x =: ?2 3 1 13$2
((>:/"1 -: f/"1), >:/"1 -: g"1) x
((>:/"2 -: f/"2), >:/"2 -: g"2) x
((>:/"3 -: f/"3), >:/"3 -: g"3) x

f =: !
((!/   -: f/  ), !/   -: g  ) x =: _7+?3 6 1 8$14
((!/"1 -: f/"1), !/"1 -: g"1) x
((!/"2 -: f/"2), !/"2 -: g"2) x
((!/"3 -: f/"3), !/"3 -: g"3) x
((!/   -: f/  ), !/   -: g  ) x =: -:?3 2 1 4$10
((!/"1 -: f/"1), !/"1 -: g"1) x
((!/"2 -: f/"2), !/"2 -: g"2) x
((!/"3 -: f/"3), !/"3 -: g"3) x
((!/   -: f/  ), !/   -: g  ) x =: ?3 6 1 8$2
((!/"1 -: f/"1), !/"1 -: g"1) x
((!/"2 -: f/"2), !/"2 -: g"2) x
((!/"3 -: f/"3), !/"3 -: g"3) x

f =: ^
((^/   -: f/  ), ^/   -: g  ) x =: x+0=x=:_2+?3 4 1 2$4
((^/"1 -: f/"1), ^/"1 -: g"1) x
((^/"2 -: f/"2), ^/"2 -: g"2) x
((^/"3 -: f/"3), ^/"3 -: g"3) x
((^/   -: f/  ), ^/   -: g  ) x =: x+0=x=:-:_3+?3 4 1 2$6
((^/"1 -: f/"1), ^/"1 -: g"1) x
((^/"2 -: f/"2), ^/"2 -: g"2) x
((^/"3 -: f/"3), ^/"3 -: g"3) x
((^/   -: f/  ), ^/   -: g  ) x =: ?3 4 1 2$2
((^/"1 -: f/"1), ^/"1 -: g"1) x
((^/"2 -: f/"2), ^/"2 -: g"2) x
((^/"3 -: f/"3), ^/"3 -: g"3) x

f =: o.
((o./   -: f/  ), o./   -: g  ) x =: ?2 2 2 2$9
((o./"1 -: f/"1), o./"1 -: g"1) x
((o./"2 -: f/"2), o./"2 -: g"2) x
((o./"3 -: f/"3), o./"3 -: g"3) x
((o./   -: f/  ), o./   -: g  ) x =: ?2 2 2 2$2
((o./"1 -: f/"1), o./"1 -: g"1) x
((o./"2 -: f/"2), o./"2 -: g"2) x
((o./"3 -: f/"3), o./"3 -: g"3) x

f =: |
((|/   -: f/  ), |/   -: g  ) x =: _7+?3 6 1 8$14
((|/"1 -: f/"1), |/"1 -: g"1) x
((|/"2 -: f/"2), |/"2 -: g"2) x
((|/"3 -: f/"3), |/"3 -: g"3) x
((|/   -: f/  ), |/   -: g  ) x =: -:_7+?3 6 1 8$14
((|/"1 -: f/"1), |/"1 -: g"1) x
((|/"2 -: f/"2), |/"2 -: g"2) x
((|/"3 -: f/"3), |/"3 -: g"3) x
((|/   -: f/  ), |/   -: g  ) x =: ?3 6 1 8$2
((|/"1 -: f/"1), |/"1 -: g"1) x
((|/"2 -: f/"2), |/"2 -: g"2) x
((|/"3 -: f/"3), |/"3 -: g"3) x

f =: ,
((,/   -: f/  ), ,/   -: g  ) x =: a.{~?2 3 5 13$#a.
((,/"1 -: f/"1), ,/"1 -: g"1) x
((,/"2 -: f/"2), ,/"2 -: g"2) x
((,/"3 -: f/"3), ,/"3 -: g"3) x
((,/   -: f/  ), ,/   -: g  ) x =: ?2 3 1 7$1e7
((,/"1 -: f/"1), ,/"1 -: g"1) x
((,/"2 -: f/"2), ,/"2 -: g"2) x
((,/"3 -: f/"3), ,/"3 -: g"3) x

f =: ;
((;/   -: f/  ), ;/   -: g  ) x =: a.{~?2 3 5 13$#a.
((;/"1 -: f/"1), ;/"1 -: g"1) x
((;/"2 -: f/"2), ;/"2 -: g"2) x
((;/"3 -: f/"3), ;/"3 -: g"3) x
((;/   -: f/  ), ;/   -: g  ) x =: ?2 3 1 7$1e7
((;/"1 -: f/"1), ;/"1 -: g"1) x
((;/"2 -: f/"2), ;/"2 -: g"2) x
((;/"3 -: f/"3), ;/"3 -: g"3) x
((;/   -: f/  ), ;/   -: g  ) x =: <"0 ?2 3 1 7$1e7
((;/"1 -: f/"1), ;/"1 -: g"1) x
((;/"2 -: f/"2), ;/"2 -: g"2) x
((;/"3 -: f/"3), ;/"3 -: g"3) x

(2 3 4$+ /$0) -: + /"2 i.2 3 0 4
(2 3 4$+./$0) -: +./"2 i.2 3 0 4
(2 3 4$- /$0) -: - /"2 i.2 3 0 4
(2 3 4$* /$0) -: * /"2 i.2 3 0 4
(2 3 4$*./$0) -: *./"2 i.2 3 0 4
(2 3 4$% /$0) -: % /"2 i.2 3 0 4
(2 3 4$%:/$0) -: %:/"2 i.2 3 0 4
(2 3 4$= /$0) -: = /"2 i.2 3 0 4
(2 3 4$~:/$0) -: ~:/"2 i.2 3 0 4
(2 3 4$> /$0) -: > /"2 i.2 3 0 4
(2 3 4$>./$0) -: >./"2 i.2 3 0 4
(2 3 4$>:/$0) -: >:/"2 i.2 3 0 4
(2 3 4$< /$0) -: < /"2 i.2 3 0 4
(2 3 4$<./$0) -: <./"2 i.2 3 0 4
(2 3 4$<:/$0) -: <:/"2 i.2 3 0 4

f=: [^:(0&~:@[)
(f/   -: g  ) x=: (?   15$2) * ?   15$10
(f/"1 -: g"1) x=: (?22 15$2) * ?22 15$10


NB. f/@, ----------------------------------------------------------------

A =: 1 : 0
 (u/@, y) -: u/,y
)

=  A    ?10 20 30  $2
~: A    ?10 20 30  $2

+  A    ?10 20 30  $2
+  A    ?10 20     $100
+  A o. ?10 20 3 4 $100
+  A j./?2 10 20 3 $100

+. A    ?10 20 30  $2
+. A    ?10 20     $100

*. A    ?10 20 30  $2
*. A    ?10 20     $100

-  A    ?10 20 30  $2
-  A    ?10 20     $100
-  A o. ?10 20 3 4 $100
-  A j./?2 10 20 3 $100

>. A    ?10 20 30  $2
>. A    ?10 20     $100
>. A o. ?10 20 3 4 $100

<. A    ?10 20 30  $2
<. A    ?10 20     $100
<. A o. ?10 20 3 4 $100

pl=: +

pl A    ?10 20 30  $2
pl A    ?10 20     $100
pl A o. ?10 20 3 4 $100
pl A j./?2 10 20 3 $100

+ A ?100 10$1e7
* A 1+?2 10$10

=  A 0 3 4 5$1
+. A 0 3 4 5$1
*. A 0 3 4 5$1
~: A 0 3 4 5$1

<. A 0 3 4 5$1
<. A 4 6 0 3$200
<. A 0 3 4 5$1.2

>. A 0 3 4 5$1
>. A 4 6 0 3$200
>. A 0 3 4 5$1.2

+  A 0 3 4 5$1
+  A 4 6 0 3$200
+  A 0 3 4 5$1.2
+  A 4 6 0 3$1j2

*  A 0 3 4 5$1
*  A 4 6 0 3$200
*  A 0 3 4 5$1.2
*  A 4 6 0 3$1j2


NB. g/ ------------------------------------------------------------------

(+`%/x)    -: (0{x)+(1{x)%(2{x)+(3{x)%4{x =:_500+?5 12$1000
((<'+')/x) -: +/x

(+`%/x)    -: (0{x)+(1{x)%(2{x)+3{x =:_500+?4 12$1000
((<'+')/x) -: +/x

(+`%/x)    -: (0{x)+(1{x)%2{x =:_500+?3 12$1000
((<'+')/x) -: +/x

(+`%/x)    -: +/x =: _500+?2 12$1000
((<'+')/x) -: +/x

(+`%/x)    -: {.x =: _500+?1 12$1000
((<'+')/x) -: {.x

(+`%/x)    -: 12$0 [ x=:_500+?0 12$1000
((<'+')/x) -: 12$0


NB. x f/y ---------------------------------------------------------------

p =: ?(>:?20)$100
q =: ?(>:?20)$100

(p+"0 99 q) -: p+/q
(p*"+/q)    -: p*/q
({p;q)      -: p,&.>/q
({p;q)      -: p<@,"0/q

iota =: > @ (+/&.>/) @ (i.&.> *&.> */\.@}.@(,&1))
(i. -: iota) 2 3 4
(i. -: iota) >:?(?5)$6
(i. -: iota) $0

(($x),$y) -: $(x=:i.0  ) <   / y=:i.0 3
(($x),$y) -: $(x=:i.0  ) <!.0/ y=:i.?~5
(($x),$y) -: $(x=:i.0  ) ^   / y=:i.0 3
(($x),$y) -: $(x=:i.0  ) ^!.0/ y=:i.?~5
(($x),$y) -: $(x=:i.0 3) <   / y=:i.0
(($x),$y) -: $(x=:i.0 3) <!.0/ y=:i.0
(($x),$y) -: $(x=:i.0 3) ^   / y=:i.0
(($x),$y) -: $(x=:i.0 3) ^!.0/ y=:i.0
(($x),$y) -: $(x=:i.0  ) <   / y=:i.0
(($x),$y) -: $(x=:i.0  ) <!.0/ y=:i.0
(($x),$y) -: $(x=:i.0  ) ^   / y=:i.0
(($x),$y) -: $(x=:i.0  ) ^!.0/ y=:i.0

NB. +/ Magic Cubes -----------------------------------------------------

NB. by Professor James G. Mauldon via Ken Iverson

MC=: #. ] | (#: i.)@(3&#) +/ .* (3 3{.3 5$3 5 4)"_

test=: 3 : 0
 c=: MC y
 s=: {. , +/ c
 assert. s = (+/ , +/"1) c
 assert. s = (+/ , +/"1) (<0 1)|:c
 assert. s = (+/ , +/"1) (<0 2)|:c
 assert. s = (+/ , +/"1) (<1 2)|:c
 assert. s = (+/ , +/"1) (<0 1 2)|:c
 1
)

test 11
test 23
test 29

NB. f/ NaN --------------------------------------------------------------

'NaN error' -: +/ etx _ __   NB. smoke test

'NaN error' -: +/ etx (_ __ ([)`(2 ? #@])`]} ]) (2 + ? 100) ?@$ 0
'NaN error' -: +/ etx ((,._ __) ([)`([: < 2 1 <@? $@])`]} ]) (2 + ? 50 50) ?@$ 0
'NaN error' -: +/"2 etx ((,._ __) ([)`([: < 1 2 1 <@? $@])`]} ]) (2 + ? 4 50 50) ?@$ 0

'NaN error' -: -/ etx (_ __ ([)`(2 * 2 ? <.@:-:@:#@])`]} ]) (4 + ? 100) ?@$ 0
'NaN error' -: -/ etx ((,._ __) ([)`([: < 2 *&.> 2 1 <@? <.@:-:@:$@])`]} ]) (4 + ? 50 50) ?@$ 0
'NaN error' -: -/"2 etx ((,._ __) ([)`([: < 2 *&.> 1 2 1 <@? <.@:-:@:$@])`]} ]) (4 + ? 4 50 50) ?@$ 0


9!:19 ct

4!:55 ;:'A adot1 adot2 sdot0 a c ct f g i insert iota k MC n p pl q '
4!:55 ;:'rand s t test x y z'
randfini''


epilog''

