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

%%  Mann verheiratet mit frau definiert als fakt,
% Frau verheiratet mit Mann definiert als regel.
verheiratet(christoph,julia).
verheiratet(tony,simone).
verheiratet(siegfried,karla).
verheiratet(klaus,maria).
verheiratet(karl,liselotte).
verheiratet(F,M) :- frau(F), mann(M), verheiratet(M,F).

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
nicht_verheiratet(Person1, Person2) :- \+ verheiratet(Person1,Person2).
mutter(Mutter, Kind):-kind_aus(_,Mutter, Kind).
vater(Vater, Kind) :- kind_aus(Vater,_, Kind).
eltern(Kind,Eltern) :- kind_aus(Vater,Mutter,Kind),Eltern=(Vater,Mutter).
bruder(Person, Bruder) :- mann(Bruder),geschwister(Person, Bruder).
%%   man kann nicht sein eingener bruder oder seine eigene schwester
%%   sein, dies gilt egal ob vollgeschwister oder halbgeschwister.
geschwister(Person1,Person2) :- vollgeschwister(Person1,Person2);halbgeschwister(Person1, Person2).

vollgeschwister(Person1, Person2) :- kind_aus(Vater, Mutter,Person1),kind_aus(Vater,Mutter,Person2), Person1 \= Person2.
%% Bei halbgewschwistern muss ein elternteil gleich sein und das andere
%% darf nicht gleich sein, daher am ende die
%% gleichheitstest
halbgeschwister(Person1,Person2) :- kind_aus(Vater1, Mutter1, Person1), kind_aus(Vater2, Mutter2, Person2),Person1 \= Person2, Vater1\=Vater2,Mutter1=Mutter2.
halbgeschwister(Person1,Person2) :- kind_aus(Vater1, Mutter1, Person1), kind_aus(Vater2, Mutter2, Person2),Person1 \= Person2, Mutter1\=Mutter2,Vater1 = Vater2.
cousin(C1, C2) :- kind_aus(_V1,M1,C1), geschwister(M1,M2), kind_aus(_V2,M2,C2). %mütter sind geschwister
cousin(C1, C2) :- kind_aus(_V1,M1,C1), geschwister(M1,V2), kind_aus(V2,_M2,C2). %Mutter der cousine ist die schwester deines Vaters
cousin(C1, C2) :- kind_aus(V1,_M1,C1), geschwister(V1,V2), kind_aus(V2,_M2,C2). %väter sind geschwister
cousin(C1, C2) :- kind_aus(V1,_M1,C1), geschwister(V1,M2), kind_aus(_V2,M2,C2). %Vater der cousine ist ist der bruder deiner mutter
neffe(Neffe, Person) :- mann(Neffe), (tante(Person,Neffe) ; onkel(Person,Neffe)).
% nichte(Nichte,Person) :- frau(Nichte), (tante(Person,Nichte) ;
% onkel(Person,Nichte)).
nichte(Nichte,Person) :- (tante(Person,Nichte) ; onkel(Person,Nichte)),  \+ mann(Nichte).
onkel(Onkel, Person) :- mann(Onkel),  eltern(Person,(Vater,Mutter)), (geschwister(Vater,Onkel);geschwister(Mutter,Onkel)).
tante(Tante, Person) :- frau(Tante), eltern(Person,(Vater,Mutter)), (geschwister(Vater,Tante);geschwister(Mutter,Tante)).
  %% TODO herausfinden warum tante/2 alternative lösungen findet.
grosstante(Grosstante, Person) :- eltern(Person,(Vater,Mutter)), (tante(Grosstante, Vater);tante(Grosstante, Mutter)). %%Großtante = Tante eines Elternteils, siehe wikipedia.org/wiki/verwandschaftsbeziehungen#gro.C3.9F-



