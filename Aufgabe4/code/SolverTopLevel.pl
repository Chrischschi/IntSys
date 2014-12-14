% SolverToplevel.pl
% 14.11.2014 Christian Schirin
:- ensure_loaded('EinsteinRaetsel.pl').

main :- 
  model_einstein([Brite,Schwede,Daene,Norweger,Deutscher],Fisch,VarsAndDoms,ConstraintNet),
  solve_csp(VarsAndDoms,ConstraintNet),
  write(VarsAndDoms), nl, write(ConstraintNet). 
     
solve_csp(Variables,Constraints) :-
  solve_csp(Variables,Variables,Constraints).
  
solve_csp(RemainingVars,AllVars,Constraints) :- fail. %% TODO
  
   
   
 
   
