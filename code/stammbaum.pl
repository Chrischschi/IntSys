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


