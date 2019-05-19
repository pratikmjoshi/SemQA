final(s3).

trans(s1,a,s1).
trans(s1,a,s2).
trans(s1,b,s1).
trans(s2,b,s3).
trans(s3,a,s4).

silent(s2,s4).
silent(s3,s1).

accepts(State,[]):-
	final(State).
accepts(State,[X|Next]):-
	trans(State,X,Nextstate),
	accepts(Nextstate,Next).

accepts(State,String):-
	silent(State,Nextstate),
	accepts(Nextstate,String).
