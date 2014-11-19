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
lex(wer,wer,i,_,_). % "_Wer_ ist [...]"

%Artikel
lex(der,der,a,sg,m).
lex(die,die,a,sg,f).
lex(die,die,a,pl,_).
lex(das,das,a,sg,n).
lex(ein,ein,a,_,n).
lex(eine,eine,a,_,f).

%Nomen
lex(mutter,mutter,n,sg,f). % "Wer ist die _Mutter_ von Simone?"
lex(vater,vater,n,sg,m).
lex(partner,partner,n,sg,n).
lex(eltern,eltern,n,pl,n).
lex(kind,kind,n,sg,n).
lex(kinder,kinder,n,pl,n).
lex(bruder,bruder,n,sg,m).
lex(geschwister,geschwister,n,pl,n).
lex(cousin,cousin,n,sg,m).
lex(onkel,onkel,n,sg,m).
lex(tante,tante,n,sg,f).
lex(grosstante,grosstante,n,sg,f).
lex(nichte,nichte,n,sg,f).
lex(neffe,neffe,n,sg,m).
lex(mann,mann,n,sg,m).
lex(frau,frau,n,sg,f).
lex(affaere,affaere,n,sg,n).

%Präposition
lex(von,von,p,_,_).
lex(mit,mit,p,_,_).

%Verben
lex(ist,sein,v,sg,_). % "Wer _ist_ der Vater von Simone?"
lex(sind,sein,v,pl,_).

