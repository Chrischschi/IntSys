% SolverToplevel.pl
% 14.11.2014 Christian Schirin
:- ensure_loaded('EinsteinRaetsel.pl').

main :- 
  model_einstein([Brite,Schwede,Daene,Norweger,Deutscher],Fisch,VarsAndDoms,ConstraintNet),
  solve_csp(VarsAndDoms,ConstraintNet),
  write(VarsAndDoms), nl, write(ConstraintNet). 


solve_csp([],_Constraints).    
solve_csp([Var|RestVars],Constraints) :-
  %TODO: Entscheiden, ob zuerst ac3_la oder bind_var kommt
  ac3_la(Var,RestVars,Constraints,IsConsistent), %Erst Kantenkonsistenz herstellen
  IsConsistent, %Prüfen, ob die Domäne irgendeiner variable leer ist
  bind_var(Var,Constraints), %Dann Variable mit konkretem Wert belegen
  solve_csp(NewRestVars,Constraints).

/* Belegt eine variable in einem Constraint-netz mit dem erstbesten wert aus
   seiner Domäne. */
bind_var(Variable,Constraints) :-
  Constraints =.. UnivConstraints,
  setof(V,(
  ( member([_,V,_],UnivConstraints);member([_,_,V],UnivConstrains))
    ,V == Variable
   ), AllOccurrencesOfV),
  getDomain(Variable,Dom),
  member(Variable,Dom),  %alternativ Dom = [Variable|_]
  AllOccurrencesOfV = [AnyV|_],
  Variable = V
  .



/*  !!!
TODO: Dafür sorgen, dass die modifizierten domänen zurückgegeben werden
    !!! */
% 0. "procedure AC3-LA(cv)"
ac3_la(v(Vcv):_Dcv,NextVars,Arcs,RetConsistent) :- 
  % 1. "Q <- {(Vi,Vcv) in arcs(G),i>cv};" Hier: X ist Vi, Y ist Vcv
  % Das "i > cv" braucht man in dieser implementation nicht, weil stattdessen
  % geprüft wird, ob X in NextVars ist. univ muss verwendet werden, da sonst
  % Prädikatenlogik Zweiter Ordnung benötigt wird (Variablen als prädikatsnamen(
  maplist(=.. ,Arcs,UnivArcs),
  setof([P,X,Y], % P(X,Y)
  (member([P,X,Y],UnivArcs),Vcv == Y,member(v(X):_DX,NextVars)), 
  Q),
  % 2. "consistent <- true";
  Consistent = true, 
  % Iteration ausgelagert, Zeilen 4 bis 9 des 
  ac3la_while(Q,Consistent,NextVars,UnivArcs,RetConsistent)
  % 10. "return consistent"
  . % 11. "end AC3-LA" 

/* Abbruch. aus 3. "while not Q empty & consistent" wird 
   "until Q empty | not consistent" */   
ac3la_while([],Consistent,_,_,Consistent). 
ac3la_while(_,false,_,_,false).

/* Iteration. */

/*  !!!
TODO: Dafür sorgen, dass die modifizierten domänen zurückgegeben werden
    !!! */
ac3la_while(Q,Consistent,NextVars,UnivArcs,RetConsistent) :- 
  % 4. "select and delete any arc (Vk,Vm) from Q"; 
  % Statt select einfach das vorderste element aus Q nehmen. 
  % Statt delete einfach den Rest von Q nehmen. 
  Q = [[P,Vk,Vm]|RestQ],  % eventuell durch lists:select/2 ersetzen
  % 5. "if REVISE(Vk,Vm) then"
  revise(P,Vk,Vm,NextVars,ChangedNextVars,WasRevised),
  ( WasRevised -> 
    % 6. "Q <- Q union {(Vi,Vk) such that (Vi,Vk) in arcs(G),i#k,i#m,i>cv}"
    setof([P,Vi,Vk],(member([P,Vi,Vk],UnivArcs),Vi \== Vk, Vi \== Vm, 
     member(v(Vi):_DVi,ChangedNextVars)
    ),ViVk),
    lists:union(RestQ,ViVk,NewQ),
    % 7. "consistent <- not Dk empty"
    getDomain(Vk,ChangedNextVars,Dk),
    checkNotEmpty(Dk,NewConsistent),
    % 8. "endif"
    ac3la_while(NewQ,NewConsistent,ChangedNextVars,UnivArcs,RetConsistent)
  % 8a. else {Q <- Q; consistent <- consistent;} endelse 
  % if ohne else geht nicht in funktionalen/deklarativen programmiersprachen
  ; ac3la_while(RestQ,Consistent,NextVars,UnivArcs,RetConsistent)
  )
  % 9 "endwhile"
  .

% 0. "procedure REVISE(Vi,Vj)"
% wenn Domain von Vi leer ist, dann fertig
revise(Constraint,Vi,Vj,VarsAndDoms,NewVarsAndDoms,Delete):-
  getDomain(Vi,VarsAndDoms,DomI),
  getDomain(Vj,VarsAndDoms,DomVj),
  reviseHelp(Constraint,DomI,DomJ,NewDomI,Delete),
  %hier neue VarsAndDoms mit der neuen Domain von Vi bauen
  %eventuell zu lists:selectchk/4 ändern (weil deterministisch)
  lists:select(v(Vi):DomI,VarsAndDoms,v(Vi):NewDomI,NewVarsAndDoms)
  .
reviseHelp(Constraint,[],DomJ,[],false).
reviseHelp(Constraint,[],DomJ,[],true).
reviseHelp(Constraint,[HeadDomI|RestDomI],DomJ,[HeadNewDomI|RestNewDomI],Delete) :-
  bagof(SupportVar,(member(SupportVar,DomJ),call(Constraint,HeadDomI,SupportVar)),_SupportingVars),!,
  reviseHelp(Constraint,RestDomI,DomJ,RestNewDomI,Delete).
reviseHelp(Constraint,[_HeadDomI|RestDomI],DomJ,NewDomI,Delete) :-
  Delete = true,
  revise(Constraint,RestDomI,DomJ,NewDomI,Delete).
   

getDomain(Variable,VarsAndDoms,Domain) :- 
  member(v(Variable):Domain,VarsAndDoms). 
  %falls v(Variable):Domain nicht in VarsAndDoms sein sollte, ist definitiv etwas kaputt.
  
checkNotEmpty(List,Result) :- \+ checkEmpty(List,Result).

checkEmpty([],true) :- !.
checkEmpty(List,false) :- List \= [].  
  
:- begin_tests('SolverTopLevel').

test(getDomain) :- 
  getDomain(X,[v(_Y):[4,5,6],v(X):[1,2,3]],[1,2,3]).
  
test(checkNotEmpty) :- 
  checkNotEmpty([1,2,3],true).
  
test(checkNotEmpty) :-
  checkNotEmpty([],false).
  
test(checkEmpty) :- 
  checkEmpty([1,2,3],false).
  
test(checkEmpty) :- 
  checkEmpty([],true).
  
test(bind_var) :-
  Constraints = [foo(X,Y)],
  bind_var(v(X):[1,2,3],Constraints),
  Constraints = [foo(1,Y)].

test(bind_var) :-
  Constraints = [foo(X,Y),foo(Z,X)],
  bind_var(v(X):[1,2,3],Constraints),
  Constraints = [foo(1,Y),foo(Z,1)].
  
  
:- end_tests('SolverTopLevel').
   
   
