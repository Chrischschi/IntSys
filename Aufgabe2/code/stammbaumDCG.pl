% prolog stammbaumDCG.pl
% IS Praktikum 2 
% Timo Lange, Christian Schirin
% 29.Oktober.2014 

/* einstiegspunkt für die dcg-anwendung. 
   beim aufrufen kann man eine frage stellen, welche 
   am besten mit ? aber auch möglich mit ! oder . abgeschlossen
   wird. */  
frage_stellen :- false.
 %TODO implementieren mit read_sentence/1, filtere_satzzeichen/2, antworten/2 und schreibe_satz/1  

%% filtere_satzzeichen(+Mit,-Ohne)
%% hilfsfunktion um nicht DCG mit verarbeitung von Satzzeichen belasten
%% zu müssen.
filtere_satzzeichen(Mit,Ohne) :- false.

%% antworten(+Frage, -Antwort)
%% gibt eine antwort für eine als liste von atomen gegebene Fragesatz. 
%% Es werden Entscheidungsfragen und Ergänzungsfragen über den stammbaum aus
%% Aufgabe 1 beantwortet.
%% Parameter: 
%% Frage - Ein satz als liste von atomen 
%% Antwort - Ein satz als liste von atomen
antworten(Frage,Antwort) :- false. %TODO hier DCG Code verwenden 

%% schreibe_satz(+Satz) 
%% Gibt einen satz auf der konsole aus
%% Parameter: Satz - eine liste von atomen 
schreibe_satz([]). %Rekursionsabbruch
schreibe_satz(Satz) :- false. %TODO hier write und rekursion verwenden. 



%Unit-tests

:- begin_tests(stammbaumDCG).

test(antworten) :- 
    antworten(
    [ist,klaus,der,vater,von,siegfried],
    [ja]
    ),
    [ist,maria,die,mutter,von,michael],
    [nein]
    ),
    antworten(
    [wer,ist,der,vater,von,siegfried],
    [klaus,ist,der,vater,von,siegfried]
    ),
    antworten(
    [wer,ist,der,onkel,von,simone],
    [karl,ist,der,onkel,von,simone]
    ),
    antworten(
    [wer,ist,die,tante,von,simone],
    [anna,ist,die,tante,von,simone]
    )
    .
:- end_tests(stammbaumDCG).


