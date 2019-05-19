
member(X,[X|Tail]).
member(X,[Head|Tail]) :-
	member(X,Tail).

nthmember(1,[X|Next],X).
nthmember(N,[X|List],Nth):-
	N1 is N-1,
	nthmember(N1,List,Nth).

concat([],L,L).
concat([X|L1],L2,[X|L3]) :-
	concat(L1,L2,L3).
	
del(X,[X|Tail],Tail).
del(X,[Y|Tail],[Y|Tail1]) :-
	del(X,Tail,Tail1).

insert(X,List,BiggerList) :-
	del(X,BiggerList,List).

sublist(S,L) :-
	concat(L1,L2,L),
	concat(S,L3,L2).

permutation([],[]).
permutation([X|L],P) :-
	permutation(L,L1),
	insert(X,L1,P).

evenlength([]).
evenlength([X|Tail]) :-
	not(evenlength(Tail)).

oddlength(L) :-
	not(evenlength(L)).

reverse([],[]).
reverse([First|Rest],Reversed) :-
	reverse(Rest,ReversedRest),
	concat(ReversedRest,[First],Reversed).

palindrome(List) :-
	reverse(List,List).

shift([X|SubList],L2):-
	concat(SubList,[X],L2).

means(0,zero).
means(1,one).
means(2,two).
means(3,three).
means(4,four).
means(5,five).
means(6,six).
means(7,seven).
means(8,eight).
means(9,nine).

translate([],[]).
translate([X|L1],[Y|L2]):-
	means(X,Y),
	translate(L1,L2). 

subset([],[]).
subset([First|Rest],[First|Sub]):-
	subset(Rest,Sub).
subset([First|Rest],Sub):-
	subset(Rest,Sub).

dividelist([],[],[]).
dividelist([X],[X],[]).
dividelist([X,Y|List],[X|List1],[Y|List2]):-
	dividelist(List,List1,List2).

flatten([Head|Tail],FlatList):-
	flatten(Head,FlatHead),
	flatten(Tail,FlatTail),
	conc(FlatHead,FlatTail,FlatList).
flatten([],[]).
flatten(X,[X]).
