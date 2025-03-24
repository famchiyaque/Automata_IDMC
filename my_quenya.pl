% Knowledge Base (from, to, with)
move(a, b, 'A').
move(b, c, 'i').
move(b, d, 'l').
move(c, e, 'g').
move(c, f, 'n').
move(d, g, 'd').
move(d, h, 'q').
move(e, i, 'l').
move(i, l, 'o').
move(l, z, 's').
move(f, z, 'u').
move(g, z, 'a').  % 'a' goes to z from g if it's the last letter
move(g, j, 'a').  % 'a' goes to j from g if it's not the last letter
move(j, m, 'l').
move(m, n, 'ó').
move(n, o, 'm').
move(o, z, 'ë').
move(h, k, 'u').
move(k, z, 'a').

% Accepting state
accept(z).

% Fix misread characters (like 'Ã³' should be 'ó')
fix_char('Ã³', 'ó').  % Handle the misread ó (showing as Ã³)
fix_char(C, C).  % If the character is not 'Ã³', leave it unchanged.

% Base case: If empty list and reached final state, accept.
consult_dic([], CurrState) :-
    accept(CurrState), !.

% Allow words to end early at 'z'
consult_dic([], CurrState) :-
    move(CurrState, z, ''),
    accept(z), !.

% Recursive case: Process each character step-by-step
consult_dic([Char1 | Rest], CurrState) :-
    % Check if the current character is 'a' and we are in state g
    (CurrState = g, Char1 = 'a' ->
        % Check if 'a' is the last character in the word
        (Rest = [] -> 
            move(g, z, 'a');  % If 'a' is the last character, go to 'z'
            move(g, j, 'a')   % Else, go to 'j'
        )
    ;
        move(CurrState, NewState, Char1)  % Regular transition for other characters
    ),
    consult_dic(Rest, NewState).


% Testing setup (you can provide lists of valid and invalid words)
run_tests :-
    valid_words(VWords),
    invalid_words(IWords),

    writeln('Running tests for valid words...'),
    forall(member(W, VWords), (
        (consult_dic(W, a) -> 
            format('PASSED: ~w is accepted.\n', [W]) 
        ; 
            format('FAILED: ~w was not a complete valid word.\n', [W])
        )
    )),

    writeln('Running tests for invalid words...'),
    forall(member(W, IWords), (
        (consult_dic(W, a) -> 
            format('FAILED: ~w should be rejected.\n', [W]) 
        ; 
            format('PASSED: ~w is rejected.\n', [W])
        )
    )).

% Example words for testing
valid_words(['Aiglos', 'Ainu', 'Alda', 'Aldalómë', 'Alqua']).
invalid_words(['Ai', 'Aq']).
