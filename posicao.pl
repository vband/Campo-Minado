/* carregando arquivo base */
:- ensure_loaded(mina).
:- ensure_loaded(ambiente).

:- dynamic counter_jogo/1.
:- dynamic old_positions/1.


counter_jogo(1).
old_positions([[-1,-1]]).

/*verificando se uma posicao ja foi selecionada*/
incluiVizinho(X, Y, L) :- append(L, [[X,Y]], C), assertz(old_positions(C)).

testePosicao(X, Y, L) :- not(member([X, Y], L)), !, incluiVizinho(X, Y, L), true.
testePosicao(X, Y, L) :- member([X, Y], L), !,
                         assertz(old_positions(L)), false.
tryPos(X, Y) :- retract(old_positions(L)), testePosicao(X, Y, L).



/*imprime o valor da jogada*/
imprimeJogada :-retract(counter_jogo(C)), 
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

imprimePosAberta([X|_]) :- imprimeJogo([X]).

/*imprime a palavra Ambiente*/
imprimeAmbiente :-open("jogo.pl", append, ToWrite),
                  write(ToWrite, '/*AMBIENTE*/\n'), close(ToWrite).

/*caso o jogador tenha escolhi uma posicao com mina, o jogo eh encerrado*/
encerraJogo(X, Y, []) :- imprimeAmbiente, tryPos(X, Y), !,
                   open("jogo.pl", append, ToWrite),
                   write(ToWrite, 'Jogo encerrado\n\n'),
                   close(ToWrite).

/*caso contrario, imprime o valor encontrado naquela(s) posicao(oes)*/
imprimeJogo([]).
imprimeJogo([[X, Y, Valor]|L]) :- tryPos(X, Y), !,
                              open("jogo.pl", append, ToWrite), write(ToWrite, 'valor('),
                              write(ToWrite, X), write(ToWrite, ','), write(ToWrite, Y),
                              write(ToWrite, ','), write(ToWrite, Valor), write(ToWrite, ').\n'),
                              imprimeJogo(L), close(ToWrite).
imprimeJogo([[X, Y, Valor]|L]) :- imprimeJogo(L).

/*Func Auxiliares*/
/* concatenação para elementos unicos na lista*/
concUni(L,[],[L]).
concUni(X,[Y|L1],[Y|L1]):-
    X = Y,
    !.
concUni(X,[Y|L1],[Y|L2]):-
    X \= Y,
    concUni(X,L1,L2).

/* Une os novos vizinhos aos já percorridos */
novosVizinhos([],L,_,L).
/* se o vizinho não estiver nesta lista, e é adicionado*/
novosVizinhos([X|L1], L2, PosicoesFechadas, Lfinal):-
  notMember(X,PosicoesFechadas),
  !,
  concUni(X,L2,L3),
  novosVizinhos(L1,L3, PosicoesFechadas, Lfinal).
/* do contrário...*/
novosVizinhos([X|L1], L2, PosicoesFechadas, Lfinal):-
  member(X,PosicoesFechadas),
  novosVizinhos(L1, L2, PosicoesFechadas, Lfinal).

/* verificacao se X nao eh membro de uma lista */
notMember(X,[Y|[]]) :-
  X \= Y.
notMember(X,[Y|L]) :-
  X \= Y, notMember(X,L).

/*Fim Func Auxiliares*/


/*verifica se a posicao testada nao esta definida em Posicao, no caso, se findall retorna []*/
verificaNull([]).

/*verifica se é uma casa de valor zero ( nenhuma mina em volta)*/
verificaZero([ [_,_,Valor] ]) :-
    Valor = 0.


/*acha vizinho por vizinho*/
/*<<<<<<< HEAD */
vizinhos([],_).
    
/*Se as coordenadas nao estiverem definidas em Posicao(X,Y). Ex: out of bounds*/
vizinhos( [[X, Y]|L1], PosicoesFechadas ) :-
    findall([X,Y, Valor], valor(X,Y, Valor), Posicao),
    verificaNull(Posicao),
    !,
    /* marca a posicao como percorrida para evitar futuros vizinhos que cheguem nela, e assim gerar um loops*/
    vizinhos(L1, [[X,Y]|PosicoesFechadas]).

