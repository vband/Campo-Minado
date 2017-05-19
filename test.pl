/* carregando arquivo base */
:- ensure_loaded(q1).

doSome(X, L1, ToWrite, L2):-
	insOrd(X, L1, L2),
	write(ToWrite,"Lista ("),
	write(ToWrite, L2),
	write(ToWrite,")\n Fim").

start(X, L1, L2):-
	open("testeAmbiente.pl", write, makeToWrite),
	doSome(X, L1,ToWrite, L2),
	close(ToWrite).
