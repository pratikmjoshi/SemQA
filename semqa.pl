% set X is included in set Y
setr(X,Y):-
	add_val(subset,Y,3,[name,X]),
	add_val(superset,X,3,[name,Y]).

% query if an arbitrary element of set X is an element of set Y
setrq(X,X,yes).
setrq(X,Y,yes):-
	%exists(X),exists(Y),
	get_val(superset,X,3,[name,Z]),
	setrq(Z,Y,yes), !.
setrq(X,Y,sometimes):-
	setrq(Y,X,yes),!.
setrq(X,Y,insufficient).

% To specify that member X is part of set Y
setrs(X,Y):-
	add_val(member,X,3,[name,Y]),
	add_val(elements,Y,3,[name,X]).

% query if element X is a member of set Y
setrsq(X,Y,yes):-
	get_val(member,X,3,[name,Y]),!.
setrsq(X,Y,yes):-
	equivq(X,U,yes),
	add_elist(X),
	setrsq(U,Y,yes),!.
setrsq(X,Y,yes):-
	get_val(member,X,3,[name,Z]),
	setrq(Z,Y,yes),!.
setrsq(X,Y,insufficient).

% To specify that the unique element of set X also belongs to set Y
setrsl(X,Y):-
	specify(X,U,_),
	( ( U = nil),!;
	  ( setrs(U,Y) ) ).
% query whether unique element, if any, of set X, is a member of set Y
setrslq(X,Y,Answer):-
	specify(X,U,Val),
	((U = nil,Answer=Val),!;
	(refresh_elist(),setrsq(U,Y,Answer1),Answer=Answer1)),!.
	
% To specify in the model that every member of set Y owns some member of set X
ownr(X,Y):-
	add_val(possess_by_each,Y,3,[name,X]),
	add_val(owned_by_each,X,3,[name,Y]).

% query whether an arbitrary member of set Y owns some member of set X
ownrq(X,X,"No,they are same").
ownrq(X,Y,yes):-
	get_val(superset,Y,3,[name,U]),
	get_val(possess_by_each,U,3,[name,X]),!.
ownrq(X,Y,insufficient).

% To specify in the model that Y owns a member of set X
ownrgu(X,Y):-
	add_val(possess,Y,3,[name,X]),
	add_val(owned,X,3,[name,Y]).

% query whether Y owns a member of set X
ownrguq(X,Y,yes):-
	setrq(Z,X,yes),
	get_val(owned,Z,3,[name,Y]).
ownrguq(X,Y,yes):-
	get_val(member,Y,3,[name,Z]),
	setrq(Z,U,yes),
	get_val(owned_by_each,X,3,[name,U]).
ownrguq(X,Y,insufficient).

% query whether the unique element, if any, of set X is owned by some element of set Y
ownrsgq(X,Y,Answer):-
	specify(X,U,Val),
	( ( U=nil,Answer=Val),!;
	  ( get_val(owned,X,3,[name,W]),
	    ( get_val(member,W,3,[name,Z]),!;
	      equivq(W,W1,yes),
	      get_val(member,W1,3,[name,Z])),
	    setrq(Z,Y,yes),Answer = yes)).		
ownrsgq(X,Y,insufficient).

% To specify that every element of set X is part of some element in set Y
partr(X,Y):-
	add_val(subpart_of_each,Y,3,[name,X]),
	add_val(superpart_of_each,X,3,[name,Y]).

% query whether an arbitrary member of set X is a part of some member of set Y
partrq(X,X,"No, they are the same").
partrq(X,Y,yes):-
	get_val(superpart_of_each,X,3,[name,W]),
	setrq(Y,W,yes).
partrq(X,Y,yes):-
	get_val(superpart_of_each,X,3,[name,W]),
	partrq(W,Y,yes),!.
partrq(X,Y,sometimes):-
	get_val(superpart_of_each,X,3,[name,W]),
	setrq(Y,W,sometimes).
