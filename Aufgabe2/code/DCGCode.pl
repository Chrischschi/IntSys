%prolog
%Intelligente Systeme Praktikum 2
%Christian Schirin, Timo Lange
% 29.10.2014

/* Diese Datei beinhält die definition der DCG, basierend auf der definition
 * auf seite 2 der Aufgabenstellung der Praktikumsaufgabe. */
%TODO aktionen hinzufügen

% ----------------------- Non-terminale -----------------------------------
/*Ein satz ist eine nominalphrase gefolgt von einer Verbalphrase.*/
s(SemS) -->
  np(SemNP,N), vp(SemVP,N),
  {SemVP = [_,SemNP|_], SemS =.. SemVP}.

% "Eine Nominalphrase kann sein:"
% Eigenname
np(SemN, N) --> e(SemN,N).

% (Ergänzt) Interrogativpronomen
np(SemN, N) --> i(SemN, N).

% Artikel, Nomen
np(SemN, N) --> a(_),n(SemN, N).

% Artikel, Nomen, Präpositionalphrase
np(SemN, N) --> a(_),n(SemN, N),pp(SemN, N).

% "Eine Präpositionalphrase kann sein:"
% Präposition,Nominalphrase
pp(SemPP, N) --> p(SemPP, N),np(SemPP, N).

%Präposition,<Bestandteile einer Nominalphrase wie oben aufgeführt>
%Präposition,Eigenname
pp(SemPP, N) --> p(SemPP, N),e(SemPP, N).
%Präposition,Interrogativpronomen
pp(SemPP, N) --> p(SemPP, N),i(SemPP, N).
%Präposition,Artikel,Nomen
pp(SemPP, N) --> p(SemPP, N),a(_),n(SemPP, N).
%Präposition,Artikel,Nomen
pp(SemPP, N) --> p(SemPP, N),a(_),n(SemPP, N),pp(SemPP, N).

%Eine Verbalphrase kann sein:
%Verb
vp([SemV,_],N) --> v(SemV,N).

%Verb,Nominalphrase
vp([SemV,_,SemNP],N) --> v(SemV,N),np(SemNP,_).

%-------------------------------Terminale--------------------------------------
:- consult('lexikon.pl').

%Eigenname
e(SemE, N) --> [X], {lex(X,SemE,e,N)}.

%Interrogativpronomen(Ersetzt das Nomen bspw.: Wer,Was etc..)
i(SemI,N) --> [X], {lex(X,SemI,i,N)}.

%Artikel
a(_) --> [X], {lex(X,_,a,_)}.

%Nomen
n(SemN,N) --> [X], {lex(X,SemN,n,N)}.

%Präposition
p(SemP,N) --> [X], {lex(X,SemP,p,N)}.

%Verb
v(SemV,N) --> [X], {lex(X,SemV,v,N)}.

