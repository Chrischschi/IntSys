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
lex(Name,Name,e,kon(sg,3,m)) :- mann(Name).
lex(Name,Name,e,kon(sg,3,f)) :- frau(Name).

%Interrogativpronomen
lex(wer,wer,i,kon(_,_,_)). % "_Wer_ ist [...]"

%Artikel
lex(der,der,a,kon(_,_,m)).
lex(die,die,a,kon(sg,_,f)).
lex(die,die,a,kon(pl,_,_)).
lex(das,das,a,kon(sg,_,n)).
lex(ein,ein,a,kon(sg,_,_)).
lex(eine,eine,a,kon(pl,_,_)).

%Nomen
lex(mutter,mutter,n,kon(sg,_,f)). % "Wer ist die _Mutter_ von Simone?"
lex(vater,vater,n,kon(sg,_,m)).
lex(eltern,eltern,n,kon(pl,_,_)).
lex(kind,kind,n,kon(sg,_,n)).
lex(bruder,bruder,n,kon(sg,_,m)).
lex(geschwister,geschwister,n,kon(sg,_,_)).
lex(cousin,cousin,n,kon(sg,_,m)).
lex(onkel,onkel,n,kon(sg,_,m)).
lex(tante,tante,n,kon(sg,_,f)).
lex(grosstante,grosstante,n,kon(sg,_,f)).
lex(nichte,nichte,n,kon(sg,_,f)).
lex(neffe,neffe,n,kon(sg,_,m)).
lex(mann,mann,n,kon(sg,_,m)).
lex(frau,frau,n,kon(sg,_,f)).
lex(verheiratet,verheiratet,n,kon(sg,_,_)).
lex(affaere,affaere,n,kon(sg,_,_)).

%Präposition
lex(von,von,p,kon(_,_,_)).
lex(mit,mit,p,kon(_,_,_)).

%Verben
lex(ist,sein,v,kon(sg,_,_)). % "Wer _ist_ der Vater von Simone?"
lex(sind,sein,v,kon(sg,_,_)).

