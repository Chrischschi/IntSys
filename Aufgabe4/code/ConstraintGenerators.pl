%prolog ConstraintGenerators

%"Factory-Methoden" für einzelne constraints, damit sich daraus eine
% Datenstruktur daraus erzeugen lassen kann.
% Einige Prädikate geben listen von constraints, andere nur einzelne constraints 
% zurück

eq(A,B,eq(A,B)).

nachbar(X,Y,nachbar(X,Y)).

elems_in_bounds(Lower,Variables,Upper,VarsWithDoms) :- 
  setof(v(X):D, (member(X,Variables),numlist(Lower,Upper,D)), VarsWithDoms).


all_different(Vars,Constraints) :- 
  setof(dif(Left,Right), 
  (member(Left,Vars),member(Right,Vars),Left \== Right),
  Constraints).

/*
makeDifs(Vars,Difs,LastElement) :- 
  makeDifs(Vars,Difs,_,LastElement).

makeDifs([],[],Last,Last).
makeDifs([First,Second|Rest],[dif(First,Second)|RestDifs],Second,Last) :- 
  makeDifs(Rest,RestDifs,Second,Last).
makeDifs([Only|Rest],[dif(Previous,Only)|RestDifs],Previous,Last) :- 
  makeDifs(Rest,RestDifs,Only,Last). 
*/

:- begin_tests('ConstraintGenerators').
test(elems_in_bounds) :- 
   elems_in_bounds(1,[X,Y,Z],3,[v(X):[1,2,3],v(Y):[1,2,3],v(Z):[1,2,3]]).

/*   
test(all_different) :- 
   all_different([X,Y,Z],[dif(X,Y),dif(Y,Z),dif(Z,X)]).
*/
test(all_different) :- 
   all_different([X,Y,Z],[dif(X,Y),dif(X,Z),dif(Y,X),dif(Y,Z),dif(Z,X),dif(Z,Y)]).
/*
test(makeDifs) :- 
  makeDifs([X,Y,Z],[dif(X,Y),dif(Y,Z)],Z).
*/
:- end_tests('ConstraintGenerators').

