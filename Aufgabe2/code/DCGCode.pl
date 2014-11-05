
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
	i(_SemI,N),
	vp(SemVP,N),
	pp(SemPP,N),
	{
	    SemVP = [_,_,X],
	    SemS =.. [X,_Y,SemPP]
	}.

% "Eine Nominalphrase kann sein:"
% Eigenname
np(SemN, N) --> e(SemN,N).

% (Ergänzt) Interrogativpronomen
np(SemN, N) --> i(SemN, N).

% Artikel, Nomen
np(SemN, N) --> a(_),n(SemN, N).

% Artikel, Nomen, Präpositionalphrase
np(SemN, N) --> a(_),n(SemN, N),pp(_, N).

% "Eine Präpositionalphrase kann sein:"
% Präposition,Nominalphrase
pp(SemPP, N) --> p(_, N),np(SemPP, N).

%Präposition,<Bestandteile einer Nominalphrase wie oben aufgeführt>
%Präposition,Eigenname
pp(SemPP, N) --> p(_, N),e(SemPP, N).
%Präposition,Interrogativpronomen
pp(SemPP, N) --> p(_, N),i(SemPP, N).
%Präposition,Artikel,Nomen
pp(SemPP, N) --> p(_, N),a(_),n(SemPP, N).
%Präposition,Artikel,Nomen
pp(SemPP, N) --> p(_, N),a(_),n(SemPP, N),pp(_, N).

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
p(_,_) --> [X], {lex(X,_,p,_)}.

%Verb
v(SemV,N) --> [X], {lex(X,SemV,v,N)}.

:- begin_tests('DCGCode').

test(s) :-  %ergaenzungsfrage
	s(onkel(wer,simone),[wer,ist,der,onkel,von,simone],[]).

test(s) :-  %ergaenzungsfrage
	s(onkel(karl,simone),[ist,karl,der,onkel,von,simone],[]).

test(s)	:-
	s(onkel(richard,phillip),[ist,richard,der,onkel,von,phillip],[]).


:- end_tests('DCGCode').




