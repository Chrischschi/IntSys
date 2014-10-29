s(S):-
  append(NP,VP,S), np(NP), vp(VP). 

np(N):-
  pn(N).

np(NP):-
  append(Det,N,NP), det(Det), n(N).

vp(V):-
  v(V).

vp(VP):-
  append(V,NP,VP), v(V), np(NP).

pn([john]).
pn([mary]).

n([man]).
n([woman]).
n([dog]).
n([bird]).
n([apple]).

v([sings]).
v([eats]).
v([bites]).
v([loves]).

det([the]).





