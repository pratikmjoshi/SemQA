% set X is included in set Y
setr(X,Y):-
	add_val(subset,Y,3,[name,X]),
	add_val(superset,X,3,[name,Y]).

% query if an arbitrary element of set X is an element of set Y
setrq(X,X,yes):- !.
setrq(X,Y,yes):- 
	get_val(superset,X,3,[name,Z]),
	setrq(X,Z,yes), !.
setrq(X,Y,sometimes):- 
	setrq(Y,X,yes).
setrq(X,Y,insufficient).
/*
% an element X is a member of a set Y
setrs(X,Y):-
	add_val(member,X,3,[name,Y]),
	add_val(elements,Y,3,[name,X]).

% query if an element X is a member of a set Y
setrsq(X,Y,yes):-
	get_val(member,X,3,[name,Y]), !.
setrsq(X,Y,yes):-
	get_val(member,X,3,[name,Z]),
	setrsq(Z,Y,yes), !.
setrsq(X,Y,yes):-
	equiv(X,U),
	setrsq(U,Y,yes), !.
setrsq(X,Y,insufficient).


% the unique element of set X (if any) is an element of set Y
setrsl(X,Y):-
	specify(X,U), !,
	setrs(U,Y).
setrsl(_,_).

% determine the unique element, if any, of set X
specify(X,Y):-
	get_val(elements,X,3,Vals),
	(Vals = [] ->
		create_object(U),
		setrs(U,X)
*/


add_val(Attr,Object,Type,Val):-
	retract(attr(Attr,Object,Type,Vals)), !,
	Vals1 = [Val|Vals],
	assert(attr(Attr,Object,Type,Vals)).
add_val(Attr,Object,Type,Val):-
	Vals1 = [Val|Vals],
	assert(attr(Attr,Object,Type,Vals1)).

get_val(Attr,Object,Type,Val):-
	attr(Attr,Object,Type,Vals), !,
	member(Val,Vals).
get_val(Attr,Object,Type,[]).


member(X,[X|Y]).
member(X,[_|Y]):- member(X,Y).

	