partrq(X,Y,sometimes):-
	get_val(superpart_of_each,X,3,[name,W]),
	partrq(W,Y,sometimes),!.
partrq(X,Y,Answer):-
	strprint(["No,",Y,"is part of",X],Answer),
	partrq(Y,X,yes),!.
partrq(X,Y,Answer):-
	strprint(["No,",Y,"is sometimes part of",X],Answer),
	partrq(Y,X,sometimes),!.

% To specify that some element of set X is a part of individual Y
partrgu(X,Y):-
	add_val(subpart,Y,3,[name,X]),
	add_val(superpart,X,3,[name,Y]).

% To specify that some element of set X is part of the unique element,if any, of set Y
partrgs(X,Y,Answer):-
	specify(Y,Z,Val),
	(( Z=nil,Answer=Val),!;
	( partrgu(X,Z))).

% query whether some element of set X is part of the individual Y
partrguq(X,Y,yes):-
	( ( get_val(subpart,Y,3,[name,W]);
	    equivq(Y,Y1,yes),
	    get_val(subpart,Y1,3,[name,W]) ),
	  setrq(W,X,yes) );
	( get_val(subpart,Y,3,[name,W]),
	  partrguq(W,Y,yes)).
partrguq(X,Y,yes):-
	get_val(superpart_of_each,X,3,[name,Z]),
	partrguq(Z,Y,yes).
partrguq(X,Y,yes):-
	( get_val(member,Y,3,[name,U]);
	  equivq(Y,Y1,yes),
	  get_val(subpart,Y1,3,[name,U]) ),
	( get_val(superpart_of_each,X,3,[name,V]),
	  setrq(U,V,yes);
	  get_val(superpart_of_each,X,3,[name,V]),
	  partrguq(V,Y,yes),!).
partrguq(X,Y,insufficient).

% To specify that the unique element, if any, of set X is part of the unique element, if any, of set Y
partrss(X,Y,Answer):-
	specify(X,U,Val1),
	specify(Y,V,Val2),
	( ( U=nil,Answer=Val1),!;
	  ( V=nil,Answer=Val2),!;
	  ( partrgu(X,V),
	    get_val(superpart,X,3,[name,Z]),
	    get_val(member,Z,3,[name,Y]),
	    add_val(elements,Z,3,[name,U]) ) ).

% query whether the unique element of set X is part of some element of set Y
partrsgq(X,Y,Answer):-
	specify(X,Z,Val),
	( (Z=nil,Answer=Val),!;
	  ( get_val(superpart,X,3,[name,W]),
	    ( ( ( get_val(member,W,3,[name,Y]);
	          equivq(W,W1,yes),
	          get_val(member,W1,3,[name,Y]) ), 
	      Answer=yes ),!;
	      ( ( get_val(member,W,3,[name,V]);
	          equivq(W,W1,yes),
	          get_val(member,W1,3,[name,V]) ),
	      ( setrq(Y,V,yes),!;
		( ( get_val(superpart_of_each,V,3,[name,Q]),!;
		    get_val(superpart_of_each,V,3,[name,Q]),
		    partrsgq(X,Q,yes) ),
		  setrq(Y,Q,yes) ),
	      Answer=yes ) ) ) ) ).
partrsgq(X,Y,insufficient).

% To specify that there are N elements of set X which are parts of every element of set Y
partrn(X,Y,N):-
	partr(X,Y),
	add_val(subpart_of_each,Y,1,[X,number,N]),
	add_val(superpart_of_each,X,1,[Y,number,N]).

% To specify that there are N elements of set X which are parts of individual Y
partrnu(X,Y,N):-
	partrgu(X,Y),
	add_val(subpart,Y,1,[X,number,N]),
	add_val(superpart,X,1,[Y,number,N]).

