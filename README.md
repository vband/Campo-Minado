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

2) 	