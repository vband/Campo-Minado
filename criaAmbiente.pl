/* carregando arquivo base */
:- ensure_loaded(minas).

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
	escrita(L, ToWrite),
	write(ToWrite,"valor(")
	escreve(X, ToWrite)
	write(ToWrite,")"


/* se achei a coordenada no tabuleiro, */
/* preencho TabulFim */

atualiza([],_,_,[]).

atualiza([X,Y,Valor1|TabulInicio],Xviz,Yviz,[X,Y,Valor2|TabulFim):-
	X = Xviz,
	Y = Yviz,
	Valor2 is Valor1 + 1.
	atualiza(TabulInicio, Xviz, Yviz, TabulFim) /* manter o restante da tabela/

atualiza([X,Y,Valor1|TabulInicio],Xviz,Yviz,[X,Y,Valor1|TabulFim):-
	/* verificar essa condicao */
	atualiza(TabulInicio, Xviz, Yviz, TabulFim).


incrementaMina(TabulInicio, [Xviz,Yviz|MinViz], TabulFim2):-
	/* atualizo um vizinho */
	atualiza(TabulInicio,Xviz,Yviz, TabulFim1)
	/* passo para o proximo viznho*/
	incrementaMina(TabulFim1, Xviz, Yviz, TabulFim2)
														/* e atualizo o tabuleiro ja iterado*/

preencheVizinhança([], TabulFim, TabulFim).

preencheVizinhança([X,Y|Minas],TabulInicio, TabulFim) :-
	/* coleta os vizinhos da mina */
	vizinhosMina([X,Y], MinViz),
	/* incrementa cada vizinho */
	incrementaMina(TabulInicio,MinViz,TabulFim),
	/* proxima mina */
	preencheVizinhança(Minas, TabulFim, TabulFim),


/* verificar as dimensões
iniciaTabuleiro() :-


vizinhosMina([X,Y], [UL,UC,UR,CR,LR,LC,LL,CL]):- /* ul - UPPER LEFT, uc - UPPER CENTER, [...]*/
	X1 is X+1,
	X2 is X-1,
	Y1 is Y+1,
	Y2 is Y-1,
	UL is [X2,Y1],
	UC is [X ,Y1],
	UR is [X1,Y1],
	CR is [X1,Y],
	LR is [X1,Y2],
	LC is [X ,Y2],
	LL is [X2,Y2],
	CL is [X2,Y].


preparaJogo(ToWrite):-
	/*find all minas em Minas*/
	findAll([X,Y], minas(X,Y),Minas),
	/*preenche o tab de zeros a menos que seja mina - iniciaTabuleiro*/
	iniciaTabuleiro(Linhas,Colunas,Tabul)
	/*preenche os vizinhos de cada mina (lista de vizinhos) - preencheVizinhança*/
	preencheVizinhança(Minas,Tabul,TabulFim)
	escrita(TabulFim,ToWrite)


start():-
	open("ambiente.pl", write, makeToWrite),
	preparaJogo(ToWrite),
	close(ToWrite).