% query as to how many elements of set X are parts of the individual Y
partrnuq(X,Y,Alpha,Answer):-
	( ( get_val(subpart,Y,3,[name,W]);
	    equivq(Y,Y1,yes),
	    get_val(subpart,Y1,3,[name,W]) ),
	  setrq(W,X,yes) );
	( get_val(subpart,Y,3,[name,W]),
	  partrnuq(W,Y,Alpha,yes)),
	Answer=yes.
partrnuq(X,Y,Alpha,Answer):-
	get_val(superpart_of_each,X,3,[name,Z]),
	partrnuq(Z,Y,Alpha1,yes),
	( get_val(superpart_of_each,X,1,[Z,number,N]),
	  Alpha is Alpha1*N,Answer=yes,!;
	  strprint(["How many",X,"per",Z],Answer) ).
partrnuq(X,Y,Alpha,Answer):-
	( get_val(member,Y,3,[name,U]);
	  equivq(Y,Y1,yes),
	  get_val(subpart,Y1,3,[name,U]) ),
	( get_val(superpart_of_each,X,3,[name,V]),
	  setrq(U,V,yes),
	  get_val(superpart_of_each,X,1,[V,number,N]),
	  Alpha is N;
	  get_val(superpart_of_each,X,3,[name,V]),
	  partrnuq(V,Y,Alpha1,yes),!,
	  ( get_val(superpart_of_each,X,1,[V,number,N]),
	    Alpha is Alpha1*N,Answer=yes,!;
	    strprint(["How many",X,"per",Z],Answer) ) ).
partrnuq(X,Y,Alpha,Answer):-
	Alpha = 0,
	strprint(["I don't know whether",X,"is a part of",Y],Answer).

% To specify that unique element of set X is located just right of the unique element of set Y
jright(X,Y,Answer):-
	specify(X,U,Val1),specify(Y,V,Val2),
	( ( U=nil,Answer=Val1),!;
	  ( V=nil,Answer=Val2),!;
	  ( get_val(jright,Y,1,[name,X]),
	    Answer = "The above statement is already known"),!;
	  ( ( rightp(Y,X);
	      get_val(jright,Y,1,[name,Z]);
	      get_val(jleft,X,1,[name,Z]) ),
	     Answer = "The above statement is impossible"),!;
	  ( rightp(X,Y),
	    not(get_val(right,Y,2,[name,X])),
	    Answer = "The above statement is impossible"),!;
	  ( add_val(jright,Y,1,[name,X]),
	    add_val(jleft,X,1,[name,Y]),
	    Answer = true ) ).

% query whether it is known that the X is located to the right of Y
rightp(X,Y):-
	( get_val(jright,Y,1,[name,U]),
	  ( U=X;
	    rightp(X,U) ) ),!;
	( get_val(right,Y,2,[name,V]),
	  ( X=V;direct_connect_right(X,V);direct_connect_left(X,V);
	    rightp(X,V) ) ).

% Modification of paper for accurate rightp search
direct_connect_right(X,Y):-
	get_val(jright,X,1,[name,Y]);
	( get_val(jright,X,1,[name,Z]),
	  direct_connect_right(Z,Y),!).
direct_connect_left(X,Y):-
	get_val(jleft,X,1,[name,Y]);
	( get_val(jleft,X,1,[name,Z]),
	  direct_connect_left(Z,Y),!).
% To specify that the unique element of set X is located to the right of unique element of set Y
right(X,Y,Answer):-
	specify(X,U,Val1),specify(Y,V,Val2),
	( ( U=nil,Answer=Val1),!;
	  ( V=nil,Answer=Val2),!;
	  ( rightp(X,Y),
	    Answer = "The above statement is already known"),!;
	  ( rightp(Y,X),
	    Answer = "The above statement is impossible"),!;
	  ( add_val(right,Y,2,[name,X]),
	    add_val(left,X,2,[name,Y]),
	    Answer = true ) ).

