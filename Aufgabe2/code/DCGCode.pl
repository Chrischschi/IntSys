%prolog 
%Intelligente Systeme Praktikum 2
%Christian Schirin, Timo Lange
% 29.10.2014

/* Diese Datei beinhält die definition der DCG, basierend auf der definition
 * auf seite 2 der Aufgabenstellung der Praktikumsaufgabe. */
%TODO aktionen hinzufügen

% ----------------------- Non-terminale -----------------------------------
/*Ein satz ist eine nominalphrase gefolgt von einer Verbalphrase.*/
s --> np,vp.

% "Eine Nominalphrase kann sein:" 
% Eigenname 
np --> e.

% (Ergänzt) Interrogativpronomen
np --> i.

% Artikel, Nomen
np --> a,n.

% Artikel, Nomen, Präpositionalphrase
np --> a,n,pp.  

% "Eine Präpositionalphrase kann sein:"
% Präposition,Nominalphrase
pp --> p,np.

%Präposition,<Bestandteile einer Nominalphrase wie oben aufgeführt>
%Präposition,Eigenname
pp --> p,e.
%Präposition,Interrogativpronomen
pp --> p,i.
%Präposition,Artikel,Nomen
pp --> p,a,n.
%Präposition,Artikel,Nomen
pp --> p,a,n,pp.

%Eine Verbalphrase kann sein:
%Verb 
vp --> v. 

%Verb,Nominalphrase
vp --> v,np.

%-------------------------------Terminale--------------------------------------
:- consult('lexikon.pl').

%Eigenname
e --> [X], {lex(X,e)}.

%Interrogativpronomen
i --> [X], {lex(X,i)}. 

%Artikel 
a --> [X], {lex(X,a)}.

%Nomen 
n --> [X], {lex(X,n)}. 

%Präposition 
p --> [X], {lex(X,p)}. 

%Verb
v --> [X], {lex(X,v)}.

