/* q11 unificavel() */
unificavel([],_,[]).
unificavel([X|L],Y,Lt) :-
	\+(X = Y),
	!,
	unificavel(L,Y,Lt).
unificavel([X|L],Y,[X|Lt]) :-
	unificavel(L,Y,Lt).


/* q10 isOrd(L) */
isOrd([_]).
isOrd([X|[Y|L]]) :- X =< Y, isOrd([Y|L]).

/* q9 shallNot(L, Saida) */
shallNot([],[]).
shallNot([X|L],[X|Lt]) :-
	notMember(X,L), shallNot(L,Lt).
shallNot([X|L],Lt) :-
	member(X,L), shallNot(L,Lt).
/* q8 */
intersec(_,[],[]).
intersec([],_,[]).
intersec([X|L],L2,[X|Lt]) :-
	member(X,L2), intersec(L,L2,Lt).
intersec([X|L],L2,Lt)  :-
	notMember(X,L2), intersec(L,L2,Lt).

/* q7 */
uni(L,[],L).
uni([],L,L).
uni([X|L],L2,[X|Lt]) :-
	notMember(X,L2), uni(L,L2,Lt).
uni([X|L],L2,Lt)  :-
	member(X,L2), uni(L,L2,Lt).

/* q6 */
except([],_,[]).
except(L,[],L). :- !.
except([X|L1],L2,[X|Lt]):-
	notMember(X,L2),
	except(L1,L2,Lt),
	!.
except([X|L1],L2,Lt):-
	member(X,L2),
	except(L1,L2,Lt).

/* q5 uniOrd(L1,L2,L3) */
uniOrd(L,[],L).
uniOrd([],L,L).
uniOrd([X|L1],[Y|L2], L3) :-
	X=Y,
	uniOrd(L1,L2,L3).
uniOrd([X|L1],[Y|L2], [X|L3]) :-
	X<Y,
	uniOrd(L1,[Y|L2],L3).
uniOrd([X|L1],[Y|L2], [Y|L3]) :-
	X>Y,
	uniOrd([X|L1],L2,L3).

/* q4 insOrd(X,L,L1) */
insOrd(X,[],[X]).
insOrd(X,[Y|L],[X,Y|L]) :- X < Y.
insOrd(X,[Y|L],[X|L]) :- X = Y.
insOrd(X,[Y|L],[Y|Lt]) :- X>Y, insOrd(X,L,Lt).

/* q3 mult(N, Saida) */
mult(N,X) :- T is 0, multiples(N,T,X).
multiples(N,T,T) :- T =< N.
multiples(N,T,X) :- T =< N, !, T1 is T + 3, multiples(N,T1,X).

/* q2 fib(N, Saida) */
fib(1,1).
fib(2,1).
fib(N,Z) :-
	N > 1,
	N1 is N - 2,
	fib(N1,X),
	N2 is N - 1,
	fib(N2,Y),
	Z is X + Y.

/* q1 inBetween(A, B, L1, Saida])*/
inBetween(_, _, [],[]).
inBetween(A, B, [X|Li], [X|Lf]) :-
	X >= A,
	X =< B,
	inBetween(A, B, Li, Lf).

/* aux  unctions */
member(X,[X|_]).
member(X,[_|L]) :- member(X,L).

/*notMember(X,L) :- \+(member(X,L)).*/
notMember(X,[Y|[]]) :-
	X \= Y.
notMember(X,[Y|L]) :-
	X \= Y, notMember(X,L).
