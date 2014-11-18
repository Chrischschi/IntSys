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
lex(wer,wer,i,_). % "_Wer_ ist [...]"

%Artikel
lex(der,der,a,sg).
lex(die,die,a,pl).
lex(die,die,a,sg).
lex(das,das,a,sg).
lex(ein,ein,a,_).
lex(eine,eine,a,_).

%Nomen
lex(mutter,mutter,n,sg). % "Wer ist die _Mutter_ von Simone?"
lex(vater,vater,n,sg).
lex(eltern,eltern,n,pl).
lex(kind,kind,n,sg).
lex(bruder,bruder,n,sg).
lex(geschwister,geschwister,n,pl).
lex(cousin,cousin,n,sg).
lex(onkel,onkel,n,sg).
lex(tante,tante,n,sg).
lex(grosstante,grosstante,n,sg).
lex(nichte,nichte,n,sg).
lex(neffe,neffe,n,sg).
lex(mann,mann,n,sg).
lex(frau,frau,n,sg).
lex(verheiratet,verheiratet,n,sg).
lex(affaere,affaere,n,sg).

%Präposition
lex(von,von,p,_).
lex(mit,mit,p,_).

%Verben
lex(ist,sein,v,sg). % "Wer _ist_ der Vater von Simone?"
lex(sind,sein,v,pl).

