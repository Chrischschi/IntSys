% Autor: Christian Schirin
% Datum: 10.12.2014

variablen(Nationalitaet,Haustier,Getraenk,Hausfarbe,Ziggarrettenmarke) :-
Nationalitaet    = [Brite,Schwede,Daene,Norweger,Deutscher],
Haustier         = [Hund,Vogel,Katze,Pferd,Fisch],
Getraenk         = [Tee,Kaffee,Milch,Bier,Wasser],
Hausfarbe        = [Rot,Gruen,Weiss,Gelb,Blau],
Zigarrettenmarke = [PallMall,Dunhill,Marlboro,Dunhill,Rothmanns],

%Wertebereiche der variablen setzen
elems_between(1,Nationalitaet,5),
elems_between(1,Haustier,5),
elems_between(1,Getraenk,5),
elems_between(1,Hausfarbe,5),
elems_between(1,Zigarrettenmarke,5),

% Constraints ausdruecken
eq(Brite,Rot),
eq(Schwede,Hund)
.






