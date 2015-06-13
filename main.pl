:- use_module(brainfuck).
:- use_module(library(readutil)).
:- initialization(main).

main :-
    read_stream_to_codes(current_input, F),
    strip(F, G),
    brainfuck(X,G,[]),
    flatten(X, A),
    getCode(A, Y, []),
    atom_codes(W, Y),
    write(W).

quiet.

strip([], []).
strip([X | Y],Z) :-
    not(member(X,"+-><[].,")),
    strip(Y, Z).
strip([X | Y], [X | Z]) :-
    strip(Y, Z).

getCode(X, Y, []) :-
    codeGenerator(succ(0), X,
    "#include <stdio.h>\n\nint main(void) {\n\tchar t[30000] = {0};\n\c
    \tregister unsigned short i = 0;\n", Y).
getCode(X, Y, Z) :-
    append("#include <stdio.h>\n\nint main(void) {\n\tchar t[", Z, A),
    append(A, "] = {0};\n\tunsigned short i = 0;\n", B),
    codeGenerator(succ(0), X, B, Y).
