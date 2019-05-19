class(P,fighter):-
	beat(P,_),
	beat(_,P),!.
class(P,winner):-
	beat(P,_),!.
class(P,sportsman):-
	beat(_,P).

beat(tom,jim).
beat(ann,tom).
beat(pat,jim).

p(1).
p(2):-!.
p(3).

class(N,positive) :- N > 0,!.
class(0,zero):-!.
class(N,negative).

split([],[],[]).
split([X|Next],[X|Pnext],Negs):-
	X >= 0,!,
	split(Next,Pnext,Negs).
split([X|Next],Poss,[X|Nnext]):-
	split(Next,Poss,Nnext).
