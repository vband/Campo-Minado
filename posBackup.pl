/* carregando arquivo base */
:- ensure_loaded(mina).
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

imprimeLista([]).
imprimeLista([[X,Y]|L]) :-  imprimePosicao(X,Y),
                            imprimeLista(L).

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
/* concatenação para elementos unicos na lista*/
concUni(L,[],[L]).
concUni(X,[Y|L1],[Y|L1]):-
    X = Y,
    !.
concUni(X,[Y|L1],[Y|L2]):-
    X \= Y,
    concUni(X,L1,L2).

/* uniao de listas*/
uniaoListas(L,[],L).
uniaoListas([],L,L).
uniaoListas([X|L1], L2, Lfinal):-
  concUni(X,L2,L3),
  uniaoListas(L1,L3,Lfinal).





eVizinho([], L2).
eVizinho([[X, Y]|L1], [[X,Y]|L2]) :- not(member([X,Y], L2)), !, eVizinho(L1, L2).
eVizinho([[X,Y]|L1], L2) :- write('estou aqui'), member([X, Y], L2), !, eVizinho(L1, L2).

verificaVizinho([]).
verificaVizinho([[X, Y, Valor]|L]) :- write('estou aqui\n'), Valor > 0, !, imprimeJogo([[X, Y, Valor]]), verificaVizinho(L).
verificaVizinho([[X, Y, Valor]|L]) :- write('estou aqui\n'), Valor = 0, verificaVizinho(L).

/*verifica se a posicao testada nao esta definida em Posicao, no caso, se findall retorna []*/
verificaNull([]).

/*verifica se é uma casa de valor zero ( nenhuma mina em volta)*/
verificaZero([ [X,Y,Valor] ]) :-
    Valor = 0.

/*acha vizinho por vizinho*/
vizinhos([],[]).
    
/*Se as coordenadas nao estiverem definidas em Posicao(X,Y). Ex: out of bounds*/
vizinhos( [[X, Y]|L1], Imprime ) :-
    findall([X,Y, Valor], valor(X,Y, Valor), Posicao),
    verificaNull(Posicao),
    !,
    vizinhos(L1, Imprime).

/*se a posicao tiver 0 minas em volta, Imprime ela e busca suas vizinhas */
vizinhos( [[X, Y]|L1], [[X,Y]|Imprime]) :-
    findall([X,Y, Valor], valor(X,Y, Valor), Posicao),
    verificaZero(Posicao), 
    !,
    /* achar os seus vizinhos e empilha-los caso eles ainda nao tenham sido descobertos*/
    achaVizinhos(X,Y, L1, Imprime).
    /*vizinhos(L1, L2).*/
    
/*se a posicao tiver N minas em volta, so Imprime ela */
vizinhos( [[X, Y]|L1], [[X,Y]|Imprime] ) :-
    findall([X,Y, Valor], valor(X,Y, Valor), Posicao),
    \+(verificaZero(Posicao)),
    vizinhos(L1, Imprime).

/*procura os valores dos vizinhos*/
achaVizinhos(X, Y, PosicoesAbertas, PosicoesAbertasFinal) :-
  X1 is X-1,
  X2 is X+1,
  Y1 is Y-1,
  Y2 is Y+1,
  /* empilha os vizinhos caso eles nao tenham sido achados na busca ainda*/
  uniaoListas([[X1, Y1], [X1, Y], [X1, Y2], [X, Y1], [X, Y2], [X2, Y1], [X2,Y], [X2, Y2]], PosicoesAbertas, PosicoesUniao),
  /* percorrer os vizinhos que possam ser abertos*/
  vizinhos(PosicoesUniao, PosicoesAbertasFinal).



/*se a posicao for uma mina, dá-se jogo encerrado*/
jogoEncerrado([X, Y], []) :- imprimeJogada, imprimePosicao(X, Y), encerraJogo([]).
/*se a posicao tiver um valor diferente de zero, imprime-a com seu valor no arquivo jogo.pl*/
/*ordem: imprime o valor da jogada, imprime a posicao dada, imprime o ambiente e imprime o valor encontrado*/
jogoEncerrado([X, Y], [[X, Y, Valor]]) :- Valor > 0, !, imprimeJogada, imprimePosicao(X, Y),
                                          imprimeAmbiente, imprimeJogo([[X, Y, Valor]]).
/* se o valor na posicao for igual a zero, acha os seus vizinhos ainda nao procurados e imprime-os*/
/*ordem: imprime o valor da jogada, imprime a posicao dada, imprime o ambiente e imprime os vizinhos*/
jogoEncerrado([X, Y], [[X, Y, Valor]]) :- Valor = 0, imprimeJogada, imprimePosicao(X, Y),
                                          imprimeAmbiente, achaVizinhos(X, Y,[], Imprime), imprimeLista(imprime).

/*para a posicao (X,Y) dada, verifica se ela esta em ambiente.pl e retorna X,Y e o valor associado*/
testaPosicao(X, Y) :- findall([X,Y, Valor], valor(X,Y, Valor), Posicoes),
                      jogoEncerrado([X, Y], Posicoes).

/*chamada inicial */
posicao(X, Y) :- testaPosicao(X, Y).
