%Anwendung unseres Prolog-Solvers: Das Einstein-Rätsel
%11.12.2014 Timo Lange, Christian Schirin

/*Constraint-modelierung frei nach: http://stackoverflow.com/questions/11122814/
solving-the-zebra-puzzle-aka-einstein-puzzle-using-the-clpfd-prolog-library */
solve_einstein([Brite,Schwede,Daene,Norweger,Deutscher],Fisch) :- 

Nationalitaeten   = [Brite,Schwede,Daene,Norweger,Deutscher],
Haustiere         = [Hund,Vogel,Katze,Pferd,Fisch],
Getraenke         = [Tee,Kaffee,Milch,Bier,Wasser],
Hausfarben        = [Rot,Gruen,Weiss,Gelb,Blau],
Zigarrettenmarken = [PallMall,Dunhill,Marlboro,Dunhill,Rothmanns],

/* Warum All-Different Constraint? -> Ein hausbewohner kann nicht in mehreren
häusern wohnen! Wenn jemand gerne eine Zigarettenmarke raucht, sind die anderen
marken für ihn ausgeschlossen. Wir haben so gesehen eine einfache zuordnung: 
Wenn wir wissen, in welchem haus eine Person wohnt, wissen wir alle anderen
eigenschaften über sie, und daher macht es sinn, all_different zu benutzen */
all_different(Nationalitaeten),
all_different(Haustiere),
all_different(Getraenke),
all_different(Hausfarben),
all_different(Zigarrettenmarken),

/* Einschränken der Wertebereiche */
/* Warum alle wertebereiche 1 bis 5? Weil die hausnummer als die Identität des
   Bewohners verwendet wird. Das ist so als würde man z.B sagen: 
   "Der Brite wohnt im haus mit der gleichen nummer 
   wie das haus, dass rot gestrichen ist", Ausserdem wird in einigen hinweisen
   darauf referenziert, dass die häuser durchnummeriert sind, zum Beispiel wohnt
   ja laut Punkt 9 der Norweger im ersten Haus. */ 
elems_in_bounds(1,Nationalitaeten,5),
elems_in_bounds(1,Haustiere,5),
elems_in_bounds(1,Getraenke,5),
elems_in_bounds(1,Hausfarben,5),
elems_in_bounds(1,Zigarrettenmarken,5),


/* Die Constraints, welche hinweise für das Rätsel sind */
%1. Der Brite lebt im roten Haus.
eq(Brite,Rot),
%2. Der Schwede hält sich einen Hund.
eq(Schwede,Hund),
%3. Der Däne trinkt gern Tee.
eq(Daene,Tee),
%4. Das grüne Haus steht links neben dem weißen Haus.
eq(Gruen,Links - 1), %Var - 1 : Steht links davon, Var + 1 : Steht rechts davon
%5. Der Besitzer des grünen Hauses trinkt Kaffee.
eq(Gruen,Kaffee),
%6. Die Person, die Pall Mall raucht, hat einen Vogel.
eq(PallMall,Vogel),
%7. Der Mann im mittleren Haus trinkt Milch.
eq(3,Milch),
%8. Der Bewohner des gelben Hauses raucht Dunhill.
eq(Gelb,Dunhill),
%9. Der Norweger lebt im ersten Haus.
eq(Norweger,1),
%10. Der Malboro-Raucher wohnt neben der Person mit der Katze.
nachbar(Marlboro,Katze),
%11. Der Mann mit dem Pferd lebt neben der Person, die Dunhill raucht.
nachbar(Pferd,Dunhill),
%12. Der Winfield-Raucher trinkt gern Bier.
eq(Winfield,Bier),
%13. Der Norweger wohnt neben dem blauen Haus.
nachbar(Norweger,Blau),
%14. Der Deutsche raucht Rothmanns.
eq(Deutscher,Rothmanns),
%15. Der Malboro-Raucher hat einen Nachbarn, der Wasser trinkt.
nachbar(Marlboro,Wasser),

% TODO: Wo AC-3-LA aufrufen?

true 
.


