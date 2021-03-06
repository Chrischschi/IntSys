% Das Programm wird mit solve(depth), solve(breadth) oder solve(informed) aufgerufen.
solve(Strategy):-
  start_description(StartState),
  solve((start,StartState,_),Strategy).
  
  
% Pr�dikat search: 
%   1. Argument ist die Liste aller Pfade. Der aktuelle Pfad ist an erster Stelle. 
%   Jeder Pfad ist als Liste von Zust�nden repr�sentiert, allerdings in falscher 
%   Reihenfolge, d.h. der Startzustand ist an letzter Position.
%   2. Argument ist die Strategie
%   3. Argument ist der Ergebnis-Pfad.
%
solve(StartNode,Strategy) :-
   S = (
        start_node(StartNode),
        search([[StartNode]],Strategy,Path)
        ),
  time(S),!.
  %reverse(Path,Path_in_correct_order),
  %write_solution(Path_in_correct_order).



write_solution(Path):-
  nl,write('SOLUTION:'),nl,
  write_actions(Path).  

write_actions([]).

write_actions([(Action,_,_)|Rest]):-
  write('Action: '),write(Action),nl,
  write_actions(Rest).





% Abbruchbedingung: Wenn ein Zielzustand erreicht ist, wird der aktuelle Pfad an den
% dritten Parameter �bertragen.
%
search([[FirstNode|Predecessors]|_],_,[FirstNode|Predecessors]) :- 
  goal_node(FirstNode).
  %nl,write('SUCCESS'),nl,!.


search([[FirstNode|Predecessors]|RestPaths],Strategy,Solution) :- 
  expand(FirstNode,Children),                                    % Nachfolge-Zust�nde berechnen
  generate_new_paths(Children,[FirstNode|Predecessors],NewPaths), % Nachfolge-Zust�nde einbauen 
  insert_new_paths(Strategy,NewPaths,RestPaths,AllPaths),        % Neue Pfade einsortieren
  search(AllPaths,Strategy,Solution).






















generate_new_paths(Children,Path,NewPaths):-
  maplist(get_state,Path,States),
  generate_new_paths_help(Children,Path,States,NewPaths).



% Abbruchbedingung, wenn alle Kindzust�nde abgearbeitet sind.
%
generate_new_paths_help([],_,_,[]).


% Falls der Kindzustand bereits im Pfad vorhanden war, wird der gesamte Pfad verworfen,
% denn er w�rde nur in einem Zyklus enden. (Dies betrifft nicht die Fortsetzung des 
% Pfades mit Geschwister-Kindern.) Es wird nicht �berpr�ft, ob der Kindzustand in einem
% anderen Pfad vorkommt, denn m�glicherweise ist dieser Weg der g�nstigere.
%
generate_new_paths_help([FirstChild|RestChildren],Path,States,RestNewPaths):- 
  get_state(FirstChild,State),state_member(State,States),!,
  generate_new_paths_help(RestChildren,Path,States,RestNewPaths).


% Ansonsten, also falls der Kindzustand noch nicht im Pfad vorhanden war, wird er als 
% Nachfolge-Zustand eingebaut.
%
generate_new_paths_help([FirstChild|RestChildren],Path,States,[[FirstChild|Path]|RestNewPaths]):- 
  generate_new_paths_help(RestChildren,Path,States,RestNewPaths).

 
get_state((_,State,_),State).



%%% Strategie:

write_action([[(Action,_)|_]|_]):-
  nl,write('Action: '),write(Action),nl.

write_next_state([[_,(_,State)|_]|_]):-
  nl,write('Go on with: '),write(State),nl.

write_state([[(_,State)|_]|_]):-
  write('New State: '),write(State),nl.

write_fail(depth,[[(_,State)|_]|_]):-
  nl,write('FAIL, go on with: '),write(State),nl.

write_fail(_,_):-  nl,write('FAIL').

% Alle Strategien: Keine neuen Pfade vorhanden
insert_new_paths(Strategy,[],OldPaths,OldPaths):-
  %write_fail(Strategy,OldPaths),
  !.

% Tiefensuche
insert_new_paths(depth,NewPaths,OldPaths,AllPaths):-
  append(NewPaths,OldPaths,AllPaths).
  %write_action(NewPaths).

% Breitensuche
insert_new_paths(breadth,NewPaths,OldPaths,AllPaths):-
  append(OldPaths,NewPaths,AllPaths).
  %write_next_state(AllPaths),
  %write_action(AllPaths).

% Informierte Suche
insert_new_paths(informed,NewPaths,OldPaths,AllPaths):-
  eval_paths(minus,lengthRestPath,NewPaths),
  insert_new_paths_informed(NewPaths,OldPaths,AllPaths).
  %write_action(AllPaths),
  %write_state(AllPaths).

%%%%%%%%%%%%%%%%% NEUE METHODEN F�R insert_new_paths/4 %%%%%%%%%%%%%%%%%%%%%%%%

% Optimistisches Bergsteigen 
insert_new_paths(opt_hill_climb, NewPaths, _OldPaths, CheckedLowestSuccessorPath) :-
  eval_paths(minus,ignoreRestPath,NewPaths),
  insert_new_paths_informed(NewPaths,[],SortedNewPaths),
  [LowestSuccessorPath|_] = SortedNewPaths,
  check_better_path(LowestSuccessorPath,CheckedLowestSuccessorPath),!.
  %write_action(SortedNewPaths),
  %write_state(SortedNewPaths).

%Es existiert noch kein alter Pfad, bzw. Vorg�nger ist der Startzustand
check_better_path([Head|Predecessor],[[Head|Predecessor]]) :-
  [(start,_,_)]=Predecessor.
%Neuer Pfad ist besser als der alte
check_better_path([Head|RestPath],[[Head|RestPath]]) :-
  cheaper([Head|RestPath],RestPath).
%Neuer Pfad ist nicht besser als alter
check_better_path(_,[]).

  
%Bergsteigen mit backtracking 
insert_new_paths(hillClimbingBT,NewPaths,OldPaths,AllPaths):-
  eval_paths(minus,ignoreRestPath,NewPaths),
  insert_new_paths_informed(NewPaths,[],NewPathsSorted),
  append(NewPathsSorted,OldPaths,AllPaths).
  %write_action(AllPaths),
  %write_state(AllPaths).

%gierige Bestensuche
insert_new_paths(greedyBFS,NewPaths,OldPaths,AllPaths):-
  eval_paths(minus,ignoreRestPath,NewPaths),
  insert_new_paths_informed(NewPaths,OldPaths,AllPaths).
  %write_action(AllPaths),
  %write_state(AllPaths).

%A*-algorithmus 
insert_new_paths(a-star,NewPaths,OldPaths,AllPaths) :- 
  eval_paths(minus,lengthRestPath,NewPaths),
  insert_new_paths_informed(NewPaths,OldPaths,AllPaths).
  %write_action(AllPaths),
  %write_state(AllPaths).
