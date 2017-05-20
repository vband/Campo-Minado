/* carregando arquivo base */
:- ensure_loaded(ambiente).

chamaJogo(Posicoes) :- open("jogo.pl", write, ToWrite), write(ToWrite, 'Jogo encerrado'), close(ToWrite).
chamaJogoDois(X, Y, Valor) :- open("jogo.pl", write, ToWrite), write(ToWrite, 'valor('),
                              write(ToWrite, X), write(ToWrite, ','), write(ToWrite, Y),
                              write(ToWrite, ','), write(ToWrite, Valor), write(ToWrite, ').\n'),close(ToWrite).
chamaJogoTres([[X, Y, Valor]|_]) :- open("jogo.pl", write, ToWrite), write(ToWrite, 'valor('),
                              write(ToWrite, X), write(ToWrite, ','), write(ToWrite, Y),
                              write(ToWrite, ','), write(ToWrite, Valor), write(ToWrite, ').\n'),close(ToWrite).

vizinhos([], L).
vizinhos([[X, Y]|L1], [Posicoes|L2]) :- findall([X,Y, Valor], valor(X,Y, Valor), Posicoes),
                                          vizinhos(L1, L2).
achaVizinho(X, Y) :- X1 is X-1, X2 is X+1, Y1 is Y-1, Y2 is Y+2,
                      vizinhos([[X1, Y1], [X1, Y], [X1, Y2], [X, Y1], [X, Y2], [X2, Y1], [X2, Y2]], Posicoes).

achaVizinhos(X, Y) :- X1 is X-1, findall([X1,Y, Valor], valor(X1,Y, Valor), Posicoes), chamaJogoTres(Posicoes),
                      Y1 is Y+1.

jogoEncerrado([]) :- chamaJogo([]).
jogoEncerrado([[X, Y, Valor]|_]) :- Valor > 0, !, chamaJogoDois(X, Y, Valor).
jogoEncerrado([[X, Y, Valor]|_]) :- achaVizinho(X, Y).

testaPosicao(X, Y) :- findall([X,Y, Valor], valor(X,Y, Valor), Posicoes),
                      jogoEncerrado(Posicoes).


posicao(X, Y) :- testaPosicao(X, Y).
