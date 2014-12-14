%Constraints unseres Constraint-Solvers. 
%11.12.2014 Christian Schirin


%Y wohnt links oder rechts neben X
nachbar(X,Y) :- 
  Distance is abs(X-Y),
  eq(Distance,1). 
  
% Arithmetische Gleichheit
eq(A,B) :- 
  A =:= B. 

/*Prüfen, ob eine alle Variablen einer gegebenen liste von Variablen sich in
  einem Wertebereich befindet. */
elems_in_bounds(Lower,Variables,Upper) :- 
  forall(member(V,Variables),elem_in_bounds(Lower,V,Upper)). 

%Prüfen, ob sich eine Variable in einem wertebereich befindet. 
elem_in_bounds(Lower,Variable,Upper) :- 
  Lower =< Variable, Variable =< Upper.
  
%Prüfen, ob alle Variablen einer liste verschieden sind. 
all_different([]).
all_different([First|Rest]) :- different(First,Rest), all_different(Rest).

%Prüfen, ob eine Variable verschieden zu einer liste von Variablen ist.
different(Var,OtherVars) :- forall(member(OV,OtherVars),dif:dif(Var,OV)). 
  
:- begin_tests(constraints).

test(nachbar) :- nachbar(1,2).
test(nachbar) :- nachbar(2,1).

test(nachbar) :- nachbar(2,3). 

test(nachbar) :- nachbar(5,4).

test(eq) :- eq(1,1). 

test(eq) :- eq(2+2,3+1).

test(elems_in_bounds) :- elems_in_bounds(1,[1,2,3,4,5],5).

test(elems_in_bounds) :- elems_in_bounds(1,[5,4,3,2,1],5).

test(elems_in_bounds) :- elems_in_bounds(1,[1,5,4,2,3],5).

test(elems_in_bounds) :- elems_in_bounds(1,[1,1,5,5],5).

test(elem_in_bounds) :- elem_in_bounds(1,3,5).

test(elem_in_bounds) :- elem_in_bounds(1,1,1).

test(all_different) :- all_different([1,2,3,4,5]).

test(all_different) :- all_different([]).

test(different) :- different(1,[2,3,4,5]).

test(different) :- different(1,[]).

:- end_tests(constraints).
       