% query whether the X is located just to the right of Y
jrightssq(X,Y,Answer):-
	specify(X,U,Val1),specify(Y,V,Val2),
	( ( U=nil,Answer=Val1),!;
	  ( V=nil,Answer=Val2),!;
	  ( get_val(jright,Y,1,[name,X]),
	    Answer = "Yes"),!;
	  ( ( rightp(Y,X);
	      get_val(jright,Y,1,[name,Z]);
	      get_val(jleft,X,1,[name,Z]) ),
	     Answer = "No"),!;
	  ( rightp(X,Y),
	    not(get_val(right,Y,2,[name,X])),
	    Answer = "No"),!;
	  ( Answer = "Insufficient Information" ) ).

% query whether the X is located to the right of Y
rightssq(X,Y,Answer):-
	specify(X,U,Val1),specify(Y,V,Val2),
	( ( U=nil,Answer=Val1),!;
	  ( V=nil,Answer=Val2),!;
	  ( rightp(X,Y),
	    Answer = "Yes"),!;
	  ( rightp(Y,X),
	    Answer = "No"),!;
	  ( Answer = "Insufficient Information" ) ).

% To determine the locations of those objects which have been positioned w.r.t. unique element of set X
wheres(X,Answer):-
	specify(X,Z,Val),
	( ( Z=nil,Answer=Val),!;
	  ( A1 = "",
	    get_val(jleft,X,1,U),
 	    ( not(len(U,0)) -> listprint([U],U1),strprint(["Just to the right of the",U1],A2); A2=A1 ),
	    get_val(jright,X,1,V),
	    ( not(len(V,0)) -> listprint([V],V1),strprint([A2,",","Just to the left of the",V1],A3); A3=A2 ),
	    get_all_val(left,X,2,L),
	    ( not(len(L,0)) -> listprint(L,L1),strprint([A3,",","Somewhere to the right of the following...",L1],A4);A4=A3),
	    get_all_val(right,X,2,M),
	    ( not(len(M,0)) -> listprint(M,M1),strprint([A4,",","Somewhere to the left of the following...", M1],A5);A5=A4 ),
	    ( A5="" -> Answer="No position is known" ; Answer=A5) ) ).

% To determine the locations of these objects which have been positioned w.r.t. some element of set X
whereg(X,Answer):-
	
	( pos_link(X) -> wheres(X,Answer);
			 ( (link(X,U,superpart_of_each,3),pos_link(U))-> wheres(U,Answer) );
			 ( (link(X,U,subset,3),pos_link(U))-> wheres(U,Answer) );
			 ( (link(X,U,superpart_of_each,3),link(U,W,subset,3),pos_link(W))-> wheres(W,Answer) );
			 ( Answer = "No relative position is known") ).

% To determine if X has at least one positional link
pos_link(X):-
	get_val(jright,X,1,A),get_val(jleft,X,1,B),get_val(right,X,2,C),get_val(left,X,2,D),
	not((A=[],B=[],C=[],D=[])).

%To get sequence of links following a certain attribute from X to U
link(X,Y,Attr,Type):-
	get_val(Attr,X,Type,[name,Y]);
	( get_val(Attr,X,Type,[name,Z]),
	  link(Z,Y,Attr,Type) ).
% To determine the location of the unique element of set X w.r.t. as many other objects as possible
locates(X,Answer):-
	specify(X,Z,Val),
	( ( Z=nil,Answer=Val),!;
	  ( m2_r(X,[X],Gout),m2_l(X,Gout,Gout1),del(X,Gout1,Gout1_1),
	    m3_loop([X|Gout1_1],[Gout1],Gout2,_),
	    pretty_print(X,Gout2,Answer) ) ).

% m2_r to generate jright in diagram
m2_r(X,Ginp,Gout):-
	get_val(jright,X,1,[name,U]),
	not(member_expand(U,Ginp)),
	m2_r(U,[Ginp|U],Gout1),!,
	Gout = Gout1.
m2_r(X,Ginp,Ginp).

