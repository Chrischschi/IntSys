% prolog stammbaumDCG.pl
% IS Praktikum 2
% Timo Lange, Christian Schirin
% 29.Oktober.2014

/* einstiegspunkt für die dcg-anwendung.
   beim aufrufen kann man eine frage stellen, welche
   am besten mit ? aber auch möglich mit ! oder . abgeschlossen
   wird. */
:- consult('../beispielcode/readsentence.pl').
:- consult('DCGCode.pl').
frage_stellen :- read_sentence(FrageListe),
	filtere_satzzeichen(FrageListe,GefilterteListe),
	s(Sem,FrageTyp,GefilterteListe,[]), write(Sem), nl,
	antworten(GefilterteListe,Sem,AntwortSatz,FrageTyp),
	schreibe_satz(AntwortSatz),nl.

 %TODO implementieren mit read_sentence/1, filtere_satzzeichen/2, antworten/2 und schreibe_satz/1

%% filtere_satzzeichen(+Mit,-Ohne)
%% hilfsfunktion um nicht DCG mit verarbeitung von Satzzeichen belasten
%% zu müssen.
filtere_satzzeichen([],[]).
filtere_satzzeichen([Word|List],[Word|Gefiltert]) :- Word \== '.', Word \== '!', Word \== '?',
	filtere_satzzeichen(List,Gefiltert).
filtere_satzzeichen([_Word|List],Gefiltert) :- filtere_satzzeichen(List,Gefiltert).



%% antworten(+Frage,+FrageP, -Antwort,+Fragetyp)
%% gibt eine antwort für eine als liste von atomen gegebene Fragesatz.
%% Es werden Entscheidungsfragen und Ergänzungsfragen über den stammbaum aus
%% Aufgabe 1 beantwortet.
%% Parameter:
%% Frage - Ein satz als liste von atomen
%% FrageP - Die semantik des satzes aus dem parameter darüber
%% Antwort - Ein satz als liste von atomen
%% Fragetyp - Atom - wahl zwischen 'ergaenzungsfrage' und
%% 'entscheidungsfrage'
antworten(_Frage,_FrageP,_Antwort,ergaenzungsfrage) :-
	/* Ergaenzungsfragen haben die struktur "Wer ist der <Beziehung> von Y?"
	  Antworten darauf lassen sich mit der Struktur  "X ist der <Beziehung> von Y"
	  formulieren. */
	  fail.

/*Entscheidungsfragen sind Ja-Nein Fragen
	und lassen sich daher mit "Ja" und "Nein" beantworten.*/
antworten(_Frage,FrageP,['Ja'],entscheidungsfrage) :- FrageP.
antworten(_Frage,FrageP,['Nein'],entscheidungsfrage) :- not(FrageP).
	



%% schreibe_satz(+Satz)
%% Gibt einen satz auf der konsole aus
%% Parameter: Satz - eine liste von atomen
schreibe_satz([]). %Rekursionsabbruch
schreibe_satz([Word|Rest]) :- write(Word),schreibe_satz(Rest). %TODO hier write und rekursion verwenden.



%Unit-tests

:- begin_tests(stammbaumDCG).

test(antworten) :-
    antworten(
    [ist,klaus,der,vater,von,siegfried],
    vater(klaus,siegfried),
    ['Ja'],
    entscheidungsfrage
    ).
test(antworten) :-
    antworten(
    [ist,maria,die,mutter,von,michael],
    mutter(maria,michael),
    ['Nein'],
    entscheidungsfrage
    ).
test(antworten) :-
    antworten(
    [wer,ist,der,vater,von,siegfried],
    vater(_,siegfried),
    [klaus,ist,der,vater,von,siegfried],
    ergaenzungsfrage
    ).
test(antworten) :-
    antworten(
    [wer,ist,der,onkel,von,simone],
    onkel(_,simone),
    [karl,ist,der,onkel,von,simone],
    ergaenzungsfrage
    ).
test(antworten) :-
    antworten(
    [wer,ist,die,tante,von,simone],
    tante(_,simone),
    [anna,ist,die,tante,von,simone],
    ergaenzungsfrage
    ).
:- end_tests(stammbaumDCG).


