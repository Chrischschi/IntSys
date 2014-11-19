
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
	i(_),
	vp(SemVP), %vormals SemVP 
	%hier vormlals pp(SemPP)
	{
	    SemVP = [NP_N,NP_PP],
	    % SemVP_NP = [SemVP_NP_N,[NP_N,NP_PP]],io:format(SemVP_NP_N),
	    SemS =.. [NP_N,_,NP_PP]
	}.
%entscheidungsfrage
s(SemS,entscheidungsfrage) -->
	vp(_SemVP), %_SemVP
	np(SemNP1), %SemE
	np(SemNP2), %SemNP, SemPP
	{
		SemNP2 = [SemNP2_N,SemNP2_PP],
	    SemS =.. [SemNP2_N,SemNP1,SemNP2_PP] %[SemNP,SemE,SemPP]
	}.


% "Eine Nominalphrase kann sein:"
% Eigenname
np(SemN) --> e(SemN).

% (Ergänzt) Interrogativpronomen
np(SemN) --> i(SemN).

% Artikel, Nomen
np(SemN) --> a(_,Genus),n(SemN,Genus).

% Artikel, Nomen, Präpositionalphrase
np([SemN,SemPP]) --> a(_,Genus),n(SemN,Genus),pp(SemPP).

% "Eine Präpositionalphrase kann sein:"
% Präposition,Nominalphrase
pp(SemPP) --> p(_),np(SemPP).

%Präposition,<Bestandteile einer Nominalphrase wie oben aufgeführt>
%Präposition,Eigenname
pp(SemPP) --> p(_),e(SemPP).
%Präposition,Interrogativpronomen
pp(SemPP) --> p(_),i(SemPP).
%Präposition,Artikel,Nomen
pp(SemPP) --> p(_),a(_,Genus),n(SemPP,Genus).
%Präposition,Artikel,Nomen
pp(SemPP) --> p(_),a(_,Genus),n(SemPP,Genus),pp(_).

%Eine Verbalphrase kann sein:
%Verb
vp([SemV,_]) --> v(SemV).

%Verb,Nominalphrase
vp(SemV) --> v(_),np(SemV).

%-------------------------------Terminale--------------------------------------
:- consult('lexikon.pl').

%Eigenname
e(SemE) --> [X], {lex(X,SemE,e)}.

%Interrogativpronomen(Ersetzt das Nomen bspw.: Wer,Was etc..)
i(SemI) --> [X], {lex(X,SemI,i,_,_)}.

%Artikel
a(_,Genus) --> [X], {lex(X,_,a,_,Genus)}.

%Nomen
n(SemN,Genus) --> [X], {lex(X,SemN,n,_,Genus)}.

%Präposition
p(_) --> [X], {lex(X,_,p,_,_)}.

%Verb
v(SemV) --> [X], {lex(X,SemV,v,_,_)}.

:- begin_tests('DCGCode').
%ergaenzungsfragen
test(s) :-
	s(onkel(_,simone),ergaenzungsfrage,[wer,ist,der,onkel,von,simone],[]).

test(s) :- 
    s(cousin(_,simone),ergaenzungsfrage,[wer,ist,der,cousin,von,simone],[]).

%entscheidungsfrage
test(s) :-
	s(onkel(karl,simone),entscheidungsfrage,[ist,karl,der,onkel,von,simone],[]).

test(s)	:-
	s(onkel(richard,phillip),entscheidungsfrage,[ist,richard,der,onkel,von,phillip],[]).
	
test(s) :- 
    s(cousin(michael,simone),entscheidungsfrage,[ist,michael,der,cousin,von,simone],[]).

:- end_tests('DCGCode').