% m2_l to generate jleft in diagram
m2_l(X,Ginp,Gout):-
	get_val(jleft,X,1,[name,U]),
	not(member_expand(U,Ginp)),
	m2_l(U,[U|Ginp],Gout1),!,
	Gout = Gout1.
m2_l(X,Ginp,Ginp).

% recursive call of m3
m3_loop([X|Tail],Ginp,Gout,E):-
	m3(X,Ginp,Gout1,E1),
	( E1=true ->
	  m3_loop(Tail,Gout1,Gout,E2),E=E2; E=false,Gout=Gout1).
m3_loop([],Ginp,Ginp,true).	
% m3 to generate right and left in diagram
m3(X,Ginp,Gout,E):-
	get_all_val(right,X,2,LL1),listnames(LL1,L1),
	m4_r(X,L1,Ginp,Gout1,E1), 
	(E1=false -> Gout=Gout1,E=E1;
		     ( get_all_val(left,X,2,LL2),listnames(LL2,L2),
		       m4_l(X,L2,Gout1,Gout2,E2),
		       ( E2=false -> Gout = Gout2,E=E2; 
				     Gout = Gout2,E=E2 ) ) ).
m3(X,Ginp,Ginp).
% m4_r to generate right in diagram
m4_r(X,[M|Tail],Ginp,Gout,E):-
	( not(member_expand(M,Ginp)) -> ( ( ( (member(V1,Ginp),V1=[_|V],rightp(V,X),not(link(X,V,jleft,1)),not(link(X,V,jright,1))) -> ( ( rightp(V,M) -> concat(Ginp,[[M]],Gout1),E1=true);
					 						  ( rightp(M,V) -> m4_r(V,[M],Ginp,Gout1,E2),E1=E2);
											  ( concat(Ginp,[[specify,M,V]],Gout),E1=false) ) );
					    ( m2_r(M,[M],Gout2_r),m2_l(M,Gout2_r,Gout2),concat(Ginp,[Gout2],Gout1) ) ) ),
					  ( E1=true -> (m4_r(X,Tail,Gout1,Gout3,E3),Gout=Gout3,E=E3);(E=E1)) ).
m4_r(X,_,Ginp,Ginp,true).
% m4_l to generate left in diagram
m4_l(X,[M|Tail],Ginp,Gout,E):-
	( not(member_expand(M,Ginp)) -> ( ( ( (member(V1,Ginp),V1=[V|_],rightp(X,V),not(link(X,V,jleft,1)),not(link(X,V,jright,1))) -> ( ( rightp(M,V) -> concat([[M]],Ginp,Gout1),E1=true);
											  ( rightp(V,M) -> m4_l(V,[M],Ginp,Gout1,E2),E1=E2);
											  ( concat(Ginp,[[specify,M,V]],Gout),E1=false) ) );
					    ( m2_r(M,[M],Gout2_r),m2_l(M,Gout2_r,Gout2),concat([Gout2],Ginp,Gout1) ) ) ),
					  ( E1=true -> (m4_l(X,Tail,Gout1,Gout3,E3),Gout=Gout3,E=E3);(E=E1)) ).
m4_l(X,_,Ginp,Ginp,true).
% To generate answer in string forms
pretty_print(X,Gout,Answer):-
	( Gout=[X] -> Answer = "No relative position is known" ;
		      ( concat(G,[[specify,M,V]],Gout) -> (pprint(G,A1),
						    strprint([A1,"To further specify the positions you must indicate where",M,"is with respect to",V],Answer) );
						    ( pprint(Gout,Answer) ) ) ).

pprint([L|Tail],Answer):-
	concat(['('],L,L1),concat(L1,[')'],L2),strprint(L2,Answer1),pprint(Tail,Answer2),strprint([Answer1,Answer2],Answer).
pprint([],'').

% concat function
concat([],L,L).
concat([X|L1],L2,[X|L3]) :-
	concat(L1,L2,L3).
