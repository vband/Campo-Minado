/*tamanho do tabuleiro - sempre quadrado - no exemplo ele será 5x5*/
tabuleiro(5).

/*mina(linha,coluna): exista mina na posição (linha,coluna)*/
mina(2,1).
mina(2,3).
mina(4,5).

testa2([]).
testa(X,Y) :- findall([X,Y],mina(X,Y),Lista), testa2(Lista).