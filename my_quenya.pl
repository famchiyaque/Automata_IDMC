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
move(m, n, 'acc_o').
move(n, o, 'm').
move(o, z, 'ë').
move(h, k, 'u').
move(k, z, 'a').
% move(z, x, _). % if already at z, any character moves to rejected state x

% Accepting state
accept(z).

% Fix misread characters (like 'Ã³' should be 'ó')
fix_char('ó', 'acc_o').  % Handle the misread ó (showing as Ã³)
fix_char(C, C).  % If the character is not 'Ã³', leave it unchanged.

% Base case: If empty list and reached final state, accept.
consult([], CurrState) :-
    accept(CurrState), !.

% Recursive case: Process each character step-by-step
consult([CurrChar | Rest], CurrState) :-
    fix_char(CurrChar, FixedChar),
    (FixedChar = 'a', CurrState = g -> 
        (Rest = [] ->
            NewState = z;    % if rest is empty, then 'Alda' is moved directly to z state
            NewState = j     % else, continue with extra letters after 'Alda'
        );
        move(CurrState, NewState, FixedChar)
    ),
    consult(Rest, NewState).

% Example words for testing
valid_words([['A', 'i', 'g', 'l', 'o', 's'], ['A', 'i', 'n', 'u'], ['A', 'l', 'd', 'a'], ['A', 'l', 'd', 'a', 'l', 'ó', 'm', 'ë'], ['A', 'l', 'q', 'u', 'a']]).
invalid_words(['Ai', 'Aq', 'Aldalome', 'Aldad', 'aiglos', 'Aldo']).


% Testing setup (you can provide lists of valid and invalid words)
run_tests :-
    valid_words(VWords),
    invalid_words(IWords),

    writeln('Running tests for valid words...'),
    forall(member(W, VWords), (
        (consult(W, a) -> 
            format('PASSED: ~w is accepted.\n', [W]) 
        ; 
            format('FAILED: ~w was not a complete valid word.\n', [W])
        )
    )),

    writeln('Running tests for invalid words...'),
    forall(member(W, IWords), (
        (consult(W, a) -> 
            format('FAILED: ~w should have been rejected.\n', [W]) 
        ; 
            format('PASSED: ~w is rejected.\n', [W])
        )
    )).

