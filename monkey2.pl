move(state(middle,onbox,middle,hasnot),
	grasp,
	state(middle,onbox,middle,has)).

move(state(X,onfloor,B,H),
	climb,
	state(X,onbox,B,H)).

move(state(P1,onfloor,P1,H),
	push(P1,P2),
	state(P2,onfloor,P2,H)).

move(state(P1,onfloor,B,H),
	walk(P1,P2),
	state(P2,onfloor,B,H)).


canget(state(_,_,_,has),[]).
canget(S1,[X|Next]) :-
	move(S1,X,S2),
	canget(S2,Next).
