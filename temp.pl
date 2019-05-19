% set X is included in set Y
setr(X,Y):-
	add_val(subset,Y,3,[name,X]),
	add_val(superset,X,3,[name,Y]).


% query if an arbitrary element of set X is an element of set Y
setrq(X,X,yes):- !.
setrq(X,Y,yes):- 
	get_val(superset,X,3,[[name,Y] | Z]),!,
	setrq(X,Z,yes), !.
setrq(X,Y,sometimes):- 
	setrq(Y,X,yes).
setrq(X,Y,insufficient).

add_val(Attr,Object,Type,Val):-
	retract(attr(Attr,Object,Type,Vals)), !,
	Vals1 = [Val|Vals],
	assert(attr(Attr,Object,Type,Vals1)).
add_val(Attr,Object,Type,Val):-
	Vals1 = [Val|Vals],
	assert(attr(Attr,Object,Type,Vals1)).


get_val(Attr,Object,Type,Val):-
	attr(Attr,Object,Type,Vals), !,
	member(Val,Vals).
get_val(Attr,Object,Type,[]).

len([],0).
len([_ |Tail],N):-
	len(Tail,N1),
	N is 1+N1.

member(X,[X|Y]).
member(X,[_|Y]):- member(X,Y).
