% prolog stammbaumDCG.pl
% IS Praktikum 2
% Timo Lange, Christian Schirin
% 29.Oktober.2014

%mapping auf stammbaum praedikate
kind(Kinder, Elternteil) :- kinder(Kinder, Elternteil),!.
kinder(Kinder, Elternteil) :- kind_aus(Elternteil,_,Kinder);kind_aus(_,Elternteil,Kinder).

partner(P1,P2) :- verheiratet(P1,P2).

/* einstiegspunkt für die dcg-anwendung.
   beim aufrufen kann man eine frage stellen, welche
   am besten mit ? aber auch möglich mit ! oder . abgeschlossen
   wird. */
:- consult('../beispielcode/readsentence.pl').
:- consult('DCGCode.pl').
frage_stellen :- read_sentence(FrageListe),
	filtere_satzzeichen(FrageListe,GefilterteListe),
	s(Sem,FrageTyp,GefilterteListe,[]), write(Sem), nl,
	antworten(Sem,AntwortSatz,FrageTyp),
        append(AntwortSatz,['.'],AntwortSatzMitPunkt),
	schreibe_satz(AntwortSatzMitPunkt),nl.


%% filtere_satzzeichen(+Mit,-Ohne)
%% hilfsfunktion um nicht DCG mit verarbeitung von Satzzeichen belasten
%% zu müssen.
filtere_satzzeichen([],[]).
filtere_satzzeichen([Word|List],[Word|Gefiltert]) :- Word \== '.', Word \== '!', Word \== '?',
	filtere_satzzeichen(List,Gefiltert).
filtere_satzzeichen([_Word|List],Gefiltert) :- filtere_satzzeichen(List,Gefiltert).



%% antworten(+FrageP, -Antwort,+Fragetyp)
%% gibt eine antwort für eine als prädikat gegebene frage.
%% Es werden Entscheidungsfragen und Ergänzungsfragen über den stammbaum aus
%% Aufgabe 1 beantwortet.
%% Parameter:
%% FrageP - Die semantik des satzes aus dem parameter darüber
%% Antwort - Ein satz als liste von atomen
%% Fragetyp - Atom - wahl zwischen 'ergaenzungsfrage' und
%% 'entscheidungsfrage'
antworten(FrageP,Antwort,ergaenzungsfrage) :-
	/* Ergaenzungsfragen haben die struktur "Wer ist der <Beziehung> von Y?"
	  Antworten darauf lassen sich mit der Struktur  "X ist der <Beziehung> von Y"
	  formulieren. */
          FrageP =.. [Beziehung,P1,P2],
            setof(P1,FrageP,Personen) -> %% Frage an stammbaum stellen
          lex(Beziehung,_,n,Numerus,_),
          lex(Verb,_,v,Numerus,_),
          append(Personen,[Verb,Beziehung,von,P2],Antwort);
          
            not(setof(P1,FrageP,Personen)),
            FrageP =.. [Beziehung,P1,P2],
            Antwort = [P2,hat,keine,Beziehung]
          . 

/*Entscheidungsfragen sind Ja-Nein Fragen
    und lassen sich daher mit "Ja" und "Nein" beantworten.*/
antworten(FrageP,['Ja'],entscheidungsfrage) :- FrageP.
antworten(FrageP,['Nein'],entscheidungsfrage) :- not(FrageP).

%!  artikel_aus_eigenname(+Artikel:atom,-Eigenname:atom) is det 
%   hilfsfunktion, um zu einem eigennamen den entsprechenden artikel zu finden.
%%artikel_aus_eigenname(der,EigennameMaennlich) :- mann(EigennameMaennlich).
%%artikel_aus_eigenname(die,EigennameWeiblich) :- frau(EigennameWeiblich).
%%artikel_aus_eigenname(die,(Vater,Mutter)) :- mann(Vater),frau(Mutter).

tupelZweiZuListe((First,Second),[First,Second]).

%%listeMitUnd([],[]).
%%listeMitUnd([Word|Rest],ListeMit) :- listeMitUnd(Rest,[Word,'und'|ListeMit]).


%% schreibe_satz(+Satz)
%% Gibt einen satz auf der konsole aus
%% Parameter: Satz - eine liste von atomen
schreibe_satz([]). %Rekursionsabbruch
schreibe_satz([Word|Rest]) :- write(Word),tab(1),schreibe_satz(Rest). %tab macht leerzeichen 



%Unit-tests

:- begin_tests(stammbaumDCG).

test(antworten) :-
    antworten(
    vater(klaus,siegfried),
    ['Ja'],
    entscheidungsfrage
    ).
test(antworten) :-
    antworten(
    mutter(maria,michael),
    ['Nein'],
    entscheidungsfrage
    ).
test(antworten) :-
    antworten(
    vater(_,siegfried),
    [klaus,ist,vater,von,siegfried],
    ergaenzungsfrage
    ).
test(antworten) :-
    antworten(
    onkel(_,simone),
    [karl,ist,onkel,von,simone],
    ergaenzungsfrage
    ).
test(antworten) :-
    antworten(
    tante(_,simone),
    [anna,ist,tante,von,simone],
    ergaenzungsfrage
    ).
:- end_tests(stammbaumDCG).


