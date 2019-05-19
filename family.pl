husband(X):-
	family(X,_,_).

wife(X):-
	family(_,X,_).

child(X):-
	family(_,_,Children),
	member(X,Children).

member(X,[X|Tail]).
member(X,[Head|Tail]) :-
	member(X,Tail).

exists(Person):-
	husband(Person);
	wife(Person);
	child(Person).

dateofbirth(person(_,_,Date,_),Date).
salary(person(_,_,_,works(_,S)),S).
salary(person(_,_,_,unemployed),0).

total([],0).
total([Person|List],Sum):-
	salary(Person,S),
	total(List,Rest),
	Sum is S + Rest.

twins(Child1,Child2):-
	family(_,_,Children),
	member(Child1,Children),
	member(Child2,Children),
	dateofbirth(Child1,D1),
	dateofbirth(Child2,D2),
	D1 = D2.

% Selectors
husband(family(Husband,_,_),Husband).
wife(family(Wife,_,_),Wife).
children(family(_,_,Children),Children).

nthmember(1,[X|Next],X).
nthmember(N,[X|List],Nth):-
	N1 is N-1,
	nthmember(N1,List,Nth).
	

nthchild(N,Family,Nth):-
	children(Family,Children),
	nthmember(N,Children,Nth).

firstname(person(Name,_,_),Name).
surname(person(_,Name,_),Name).
born(person(_,_,Dob),Dob).
