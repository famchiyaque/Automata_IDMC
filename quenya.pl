% Create the knowledge base with states and characters
move(a, b, t). 
move(b, c, h).
move(b, h, e).
move(b, l, i).
move(b, o, u).
move(c, d, a).
move(d, e, l).
move(e, f, i).
move(f, g, a).
move(f, z, n).
move(g, z, s).
move(h, i, n).
move(i, j, g).
move(j, k, w).
move(k, z, a).
move(l, m, n).
move(m, n, c).
move(n, z, o).
move(o, p, i).
move(p, q, l).
move(q, z, 3).

% Accepting state
accepting_state(z).

go_over_automaton(ListtoCheck) :-
    % Call the other function, with the first state in the automaton which is A
    automatonCheck(ListtoCheck, a).

% Base case where the entire list has been seen. Check if it is an accepted state
automatonCheck([], InitialState) :-
    accepting_state(InitialState).

% If the list still has elements to go through
automatonCheck([Symbol | RestofList], InitialState) :-
    % Check if the Initial state and the symbol are connected in knowledge base
    move(InitialState, NextState, Symbol),
    % If they are then call the function again until base case
    automatonCheck(RestofList, NextState).

tengwa:-
    write('tengwa'), nl,
    write('Expected: true'), nl,
    go_over_automaton([t, e, n, g, w, a]).

tengwe:-
    write('tengwe'), nl,
    write('Expected: false'), nl,
    go_over_automaton([t, e, n, g, w, e]).

hello:-
    write('hello'), nl,
    write('Expected: false'), nl,
    go_over_automaton([h, e, l, l, o]).

tinco:-
    write('tinco'), nl,
    write('Expected: true'), nl,
    go_over_automaton([t, i, n, c, o]).

thalin:-
    write('thalin'), nl,
    write('Expected: true'), nl,
    go_over_automaton([t, h, a, l, i, n]).

thalias:-
    write('thalias'), nl,
    write('Expected: true'), nl,
    go_over_automaton([t, h, a, l, i, a, s]).

thalian:-
    write('thalian'), nl,
    write('Expected: false'), nl,
    go_over_automaton([t, h, a, l, i, a, n]).

tuil3:-
    write('tuil3'), nl,
    write('Expected: true'), nl,
    go_over_automaton([t, u, i, l, 3]).

tuile:-
    write('tuile'), nl,
    write('Expected: false'), nl,
    go_over_automaton([t, u, i, l, e]).

thale:-
    write('thale'), nl,
    write('Expected: false'), nl,
    go_over_automaton([t, h, a, l, e]).