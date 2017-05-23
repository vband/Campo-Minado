testa([[1,2],[2,3],[3,4],[4,5]]).

concUni(L,[],[L]).
concUni(X,[Y|L1],[Y|L1]):-
    X = Y,
    !.
concUni(X,[Y|L1],[Y|L2]):-
    X \= Y,
    concUni(X,L1,L2).

uniaoListas([],L,L).
uniaoListas([X|L1], L2, Lfinal):-
	concUni(X,L2,L3),
	uniaoListas(L1,L3,Lfinal).
