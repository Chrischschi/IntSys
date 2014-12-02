% Die Schnittstelle umfasst
%   start_description	;Beschreibung des Startzustands
%   start_node          ;Test, ob es sich um einen Startknoten handelt
%   goal_node           ;Test, ob es sich um einen Zielknoten handelt
%   state_member        ;Test, ob eine Zustandsbeschreibung in einer Liste 
%                        von Zustandsbeschreibungen enthalten ist
%   expand              ;Berechnung der Kind-Zustandsbeschreibungen
%   eval-path		;Bewertung eines Pfades


start_description([
  block(block1),
  block(block2),
  block(block3),
  %block(block4),  %mit Block4
  on(table,block2),
  on(table,block3),
  on(block2,block1),
  %on(table,block4), %mit Block4
  clear(block1),
  clear(block3),
  %clear(block4), %mit Block4
  handempty
  ]).

goal_description([
  block(block1),
  block(block2),
  block(block3),
  %block(block4), %mit Block4
  %on(block4,block2), %mit Block4
  on(table,block3),
  on(table,block1),
  %on(block1,block4), %mit Block4
  on(block1,block2), %ohne Block4
  clear(block3),
  clear(block2),
  handempty
  ]).



start_node((start,_,_)).

%goal_node((_,State,_)):- goal_description(State). %timos ansatz
goal_node((_,State,_)) :- 
  goal_description(GoalState),  % "Zielbedingungen einlesen"
  mysubset(GoalState,State).%"Zustand gegen Zielbedingungen testen"



% Aufgrund der Komplexität der Zustandsbeschreibungen kann state_member nicht auf 
% das Standardprädikat member zurückgeführt werden.
%  

%state_member(State,StateList):- member(State,StateList). %einfaches member reicht,da versucht wird state mit jedem listelement zu unifizieren

state_member(_,[]):- !,fail.

state_member(State,[FirstState|_]):-
   /* Wir müssen überprüfen, ob State und FirstState die gleiche Menge sind.
      Zwei mengen A und B sind gleich, wenn gilt, dass A Teilmenge von B und 
      B Teilmenge von A ist. */
   lists:subset(State,FirstState), lists:subset(FirstState,State) ,!.  

%Es ist sichergestellt, dass die beiden ersten Klauseln nicht zutreffen.
state_member(State,[_|RestStates]):-  
  state_member(State,RestStates).

%! eval_path(+PathList:list) is det.
%  Wertet heuristik für den kopf eines pfades aus. 
eval_path(StateHeuristic,StrategyRestPath,[(_,State,Value)|RestPath]):-
  eval_state_and_restpath(StateHeuristic,State,StateValue,
    StrategyRestPath,RestPath,RestPathValue),%"Rest des Literals bzw. der Klausel"
  /* Keine rekursion "Da nur das erste Element des Pfades zur Bewertung
     herangezogen werden muss [...]" */
  plus(StateValue,RestPathValue,Value).%"Value berechnen".