/*se a posicao tiver 0 minas em volta, Imprime ela e busca suas vizinhas */
vizinhos( [[X, Y]|L1], PosicoesFechadas) :-
    findall([X,Y, Valor], valor(X,Y, Valor), Posicao),
    verificaZero(Posicao), 
    !,
    /* achar os seus vizinhos e empilha-los caso eles ainda nao tenham sido descobertos*/
    imprimePosAberta(Posicao),
    achaVizinhos(X, Y, L1, [[X,Y]|PosicoesFechadas]).
    
/*se a posicao tiver N minas em volta, so Imprime ela */
vizinhos( [[X, Y]|L1], PosicoesFechadas ) :-
    findall([X,Y, Valor], valor(X,Y, Valor), Posicao),
    \+(verificaZero(Posicao)),
    imprimePosAberta(Posicao),
    vizinhos(L1, [[X,Y]|PosicoesFechadas]).
/*
=======

vizinhos([], L).
vizinhos([[X, Y]|L1], [Posicoes|L2]) :- findall([X,Y, Valor], valor(X,Y, Valor), Posicoes), !,
                                        /*verificaVizinho(Posicoes),*/
                                        imprimeJogo(Posicoes),
                                        vizinhos(L1, L2).
vizinhos([[X, Y]|L1], L2) :- tryPos(X, Y), !, vizinhos(L1, L2).
*/

/* >>>>>>> b8aef581f97e3016b3fa0722cb0cc49c71a64a3b*/


/*procura os valores dos vizinhos*/
achaVizinhos(X, Y, PosicoesAbertas, PosicoesFechadas) :-
  X1 is X-1,
  X2 is X+1,
  Y1 is Y-1,
  Y2 is Y+1,
  /* empilha os vizinhos caso eles nao tenham sido achados na busca ainda*/
  novosVizinhos([[X1, Y1], [X1, Y], [X1, Y2], [X, Y1], [X, Y2], [X2, Y1], [X2,Y], [X2, Y2]], PosicoesAbertas,PosicoesFechadas, PosicoesUniao),
  /* percorrer os vizinhos que possam ser abertos*/
  vizinhos(PosicoesUniao, PosicoesFechadas).



/*se a posicao for uma mina, dá-se jogo encerrado*/
jogoEncerrado([X, Y], []) :- imprimeJogada, imprimePosicao(X, Y), encerraJogo(X, Y, []).
/*se a posicao tiver um valor diferente de zero, imprime-a com seu valor no arquivo jogo.pl*/
/*ordem: imprime o valor da jogada, imprime a posicao dada, imprime o ambiente e imprime o valor encontrado*/
jogoEncerrado([X, Y], [[X, Y, Valor]]) :- Valor > 0, !,

                                          imprimeJogada, imprimePosicao(X, Y),
                                          imprimeAmbiente, imprimeJogo([[X, Y, Valor]]).
/* se o valor na posicao for igual a zero, acha os seus vizinhos ainda nao procurados e imprime-os*/
/*ordem: imprime o valor da jogada, imprime a posicao dada, imprime o ambiente e imprime os vizinhos*/
jogoEncerrado([X, Y], [[X, Y, Valor]]) :- Valor = 0, imprimeJogada, imprimePosicao(X, Y),
                                          imprimeAmbiente, achaVizinhos(X, Y, [], [[X,Y]]).

/*para a posicao (X,Y) dada, verifica se ela esta em ambiente.pl e retorna X,Y e o valor associado*/
testaPosicao(X, Y) :- findall([X,Y, Valor], valor(X,Y, Valor), Posicoes),
                      jogoEncerrado([X, Y], Posicoes).

/*chamada inicial */
posicao(X, Y) :- testaPosicao(X, Y).
