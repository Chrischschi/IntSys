%prolog lexikon.pl
%Intelligente Systeme Praktikum 2
% Timo Lange, Christian Schirin
% 29.Oktober.2014 

/* Diese Datei beinhaltet ein einfaches, unvollständiges lexikon für die 
 * Deutsche Sprache. Gerade gut genug um Entscheidungsfragen und Ergänzungs-
 * fragen formulieren zu können. */
%Eigenname. Die Namen kommen aus den fakten unserer Stammbaum-Datei.
:- consult('../../Aufgabe1/code/stammbaum.pl'). %mann/1,frau/1 benötigt
lex(Name,e) :- mann(Name);frau(Name).

%Interrogativpronomen
lex(wer,i). % "_Wer_ ist [...]"

%Artikel
lex(der,a).
lex(die,a).
lex(das,a).

%Nomen
lex(mutter,n). % "Wer ist die _Mutter_ von Simone?"
lex(vater,n).
lex(onkel,n).
lex(tante,n).

%Präposition
lex(von,p).

%Verben 
lex(ist,v). % "Wer _ist_ der Vater von Simone?"
 
