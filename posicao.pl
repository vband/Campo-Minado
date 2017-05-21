/* carregando arquivo base */
:- ensure_loaded(ambiente).

:- dynamic counter_jogo/1.

counter_jogo(1).

/*imprime o valor da jogada*/
imprimeJogada :-retract(counter_jogo(C)), write(C),
                          C > 1, !,
                          open("jogo.pl", append, ToWrite),
                          write(ToWrite, '/*JOGADA '), write(ToWrite, C), C1 is C+1, assertz(counter_jogo(C1)),
                          write(ToWrite, '*/\n'),  close(ToWrite).
imprimeJogada:- C is 1, !,
                open("jogo.pl", write, ToWrite),
                write(ToWrite, '/*JOGADA '), write(ToWrite, C), C1 is C+1, assertz(counter_jogo(C1)),
                write(ToWrite, '*/\n'),  close(ToWrite).

/*imprime a clausula posicao, dada uma posicao (X, Y)*/
imprimePosicao(X, Y) :- open("jogo.pl", append, ToWrite),
                        write(ToWrite, 'posicao('), write(ToWrite, X), write(ToWrite, ','),
                        write(ToWrite, Y), write(ToWrite, ').\n'), close(ToWrite).

/*imprime a palavra Ambiente*/
imprimeAmbiente :-open("jogo.pl", append, ToWrite),
                  write(ToWrite, '/*AMBIENTE*/\n'), close(ToWrite).

/*caso o jogador tenha escolhi uma posicao com mina, o jogo eh encerrado*/
encerraJogo([]) :- imprimeAmbiente,
                   open("jogo.pl", append, ToWrite),
                   write(ToWrite, 'Jogo encerrado\n\n'),
                   close(ToWrite).

/*caso contrario, imprime o valor encontrado naquela(s) posicao(oes)*/
imprimeJogo([]).
imprimeJogo([[X, Y, Valor]|L]) :- open("jogo.pl", append, ToWrite), write(ToWrite, 'valor('),
                              write(ToWrite, X), write(ToWrite, ','), write(ToWrite, Y),
                              write(ToWrite, ','), write(ToWrite, Valor), write(ToWrite, ').\n'),
                              imprimeJogo(L), close(ToWrite).

/*teste*/
eVizinho([], L2).
eVizinho([[X, Y]|L1], [[X,Y]|L2]) :- not(member([X,Y], L2)), !, eVizinho(L1, L2).
eVizinho([[X,Y]|L1], L2) :- write('estou aqui'), member([X, Y], L2), !, eVizinho(L1, L2).

verificaVizinho([]).
verificaVizinho([[X, Y, Valor]|L]) :- write('estou aqui\n'), Valor > 0, !, imprimeJogo([[X, Y, Valor]]), verificaVizinho(L).
verificaVizinho([[X, Y, Valor]|L]) :- write('estou aqui\n'), Valor = 0, verificaVizinho(L).


/*acha vizinho por vizinho*/
vizinhos([], L).
vizinhos([[X, Y]|L1], [Posicoes|L2]) :- findall([X,Y, Valor], valor(X,Y, Valor), Posicoes),
                                        /*verificaVizinho(Posicoes),*/
                                        imprimeJogo(Posicoes),
                                        vizinhos(L1, L2).



/*procura os valores dos vizinhos*/
achaVizinhos(X, Y) :- X1 is X-1, X2 is X+1, Y1 is Y-1, Y2 is Y+1,
                     vizinhos([[X1, Y1], [X1, Y], [X1, Y2], [X, Y1], [X, Y2], [X2, Y1], [X2, Y2]], Posicoes).



/*se a posicao for uma mina, dá-se jogo encerrado*/
jogoEncerrado([X, Y], []) :- imprimeJogada, imprimePosicao(X, Y), encerraJogo([]).
/*se a posicao tiver um valor diferente de zero, imprime-a com seu valor no arquivo jogo.pl*/
/*ordem: imprime o valor da jogada, imprime a posicao dada, imprime o ambiente e imprime o valor encontrado*/
jogoEncerrado([X, Y], [[X, Y, Valor]]) :- Valor > 0, !, imprimeJogada, imprimePosicao(X, Y),
                                          imprimeAmbiente, imprimeJogo([[X, Y, Valor]]).
/* se o valor na posicao for igual a zero, acha os seus vizinhos ainda nao procurados e imprime-os*/
/*ordem: imprime o valor da jogada, imprime a posicao dada, imprime o ambiente e imprime os vizinhos*/
jogoEncerrado([X, Y], [[X, Y, Valor]]) :- imprimeJogada, imprimePosicao(X, Y),
                                          imprimeAmbiente, achaVizinhos(X, Y).

/*para a posicao (X,Y) dada, verifica se ela esta em ambiente.pl e retorna X,Y e o valor associado*/
testaPosicao(X, Y) :- findall([X,Y, Valor], valor(X,Y, Valor), Posicoes),
                      jogoEncerrado([X, Y], Posicoes).

/*chamada inicial */
posicao(X, Y) :- testaPosicao(X, Y).
