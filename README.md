# Campo-Minado
Implementação de um campo minado em Prolog

1) 	Para preparar o ambiente de jogo, basta carregar em prolog o arquivo "criaAmbiente.pl" e exercutar "inicio"
		?- [criaAmbiente].
		?- inicio.
	O funcionamento do programa resume-se em:
		- Resgatar todas as minas em uma lista
		- Resgatar as dimensões do tabuleiro
		- Inicializar um tabuleiro com tais dimensões no formato valor(X,Y,0), se (X,Y) não definem uma mina.
		- Realizar uma busca, para cada mina em Minas, dos vizinhos e incrementar seu valor em valor(X,Y,Valor), tal que (X,Y) é um vizinho da mina.
			- A cada vizinho resgatado, busca-se tal coordenada no tabuleiro e incrementa-se o valor, sempre retornando um Novo Tabuleiro
		- Imprimir esse Novo tabuleiro em um arquivo "ambiente.pl".

2)  Para começar, carrega-se os arquivos "ambiente.pl" e "mina.pl" e executa-se posicao, dando coordenadas X e Y (posicao(X,Y)).
		?- ['posicao.pl'].
		?- posicao(X, Y).
	 O funcionamento dá-se da seguinte forma:
	  - Procura no arquivo ambiente.pl um valor que tenha coordenadas X e Y. Podem ocorrer 3 situaçoes:
	   1) Não haver valor com o dado X, Y. Nesse caso, imprime-se "Jogo encerrado" em jogo.pl
	   2) Pode haver um valor com o dado X, Y e esse valor ser maior que 0. Imprime-se o valor e o X, Y.
	   3) Pode haver um valor com o dado X, Y e esse valor ser igual a 0. Entao, procuram-se as casas vizinhas de (X,Y) os seus valores e imprime-os. Se houver alguma posicao com valor igual a zero, seus vizinhos também devem abrir. Se isto ocorrer, faz-se os seguintes procedimentos:
	    - Abrir Vizinhos em cadeia
 	    -A posicao verifica é guardada em uma lista de Posições abertas, para evitar loops ao verificar um vizinho e este, checar a posicao em questão novamente.
            -Se uma posicao aberta tem valor 0 ( 0 minas à sua volta), ela é impressa e, então, são buscados os seus vizinhos que são empilhados em uma lista de casas a serem verificadas.
            -Se a posicao aberta tem valor N != 0, ela é apenas registrada e impressa, e passa-se para a proxima posição empilhada sem olhar os respectivos vizinhos
             -Se ela não tem valor (quando findall retorna uma lista vazia), provavelmente é uma posicao de mina ou fora das dimensões, sendo entao registrada para não ser explorada novamente e passa-se para proxima.
	     
	     - Em todos os casos, é verificado se a posicao já foi usada em alguma jogada. Se ela foi, imprime-se em "jogo.pl" o valor da jogada e a posiçao.
