/* carregando arquivo base */
:- ensure_loaded(mina).



/*centro embaixo*/
vizinhosMinaCB(X,Y, [U, L]):-
	C is X+1, U is C, L is Y.
/*centro em cima*/
vizinhosMinaCU(X,Y, [U, L]):-
	C is X-1, U is C, L is Y.
/*esquerdo superior*/
vizinhosMinaUL(X,Y, [U, L]):-
	C is X-1, Z is Y-1, U is C, L is Z.
/*esquerdo inferior*/
vizinhosMinaBL(X,Y, [U, L]):-
	C is X+1, Z is Y-1, U is C, L is Z.
/*direito superior*/
vizinhosMinaUR(X,Y, [U, L]):-
	C is X-1, Z is Y+1, U is C, L is Z.
/*direito inferior*/
vizinhosMinaBR(X,Y, [U, L]):-
	C is X+1, Z is Y+1, U is C, L is Z.



preencheVizinhanca(ToWrite, [], TabulFim, TabulFim).
preencheVizinhanca(ToWrite, [[X,Y]|Minas],TabulInicio, TabulFim) :-
	/* coleta os vizinhos da mina */
	vizinhosMinaCB(X,Y, [U,L]),write(ToWrite,[U, L]),
	/* incrementa cada vizinho */
	/*incrementaMina(TabulInicio,MinViz,TabulFim),*/
	/* proxima mina */
	preencheVizinhanca(ToWrite, Minas, TabulFim, TabulFim).



iniciaTabuleiroColuna(ToWrite, TableSize, 1, 0, _).
/* Verifica se ainda pode andar sobre as colunas da linha*/
iniciaTabuleiroColuna(ToWrite, TableSize, X, Y, [0|Tabul]) :- Y > 0, X > 0, !,
																			 													Y2 is Y-1, iniciaTabuleiroColuna(ToWrite, TableSize, X, Y2, Tabul).
iniciaTabuleiroColuna(ToWrite, TableSize, X, Y, Tabul) :- X > 0, Y = 0, !, Y2 is TableSize,
																			 										X2 is X-1, iniciaTabuleiroColuna(ToWrite, TableSize, X2,Y2, Tabul).





preparaJogo(ToWrite):-
	/*find all minas em Minas*/
	tabuleiro(TableSize),
	findall([X,Y], mina(X,Y),Minas),write(ToWrite, Minas), Z is 5,
	/*preenche o tab de zeros a menos que seja mina - iniciaTabuleiro*/
	iniciaTabuleiroColuna(ToWrite, TableSize, Z, Z, Tabul),
	write(ToWrite, Tabul),
	/*preenche os vizinhos de cada mina (lista de vizinhos) - preencheVizinhança*/
	preencheVizinhanca(ToWrite, Minas,Tabul,TabulFim).
	/*escrita(TabulFim,ToWrite).*/


start(ToWrite):-
	open("ambiente.pl", write, ToWrite),
	preparaJogo(ToWrite),
	close(ToWrite).

