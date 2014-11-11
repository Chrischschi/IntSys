
%prolog
%Intelligente Systeme Praktikum 2
%Christian Schirin, Timo Lange
% 29.10.2014

/* Diese Datei beinhält die definition der DCG, basierend auf der definition
 * auf seite 2 der Aufgabenstellung der Praktikumsaufgabe. */
%TODO aktionen hinzufügen

% ----------------------- Non-terminale -----------------------------------
/*Ein satz ist eine nominalphrase gefolgt von einer Verbalphrase.*/
% ergaenzungsfrage
s(SemS,ergaenzungsfrage) -->
	i(_SemI,Kon),
	vp(SemVP,Kon),
	pp(SemPP,Kon),
	{
	    SemVP = [_,_,X],
	    SemS =.. [X,_Y,SemPP]
	}.
%entscheidungsfrage
s(SemS,entscheidungsfrage) -->
	vp(_SemVP,Kon),
	e(SemE,Kon),
	np(SemNP,Kon),
	pp(SemPP,Kon),
	{
	    SemS =.. [SemNP,SemE,SemPP]
	}.


% "Eine Nominalphrase kann sein:"
% Eigenname
np(SemN,Kon) --> e(SemN,Kon).

% (Ergänzt) Interrogativpronomen
np(SemN,Kon) --> i(SemN,Kon).

% Artikel, Nomen
np(SemN,Kon) --> a(_),n(SemN,Kon).

% Artikel, Nomen, Präpositionalphrase
np(SemN,Kon) --> a(_),n(SemN,Kon),pp(_,Kon).

% "Eine Präpositionalphrase kann sein:"
% Präposition,Nominalphrase
pp(SemPP,Kon) --> p(_,Kon),np(SemPP,Kon).

%Präposition,<Bestandteile einer Nominalphrase wie oben aufgeführt>
%Präposition,Eigenname
pp(SemPP,Kon) --> p(_,Kon),e(SemPP,Kon).
%Präposition,Interrogativpronomen
pp(SemPP,Kon) --> p(_,Kon),i(SemPP,Kon).
%Präposition,Artikel,Nomen
pp(SemPP,Kon) --> p(_,Kon),a(_),n(SemPP,Kon).
%Präposition,Artikel,Nomen
pp(SemPP,Kon) --> p(_,Kon),a(_),n(SemPP,Kon),pp(_,Kon).

%Eine Verbalphrase kann sein:
%Verb
vp([SemV,_],Kon) --> v(SemV,Kon).

%Verb,Nominalphrase
vp([SemV,_,SemNP],Kon) --> v(SemV,Kon),np(SemNP,_).

%-------------------------------Terminale--------------------------------------
:- consult('lexikon.pl').

%Eigenname
e(SemE,_) --> [X], {lex(X,SemE,e,_)}.

%Interrogativpronomen(Ersetzt das Nomen bspw.: Wer,Was etc..)
i(SemI,Kon) --> [X], {lex(X,SemI,i,Kon)}.

%Artikel
a(_) --> [X], {lex(X,_,a,_)}.

%Nomen
n(SemN,Kon) --> [X], {lex(X,SemN,n,Kon)}.

%Präposition
p(_,_) --> [X], {lex(X,_,p,_)}.

%Verb
v(SemV,Kon) --> [X], {lex(X,SemV,v,Kon)}.

:- begin_tests('DCGCode').
%ergaenzungsfragen
test(s) :-
	s(onkel(wer,simone),ergaenzungsfrage,[wer,ist,der,onkel,von,simone],[]).

%entscheidungsfrage
test(s) :-
	s(onkel(karl,simone),entscheidungsfrage,[ist,karl,der,onkel,von,simone],[]).

test(s)	:-
	s(onkel(richard,phillip),entscheidungsfrage,[ist,richard,der,onkel,von,phillip],[]).

:- end_tests('DCGCode').




