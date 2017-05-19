main:- open('mina.pl',read, Str),
       read_minas(Str, Minas), !,
       close(Str),
       write(Minas),  nl.

read_minas(Stream,[]):- at_end_of_stream(Stream).
read_minas(Stream,[X|L]):- read(Stream,X),
                            read_minas(Stream,L).
