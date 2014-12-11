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
  
  
