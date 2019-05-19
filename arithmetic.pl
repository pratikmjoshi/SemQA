gcd(X,X,X).
gcd(X,Y,D):-
	X<Y,
	Y1 is Y-X,
	gcd(X,Y1,D).
gcd(X,Y,D):-
	Y<X,
	gcd(Y,X,D).

len([],0).
len([_|List],N):-
	len(List,N1),
	N is 1+N1.

max(X,Y,Max):-
	X>Y,
	Max is X.
max(X,Y,Max):-
	X=<Y,
	Max is Y.

maxlist([],0).
maxlist([X|Next],Max):-
	maxlist(Next,Max1),
	max(X,Max1,Max).

sumlist([],0).
sumlist([X|Next],Sum):-
	sumlist(Next,Sum1),
	Sum is X+Sum1.

ordered([X]).
ordered([X,Y|Next]):-
	X=<Y,
	ordered([Y|Next]).

subset([],[]).
subset([First|Rest],[First|Sub]):-
	subset(Rest,Sub).
subset([First|Rest],Sub):-
	subset(Rest,Sub).

subsum(Set,Sum,Subset):-
	subset(Set,Subset),
	sumlist(Subset,Sum).

between(N1,N2,N1):-
	N1=<N2.
between(N1,N2,X):-
	N1<N2,
	NewN1 is N1+1,
	between(NewN1,N2,X).

:-op(900,fx,if).
:-op(800,xfx,then).
:-op(700,xfx,else).
:-op(600,xfx,:=).

if Val1>Val2 then Var:=Val3 else Var:=Val4 :-
	Val1 > Val2,
	Var is Val3.

if Val1>Val2 then Var:=Val3 else Var:=Val4 :-
	Val1 =< Val2,
	Var is Val4.

	
	







	
