/* carregando arquivo base */
:- ensure_loaded(mina).


escreve([X,Y,Z|L], ToWrite):-
	L = [],
	write(ToWrite,X),
	write(ToWrite,","),
	write(ToWrite,Y),
	write(ToWrite,","),
	write(ToWrite,Z).

/* acho que da pra juntar as duas */
escrita([], ToWrite).
escrita([X|L], ToWrite):-
	write(ToWrite,"valor("),
	escreve(X, ToWrite),
	write(ToWrite,"). \n"),
	escrita(L, ToWrite).


/* se achei a coordenada no tabuleiro, */
/* preencho TabulFim */

atualiza([],_,_,[]).

atualiza([ [X,Y,Valor1] |TabulInicio],Xviz,Yviz,[ [X,Y,Valor2] |TabulFim]):-
	X = Xviz,
	Y = Yviz,
	!,
	Valor2 is Valor1 + 1,
	/* manter o restante da tabela*/
	atualiza(TabulInicio, Xviz, Yviz, TabulFim).

atualiza([ [X,Y,Valor1] |TabulInicio],Xviz,Yviz,[ [X,Y,Valor1] |TabulFim]):-
	/* verificar essa condicao */
	atualiza(TabulInicio, Xviz, Yviz, TabulFim).

incrementaMina(Tabul,[],Tabul).
incrementaMina(TabulInicio, [ [Xviz,Yviz] | MinViz], TabulFim2):-
	/* atualizo um vizinho */
	atualiza(TabulInicio,Xviz, Yviz, TabulFim1),
	/* passo para o proximo viznho*/
	incrementaMina(TabulFim1, MinViz, TabulFim2).
	/* e atualizo o tabuleiro ja iterado*/


preencheVizinhança([], Tabul, Tabul).
preencheVizinhança([ [X,Y] |Minas],TabulInicio, TabulFim2) :-
	/* coleta os vizinhos da mina */
	vizinhosMina([X,Y], MinViz),
	/* incrementa cada vizinho */
	incrementaMina(TabulInicio,MinViz,TabulFim),
	/* proxima mina */
	preencheVizinhança(Minas, TabulFim, TabulFim2).

/* */ 
/* Verifica se já chegou à ultima casa do tabuleiro */
iniciaTabuleiro(Linha, Coluna, X, Y, []) :-
	mina(X,Y),
	X = Linha,
	Y = Coluna,
	!.

/*  Verifica se chegou ao fim da Linha*/
iniciaTabuleiro(Linha,Coluna,X, Y, Tabul):-
	mina(X,Y),
	X =< Linha,
	Y = Coluna,
	!,
	X2 is X + 1,
	Y2 is 0,
	iniciaTabuleiro(Linha, Coluna, X2, Y2, Tabul).

/* Verifica se ainda pode andar sobre as colunas da linha*/
iniciaTabuleiro(Linha, Coluna, X, Y, Tabul) :-
	mina(X,Y),
	X =< Linha,
	Y < Coluna,
	!,
	Y2 is Y + 1,
	iniciaTabuleiro(Linha, Coluna, X, Y2, Tabul).

/* Verifica se já chegou à ultima casa do tabuleiro */
iniciaTabuleiro(Linha, Coluna, X, Y, [[X,Y,0]]) :-
	X = Linha,
	Y = Coluna,
	!.

/*  Verifica se chegou ao fim da Linha*/
iniciaTabuleiro(Linha,Coluna,X, Y, [[X, Y, 0]|Tabul]):-
	X =< Linha,
	Y = Coluna,
	!,
	X2 is X + 1,
	Y2 is 0,
	iniciaTabuleiro(Linha, Coluna, X2, Y2, Tabul).

/* Verifica se ainda pode andar sobre as colunas da linha*/
iniciaTabuleiro(Linha, Coluna, X, Y, [[X, Y, 0]|Tabul]) :-
	X =< Linha,
	Y < Coluna,
	!,
	Y2 is Y + 1,
	iniciaTabuleiro(Linha, Coluna, X, Y2, Tabul).


/* ul - UPPER LEFT, uc - UPPER CENTER, [...]*/
vizinhosMina([X,Y],[[X2,Y1],[X,Y1],[X1,Y1],[X1,Y], [X1,Y2],[X ,Y2] ,[X2,Y2] , [X2,Y] ] ):-
	X1 is X+1,
	X2 is X-1,
	Y1 is Y+1,
	Y2 is Y-1.


preparaJogo(ToWrite):-
	/*find all minas em Minas*/
	findall([X,Y], mina(X,Y),Minas),
	/* */
	tabuleiro(Dimensoes),
	/*preenche o tab de zeros a menos que seja mina - iniciaTabuleiro*/
	iniciaTabuleiro(Dimensoes,Dimensoes, 1, 1, Tabul),
	/*preenche os vizinhos de cada mina (lista de vizinhos) - preencheVizinhança*/
	preencheVizinhança(Minas,Tabul,TabulFim),
	/* */
	escrita(TabulFim,ToWrite).


start():-
	open("ambiente.pl", write, ToWrite),
	preparaJogo(ToWrite),
	close(ToWrite).
