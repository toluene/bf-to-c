:- module(brainfuck, [brainfuck/3, codeGenerator/4, flatten/2]).

brainfuck([X | Y]) --> instruction(X), brainfuck(Y).
brainfuck([X]) --> instruction(X).
brainfuck([]) --> "[", [], "]".
brainfuck(Y) --> "[", [], "]", brainfuck(Y).
brainfuck([loop(X)]) --> "[", brainfuck(X), "]".
brainfuck([loop(X) | Y ]) --> "[", brainfuck(X), "]", brainfuck(Y).
%brainfuck(X) --> skipped, brainfuck(X).

%skipped([X|Y],Y) :- not(member(X,"+-><[].,")).

instruction(add(1)) --> "+".
instruction(sub(1)) --> "-".
instruction(lef(1)) --> "<".
instruction(rig(1)) --> ">".
instruction(put) --> ".".
instruction(get) --> ",".

indenter(0, []).
indenter(succ(X), [9 | Y]) :-
    indenter(X, Y).

indent(X, Y, Z) :-
    indenter(X, A),
    append(A, Y, Z).

flatten([add(A), add(B) | X], Y) :-
    Z is A + B,
    flatten([add(Z) | X], Y).
flatten([sub(A), sub(B) | X], Y) :-
    Z is A + B,
    flatten([sub(Z) | X], Y).
flatten([lef(A), lef(B) | X], Y) :-
    Z is A + B,
    flatten([lef(Z) | X], Y).
flatten([rig(A), rig(B) | X], Y) :-
    Z is A + B,
    flatten([rig(Z) | X], Y).
flatten([loop(A) | X], [loop(B) | Z]) :-
    flatten(A, B),
    flatten(X, Z).
flatten([X | Y], [X | Z]) :-
    flatten(Y, Z).
flatten([], []).

numbers(A, N, C) :-
    number_codes(N, Str),
    append(A, Str, B),
    append(B, ";\n", C).

codeGenerator(succ(I),[],Y,Z) :-
    indent(I, "}\n", G),
    append(Y, G, Z).
codeGenerator(I,[add(N) | X],Y,Z) :-
    indent(I, "t[i] += ", G),
    append(Y, G, A),
    numbers(A, N, Y1),
    codeGenerator(I, X, Y1, Z).
codeGenerator(I,[sub(N) | X],Y,Z) :-
    indent(I, "t[i] -= ", G),
    append(Y,G,A),
    numbers(A, N, Y1),
    codeGenerator(I, X, Y1, Z).
codeGenerator(I,[rig(N) | X],Y,Z) :-
    indent(I, "i += ", G),
    append(Y,G,A),
    numbers(A, N, Y1),
    codeGenerator(I, X, Y1, Z).
codeGenerator(I,[lef(N) | X],Y,Z) :-
    indent(I, "i -= ", G),
    append(Y,G,A),
    numbers(A, N, Y1),
    codeGenerator(I, X, Y1, Z).
codeGenerator(I,[put | X],Y,Z) :-
    indent(I, "putchar(t[i]);\n", G),
    append(Y,G,Y1),
    codeGenerator(I, X, Y1, Z).
codeGenerator(I,[get | X],Y,Z) :-
    indent(I, "t[i] = getchar();\n", G),
    append(Y,G,Y1),
    codeGenerator(I, X, Y1, Z).
codeGenerator(I,[loop(X) | C], Y, Z) :-
    indent(I, "while(t[i]) {\n", G),
    codeGenerator(succ(I), X, G, A),
    append(Y, A, B),
    codeGenerator(I, C, B, Z).
