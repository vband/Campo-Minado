/* carregando arquivo base */
:- ensure_loaded(mina).


preparaJogo(ToWrite):-
	/*find all minas em Minas*/
	tabuleiro(TableSize),
	findall([X,Y], mina(X,Y),Minas),
	write(ToWrite, Minas),
	write(ToWrite, TableSize).
	/*find table size */
	/*preenche o tab de zeros a menos que seja mina - iniciaTabuleiro*/
	/*iniciaTabuleiro(Linhas,Colunas,Tabul),*/
	/*preenche os vizinhos de cada mina (lista de vizinhos) - preencheVizinhança*/
	/*preencheVizinhança(Minas,Tabul,TabulFim),
	escrita(TabulFim,ToWrite).*/


start(ToWrite):-
	open("ambiente.pl", write, ToWrite),
	preparaJogo(ToWrite),
	close(ToWrite).