% To find element in diagram for locates
member_expand(X,[L|Tail]):-
	member(X,L);
	member_expand(X,Tail).

% To determine the unique element, if any, of set X
specify(X,U,Y):-
	add_val(init,X,-1,[]),		
	attr(elements,X,3,Vals),!,
	len(Vals,N),
	((N=1 -> 
		Vals = [[_,U]],
		Y = U),!;
	(N>1 ->
		equiv_list(Vals,U)),!;
	concat([[which,which],[X,X],[":",":"]],Vals,Vals1),listprint(Vals1,Y),
		U = nil,!).
specify(X,U,Y):-
	create_object(X,0,U),
	setrs(U,X),
	strprint([U,' is a ',X],Y).

% To specify in the model that X and Y are equivalent
equiv(X,Y):-
	add_val(equivalent,X,2,[name,Y]),
	add_val(equivalent,Y,2,[name,X]).

% To specify in the model that X is equivalent to unique element of set Y
equivl(X,Y):-
	specify(Y,U,_),
	((U = nil);
	(equiv(X,U))).

% To check whether two elements are equivalent
equivq(X,Y,yes):-
	add_elist(X),
	get_val(equivalent,X,2,[name,Y]),
	elist(L),
	not(member(Y,L)).
equivq(X,Y,no).
	

% add value to database
add_val(Attr,Object,Type,Val):-
	retract(attr(Attr,Object,Type,Vals)),!, 
	add_unique(Val,Vals,Vals1),
	assert(attr(Attr,Object,Type,Vals1)).
add_val(Attr,Object,Type,Val):-
	add_unique(Val,[],Vals1),
	assert(attr(Attr,Object,Type,Vals1)).

% get value from database
get_val(Attr,Object,Type,Val):-
	attr(Attr,Object,Type,Vals), !,
	member(Val,Vals).
get_val(Attr,Object,Type,[]).

% get all values of certain object from database
get_all_val(Attr,Object,Type,Vals):-
	attr(Attr,Object,Type,Vals),!.
get_all_val(Attr,Object,Type,[]).

% to create an object in database
create_object(X,N,Y):-
	atom_concat(X,N,Y).

% to concatenate and print elements in a list
listprint([],'').
listprint([[_,X]|L],S):-
	listprint(L,S1),
	atom_concat(' ',S1,Y),
	atom_concat(X,Y,S).

% to get list of names
listnames([],[]).
listnames([[name,X]|Tail1],[X|Tail2]):-
	listnames(Tail1,Tail2).
% to print elements in a list, not a attribute list
strprint([],'').
strprint([X|L],S):-
	strprint(L,S1),
	atom_concat(' ',S1,Y),
	atom_concat(X,Y,S).

% to check if all elements in list X are equivalent to Y
equiv_list([[name,X]],X).
equiv_list([[name,X]|Tail],Y):-
	equiv_list(Tail,Y),!,
	equivq(X,Y,yes).

% Check if object exists in database
exists(X):-
	attr(_,X,_,_).

% Add element to list without duplication
add_unique(X,L,L):-
	member(X,L),!.
add_unique(X,L,[X|L]).

% length of list
len([],0).
len([X|Tail],N):-
	len(Tail,N1),
	N is 1+N1.

%Delete an element from the list
del(X,[X|Tail],Tail).
del(X,[Y|Tail],[Y|Tail1]) :-
	del(X,Tail,Tail1).

% member function
member(X,[X|Y]).
member(X,[_|Y]):- member(X,Y).

%Functions to manipulate elist
add_elist(X):-
	retract(elist(L1)),!,
	add_unique(X,L1,L2),
	assert(elist(L2)).
add_elist(X):-
	add_unique(X,[],L2),
	assert(elist(L2)).

refresh_elist():-
	retract(elist(_)),!,
	assert(elist([])).
refresh_elist():-
	assert(elist([])).
