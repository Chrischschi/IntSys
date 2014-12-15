ac3LA(CV) :-
	Q,%TODO Konsistenz-Prüfung für alle freien Variablen (für bereits instantiierte Variablen nicht nötig)
	Consistent,%true/false


revise((_,[]),_,[],_Delete).
revise((VarI,[HeadDomI|RestDomI]),(VarJ,DomJ),[HeadDomI|NewDomI],Delete) :-
	%bagof(SupportVar,(member(SupportVar,DomJ),constraint(HeadDomI,SupportVar)),_SupportingVars),!,
	exists(constraint,HeadDomI,DomJ), %schneller als mit bagof
	revise((VarI,RestDomI),(VarJ,DomJ),NewDomI,Delete).
revise((VarI,[_HeadDomI|RestDomI]),(VarJ,DomJ),NewDomI,Delete) :- 
	Delete = true,
	revise((VarI,RestDomI),(VarJ,DomJ),NewDomI,Delete).

constraint(A,B) :- A<B.

exists(Pred, Arg1, [Elem|_]) :-
	Pred =.. PL,
	append(PL, [Arg1,Elem], NewPred),
	Call =..NewPred,
	Call.
exists(Pred, Arg1, [_|Tail]) :-
	exists(Pred, Arg1, Tail).