%! eval_state_and_restpath((State:list) is det. 
%  Wertet eine heuristik für einen zustand aus
eval_state_and_restpath(HeuristicState,State,StateResult,
  StrategyRestPath,RestPath,RestPathResult) :- 
  eval_state_help(HeuristicState,State,StateResult),
  eval_restpath_help(StrategyRestPath,RestPath,RestPathResult).

%! eval_restpath_help(StrategyRestPath:atom,RestPath:list,RestPathResult:int) is det.
%  Lässt einen wählen, ob man die bisherigen kosten in die berechnung der gesamtkosten
%  einfließen lässt oder nicht.
eval_restpath_help(ignoreRestPath,_RestPath,0). %Bisherige kosten werden nicht berücksichtigt
eval_restpath_help(lengthRestPath,RestPath,Value) :- %Bisherige kosten = laenge des bisherigen pfades 
  lists:length(RestPath,Value).
  
%! eval_state_help(Heuristic,(Action:atom,State:list,Value:int)) is det.
%  Helper-funktion um zwischen Heuristik zu wählen.  
/* Christians Heuristik für eval_state_and_restpath: Symmetrische Differenz von Zustand State 
   und dem Zielzustand. Wenn State gleich dem Zustand ist, dann ist die 
   Symmetrische Differenz leer. Wenn State disjunkt vom Endzustand dann ist
   die Symmetrische Differenz gleich der Vereinigung der beiden Mengen */
eval_state_help(minus,State,ResultAdmissible) :- 
  goal_description(GoalState),
  lists:subtract(State,GoalState,Difference),
  lists:length(Difference,Result),
  ResultAdmissible is Result // 3. %Heuristik zulässig machen
  % Integer-division damit es mit plus funktioniert
  


eval_state_help(stateMembers,State,Value) :-
  goal_description(GoalState), %read goal descreption
  subtract(GoalState,State,GoalSubset), %umso weniger abweichung vom ziel, desto besser(billiger)
  eval_stateMembers(GoalSubset,Value).

  %eval_stateMembers([],_).%alle stete elemente bewertet(abbruchbedingung)
  eval_stateMembers(StateMembers,ResultValue) :-
    maplist(stateMemberWeighting,StateMembers,WeigthingsList),
    foldl(plus,WeigthingsList,0,ResultValue).
    
%gewichtung der verschiedenen elemente eines states
stateMemberWeighting(block(_),0).%evtl. rausnehmen da eigentlich nie in der differenzmenge enthalten sein darf(GoalState \ State)
stateMemberWeighting(on(table,_),1).
stateMemberWeighting(on(Block,_),0) :- Block \= table.
stateMemberWeighting(clear(_),0).
stateMemberWeighting(handempty,0).
stateMemberWeighting(holding(_),0).


action(pick_up(X),
       [handempty, clear(X), on(table,X)],
       [handempty, clear(X), on(table,X)],
       [holding(X)]).

action(pick_up(X),
       [handempty, clear(X), on(Y,X), block(Y)],
       [handempty, clear(X), on(Y,X)],
       [holding(X), clear(Y)]).

action(put_on_table(X),
       [holding(X)],
       [holding(X)],
       [handempty, clear(X), on(table,X)]).

action(put_on(Y,X),
       [holding(X), clear(Y)],
       [holding(X), clear(Y)],
       [handempty, clear(X), on(Y,X)]).


% Hilfskonstrukt, weil das PROLOG "subset" nicht die Unifikation von Listenelementen 
% durchführt, wenn Variablen enthalten sind. "member" unifiziert hingegen.
%
mysubset([],_).
mysubset([H|T],List):-
  member(H,List),
  mysubset(T,List).


expand_help(State,Name,NewState):-
  action(Name,CondList,DelList,AddList),% "Action suchen"
  mysubset(CondList,State), % "Conditions testen"
  lists:subtract(State,DelList,StateMinusDel), % "Del-List umsetzen"
  lists:union(AddList,StateMinusDel,NewState). % "Add-List umsetzen"
  
expand((_,State,_),Result):-
  findall((Name,NewState,_),expand_help(State,Name,NewState),Result).


%! symmetric_difference(SetA:list,SetB:list,Result:list) 
%  Berechnet die Symmetrische Differenz zwischen SetA und SetB 
%  Definition siehe 
%  http://de.wikipedia.org/wiki/Menge_%28Mathematik%29#Symmetrische_Differenz 
%  oder http://mathworld.wolfram.com/SymmetricDifference.html
%  oder http://rosettacode.org/wiki/Symmetric_difference
symmetric_difference(SetA,SetB,Result) :- 
   lists:subtract(SetA,SetB,SetAMinusB),
   lists:subtract(SetB,SetA,SetBMinusA),
   lists:union(SetAMinusB,SetBMinusA,Result).

:- begin_tests(planning_helpers). 

test(symmetric_difference) :-
        A = [john,bob,mary,serena],
        B = [jim,mary,john,bob],
        symmetric_difference(A,B,[serena,jim]).


:- end_tests(planning_helpers).























