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
move(g, j, 'a').
move(j, m, 'l'). #,
move(m, n, 'o').
move(n, o, 'm').
move(o, z, 'e').
move(h, k, 'u').
move(k, z, 'a').

% accepting state
accept('z').

% base case for when last char of string has been checked
% in the moves, and will check the current state against the
% accepted final state
consult_dic([], curr_state):-
    accept(curr_state).

% main consult dictionary function that will iterate through 
% the input string as a list and for each char, move to the 
% next appropriate state if curr char is valid
consult_dic([Char1|Rest], initial_state):-
    move(initial_state, new_state, Char1),
    consult_dic(Rest, new_state).