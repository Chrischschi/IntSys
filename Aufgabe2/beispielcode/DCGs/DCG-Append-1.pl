s(S):-
  np(NP), vp(VP), append(NP,VP,S).

np(N):-
  pn(N).

np(NP):-
  det(Det), n(N), append(Det,N,NP).

vp(V):-
  v(V).

vp(VP):-
  v(V), np(NP), append(V,NP,VP).

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
