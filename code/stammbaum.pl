%% prolog
%% Intelligente Systeme Praktikum 1
%% Aufgabe 1 Stammbaum
%% Christian Schirin, Timo Lange
%% 3.10.2014

%%%	FAKTEN

mann(phillip).
mann(christoph).
mann(tony).
mann(richard).
mann(siegfried).
mann(klaus).
mann(karl).
mann(michael).
mann(don_juan).

frau(julia).
frau(simone).
frau(karla).
frau(anna).
frau(maria).
frau(anna).
frau(liselotte).
frau(elisabeth).

%%  verheiratet und affäre symmetrisch?
verheiratet(christoph,julia).
verheiratet(julia,christoph).
verheiratet(tony,simone).
verheiratet(simone,tony).
verheiratet(karla,siegfried).
verheiratet(siegfried,karla).
verheiratet(klaus,maria).
verheiratet(maria,klaus).
verheiratet(karl,liselotte).
verheiratet(liselotte,karl).

affaere(liselotte,don_juan).
affaere(don_juan,liselotte).

%% kind aus beziehung, kind_aus(Mann,Frau,Kind).
kind_aus(christoph,julia,phillip).
kind_aus(tony,simone,julia).
kind_aus(tony,simone,richard).
kind_aus(siegfried,karla,simone).
kind_aus(klaus,maria,siegfried).
kind_aus(klaus,maria,anna).
kind_aus(klaus,maria,karl).
kind_aus(karl,liselotte,michael).
kind_aus(don_juan,liselotte,elizabeth).

%%%	REGELN

mutter(Mutter, Kind):-kind_aus(_,Mutter, Kind).
vater(Vater, Kind) :- kind_aus(Vater,_, Kind).
eltern(Kind,Eltern) :- kind_aus(Vater,Mutter,Kind),Eltern=(Vater,Mutter).
geschwister(Person1,Person2) :- vollgeschwister(Person1,Person2);halbgeschwister(Person1, Person2).
vollgeschwister(Person1, Person2) :- kind_aus(Vater, Mutter,Person1),kind_aus(Vater,Mutter,Person2).
halbgeschwister(Person1,Person2) :- kind_aus(Vater1, Mutter1, Person1), kind_aus(Vater2, Mutter2, Person2), Vater1\=Vater2.
halbgeschwister(Person1,Person2) :- kind_aus(Vater1, Mutter1, Person1), kind_aus(Vater2, Mutter2, Person2), Mutter1\=Mutter2.




