%Anwendung unseres Prolog-Solvers: Modellierung des Einstein-Rätsels
%11.12.2014 Timo Lange, Christian Schirin

:- ensure_loaded('ConstraintGenerators.pl').

:-set_prolog_flag(toplevel_print_options,
                  [quoted(true),
                   portray(true),
                   max_depth(0)]).
/*Constraint-modelierung frei nach: http://stackoverflow.com/questions/11122814/
solving-the-zebra-puzzle-aka-einstein-puzzle-using-the-clpfd-prolog-library */
/*Was machen VarsAndDoms und ConstraintNet? Diese beiden variablen beeinhalten 
  die datenstrukturen, welche Benötigt werden, um den Constraint-löse 
  algorithmus darauf anzuwenden */

model_einstein([Brite,Schwede,Daene,Norweger,Deutscher],Fisch,VarsAndDoms,ConstraintNet) :- 

Nationalitaeten   = [Brite,Schwede,Daene,Norweger,Deutscher],
Haustiere         = [Hund,Vogel,Katze,Pferd,Fisch],
Getraenke         = [Tee,Kaffee,Milch,Bier,Wasser],
Hausfarben        = [Rot,Gruen,Weiss,Gelb,Blau],
Zigarrettenmarken = [PallMall,Marlboro,Dunhill,Winfield,Rothmanns],

/* Einschränken der Wertebereiche */
/* Warum alle wertebereiche 1 bis 5? Weil die hausnummer als die Identität des
   Bewohners verwendet wird. Das ist so als würde man z.B sagen: 
   "Der Brite wohnt im haus mit der gleichen nummer 
   wie das haus, dass rot gestrichen ist", Ausserdem wird in einigen hinweisen
   darauf referenziert, dass die häuser durchnummeriert sind, zum Beispiel wohnt
   ja laut Punkt 9 der Norweger im ersten Haus. */ 

elems_in_bounds(1,Nationalitaeten,5,VNats),
elems_in_bounds(1,Haustiere,5,VPets),
elems_in_bounds(1,Getraenke,5,VDrinks),
elems_in_bounds(1,Hausfarben,5,VColors),
elems_in_bounds(1,Zigarrettenmarken,5,VSmokes),

/* Warum All-Different Constraint? -> Ein hausbewohner kann nicht in mehreren
häusern wohnen! Wenn jemand gerne eine Zigarettenmarke raucht, sind die anderen
marken für ihn ausgeschlossen. Wir haben so gesehen eine einfache zuordnung: 
Wenn wir wissen, in welchem haus eine Person wohnt, wissen wir alle anderen
eigenschaften über sie, und daher macht es sinn, all_different zu benutzen */
all_different(Nationalitaeten,CNats),
all_different(Haustiere,CPets),
all_different(Getraenke,CDrinks),
all_different(Hausfarben,CColors),
all_different(Zigarrettenmarken,CSmokes),




/* Die Constraints, welche hinweise für das Rätsel sind */
%1. Der Brite lebt im roten Haus.
eq(Brite,Rot,C1),
%2. Der Schwede hält sich einen Hund.
eq(Schwede,Hund,C2),
%3. Der Däne trinkt gern Tee.
eq(Daene,Tee,C3),
%4. Das grüne Haus steht links neben dem weißen Haus.
eq(Gruen,Weiss - 1,C4), %Var - 1 : Steht links davon, Var + 1 : Steht rechts davon
%5. Der Besitzer des grünen Hauses trinkt Kaffee.
eq(Gruen,Kaffee,C5),
%6. Die Person, die Pall Mall raucht, hat einen Vogel.
eq(PallMall,Vogel,C6),
%7. Der Mann im mittleren Haus trinkt Milch.
eq(3,Milch,C7),
%8. Der Bewohner des gelben Hauses raucht Dunhill.
eq(Gelb,Dunhill,C8),
%9. Der Norweger lebt im ersten Haus.
eq(Norweger,1,C9),
%10. Der Malboro-Raucher wohnt neben der Person mit der Katze.
nachbar(Marlboro,Katze,C10),
%11. Der Mann mit dem Pferd lebt neben der Person, die Dunhill raucht.
nachbar(Pferd,Dunhill,C11),
%12. Der Winfield-Raucher trinkt gern Bier.
eq(Winfield,Bier,C12),
%13. Der Norweger wohnt neben dem blauen Haus.
nachbar(Norweger,Blau,C13),
%14. Der Deutsche raucht Rothmanns.
eq(Deutscher,Rothmanns,C14),
%15. Der Malboro-Raucher hat einen Nachbarn, der Wasser trinkt.
nachbar(Marlboro,Wasser,C15),

%Variablen und domänen in liste stecken
append([VNats,VPets,VDrinks,VColors,VSmokes],VarsAndDoms),

%ConstraintNetz zusammenbauen
append([CNats,CPets,CDrinks,CColors,CSmokes],AllDifferents),
append(AllDifferents,
[C1,C2,C3,C4,C5,C6,C7,C8,C9,C10,C11,C12,C13,C14,C15],
ConstraintNet)

.


