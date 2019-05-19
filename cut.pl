max(X,Y,X):- X>Y,!.
max(X,Y,Y).

% Now will only search for first occurrence
member(X,[X|L]):- !.
member(X,[Y|L]) :- member(X,L).

% Add element to list without duplication
add(X,L,L):-
	member(X,L),!.
add(X,L,[X|L]).


