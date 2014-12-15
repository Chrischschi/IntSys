% SolverToplevel.pl
% 14.11.2014 Christian Schirin
:- ensure_loaded('EinsteinRaetsel.pl').

main :- 
  model_einstein([Brite,Schwede,Daene,Norweger,Deutscher],Fisch,VarsAndDoms,ConstraintNet),
  solve_csp(VarsAndDoms,ConstraintNet),
  write(VarsAndDoms), nl, write(ConstraintNet). 


solve_csp([],_Constraints).    
solve_csp([Var|RestVars],Constraints) :-
  ac3_la(Var,RestVars,Constraints,NewRestVars), %Erst Kantenkonsistenz herstellen
  bind_var(Var,Constraints), %Dann Variable mit konkretem Wert belegen
  solve_csp(NewRestVars,Constraints).

% 0. "procedure AC3-LA(cv)"
ac3_la(v(Vcv):_Dcv,NextVars,Arcs,ChangedNextVars,RetConsistent) :- 
  % 1. "Q <- {(Vi,Vcv) in arcs(G),i>cv};" Hier: X ist Vi, Y ist Vcv
  % Das "i > cv" braucht man in dieser implementation nicht, weil stattdessen
  % geprüft wird, ob X in NextVars ist. univ muss verwendet werden, da sonst
  % Prädikatenlogik Zweiter Ordnung benötigt wird (Variablen als prädikatsnamen(
  maplist(=.. ,Arcs,UnivArcs),
  setof([P,X,Y],
  (member([P,X,Y],UnivArcs),Vcv == Y,member(v(X):_DX,NextVars)), 
  Q),
  % 2. "consistent <- true";
  Consistent = true, 
  % Iteration ausgelagert, Zeilen 4 bis 9 des 
  ac3la_while(Q,Consistent,NextVars,ChangedNextVars,UnivArcs,RetConsistent)
  % 10. "return consistent"
  . % 11. "end AC3-LA" 

/* Abbruch. aus 3. "while not Q empty & consistent" wird 
   "until Q empty | not consistent" */   
ac3la_while([],Consistent,_,_,Consistent). 
ac3la_while(_,false,_,_,false).

/* Iteration. */
ac3la_while(Q,Consistent,NextVars,UnivArcs,RetConsistent) :- 
  % 4. "select and delete any arc (Vk,Vm) from Q"; 
  % Statt select einfach das vorderste element aus Q nehmen. 
  % Statt delete einfach den Rest von Q nehmen. 
  Q = [[P,Vk,Vm]|RestQ],
  % 5. "if REVISE(Vk,Vm) then"
  revise(P,Vk,Vm,NextVars,ChangedNextVars) -> 
    % 6. "Q <- Q union {(Vi,Vk) such that (Vi,Vk) in arcs(G),i#k,i#m,i>cv}"
    setof([P,Vi,Vk],(member([P,Vi,Vk],UnivArcs),Vi \== Vk, Vi \== Vm, 
     member(v(Vi):_DVi,ChangedNextVars)
    ),ViVk),
    lists:union(Q,ViVk,NewQ),
    % 7. "consistent <- not Dk empty"
    getDomain(Vk,Dk,ChangedNextVars),
    checkNotEmpty(Dk,NewConsistent),
    % 8. "endif"
    ac3la_while(NewQ,NewConsistent,ChangedNextVars,UnivArcs,RetConsistent)
  % 8a. else {Q <- Q; consistent <- consistent;} endelse 
  % if ohne else geht nicht in funktionalen/deklarativen programmiersprachen
  ; ac3la_while(RestQ,Consistent,ChangedNextVars,UnivArcs,RetConsistent)
  % 9 "endwhile"
  .
   
   
   
