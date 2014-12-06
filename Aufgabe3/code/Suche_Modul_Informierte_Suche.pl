% Informierte Suche


eval_paths(_,_,[]).

eval_paths(StateHeuristic,StrategyRestPath,[FirstPath|RestPaths]):-
  eval_path(StateHeuristic,StrategyRestPath,FirstPath),
  eval_paths(StateHeuristic,StrategyRestPath,RestPaths).



insert_new_paths_informed([],OldPaths,OldPaths).

insert_new_paths_informed([FirstNewPath|RestNewPaths],OldPaths,AllPaths):-
  insert_path_informed(FirstNewPath,OldPaths,FirstInserted),
  insert_new_paths_informed(RestNewPaths,FirstInserted,AllPaths).


insert_path_informed(NewPath,[],[NewPath]).

% Wenn der Pfad billiger ist, dann wird er vorn angef�gt. (Alte Pfade sind ja sortiert.)
%
insert_path_informed(NewPath,[FirstPath|RestPaths],[NewPath,FirstPath|RestPaths]):-
  cheaper(NewPath,FirstPath),!.

% Wenn er nicht billiger ist, wird er in den Rest insortiert und der Kopf 
% der Openliste bleibt Kopf der neuen Liste
%
insert_path_informed(NewPath,[FirstPath|RestPaths],[FirstPath|NewRestPaths]):-
  insert_path_informed(NewPath,RestPaths,NewRestPaths).  


cheaper([(_,_,V1)|_],[(_,_,V2)|_]):-
  V1 =< V2.

/* insert_new_paths_informed_ohc(+NewPaths,+OldPaths,-AllPaths) is det.
 * Spezielle fassung von insert_new_paths_informed f�r 
 * Optimistisches Bergsteigen */ 
insert_new_paths_informed_ohc([],OldPaths,OldPaths).
insert_new_paths_informed_ohc([FirstNewPath|RestNewPaths],OldPaths,AllPaths):-
  insert_path_informed_ohc(FirstNewPath,OldPaths,FirstInserted),
  insert_new_paths_informed_ohc(RestNewPaths,FirstInserted,AllPaths).

/* Spezielle fassung von insert_path_informed f�r Optimistisches Bergsteigen */  
insert_path_informed_ohc(NewPath,[],[NewPath]).
insert_path_informed_ohc(NewPath,[FirstPath|RestPaths],[NewPath,FirstPath|RestPaths]):-
  cheaper(NewPath,FirstPath),!.
insert_path_informed_ohc(_,[FirstPath|RestPaths], [FirstPath|NewRestPaths] ):-
  insert_path_informed_ohc([],RestPaths,NewRestPaths).
  

