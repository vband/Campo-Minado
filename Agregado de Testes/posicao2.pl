/* carregando arquivo base */
:- ensure_loaded(mina).
:- ensure_loaded(ambiente).

verificaJogada(X,N):-
	\+(jogada(X)),
	X1 is X+1,
	verificaJogada(X1,N).

verificaJogada(X,N):-
	jogada(X),
	N is X.

jogada(X):-
	open(historico,read,Stream,create([default])),
	close(Stream),
	verificaJogada(1,X).

	


posicao(N):-
	jogada(N).
	/*descobre(X,Y,descoberto),*/
	/*escreve(Stream,)*/
