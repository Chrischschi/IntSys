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
  state_member(GoalState,[State]).%"Zustand gegen Zielbedingungen testen"



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



eval_path([(_,State,Value)|RestPath]):-
  lists:length(RestPath,RestPathLength), %kürzere pfade sind besser
  eval_state(State,StateValue),
  plus(RestPathLength,StateValue,Value). %statt pfad länge vielleicht lieber die addierten state-values des restpfades??

eval_state(State, Value) :-
  goal_description(GoalState), %read goal descreption
  subtract(GoalState,State,GoalSubset), %umso weniger abweichung vom ziel, desto besser(billiger)
  eval_stateMembers(GoalSubset,Value).

  %eval_stateMembers([],_).%alle stete elemente bewertet(abbruchbedingung)
  eval_stateMembers(StateMembers,ResultValue) :-
    maplist(stateMemberWeighting,StateMembers,WeigthingsList),
    foldl(plus,WeigthingsList,0,ResultValue).
    %stateMemberWeighting(FirstStateMember,MemberValue),
    %eval_stateMembers(RestStateMembers,Value),
    %plus(Value,MemberValue,ResultValue).
    
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


























