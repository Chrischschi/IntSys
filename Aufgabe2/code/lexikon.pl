%prolog lexikon.pl
%Intelligente Systeme Praktikum 2
% Timo Lange, Christian Schirin
% 29.Oktober.2014

/* Diese Datei beinhaltet ein einfaches, unvollständiges lexikon für die
 * Deutsche Sprache. Gerade gut genug um Entscheidungsfragen und Ergänzungs-
 * fragen formulieren zu können. */
%Eigenname. Die Namen kommen aus den fakten unserer Stammbaum-Datei.
:- consult('../../Aufgabe1/code/stammbaum.pl'). %mann/1,frau/1 benötigt
%kon(Nummerus,Person,Genus)
lex(Name,Name,e) :- mann(Name).
lex(Name,Name,e) :- frau(Name).

%Interrogativpronomen
lex(wer,wer,i). % "_Wer_ ist [...]"

%Artikel
lex(der,der,a).
lex(die,die,a).
lex(die,die,a).
lex(das,das,a).
lex(ein,ein,a).
lex(eine,eine,a).

%Nomen
lex(mutter,mutter,n). % "Wer ist die _Mutter_ von Simone?"
lex(vater,vater,n).
lex(eltern,eltern,n).
lex(kind,kind,n).
lex(bruder,bruder,n).
lex(geschwister,geschwister,n).
lex(cousin,cousin,n).
lex(onkel,onkel,n).
lex(tante,tante,n).
lex(grosstante,grosstante,n).
lex(nichte,nichte,n).
lex(neffe,neffe,n).
lex(mann,mann,n).
lex(frau,frau,n).
lex(verheiratet,verheiratet,n).
lex(affaere,affaere,n).

%Präposition
lex(von,von,p).
lex(mit,mit,p).

%Verben
lex(ist,sein,v). % "Wer _ist_ der Vater von Simone?"
lex(sind,sein,v).

