# Implementation of Lexical Analysis

## Overview

This project offers two approaches to validate a small dictionary of Elvish-inspired words, which in this case is supposed to simulate a very simple lexical analysis, like those used by real programming languages during compilation.

Dictionary:
    - Aiglos
    - Ainu
    - Alda
    - Aldalómë
    - Alqua

Coursera says that Lexical analysis, or scanning, is a part of natural language processing (NLP) where the source code is read character by character to produce tokens for the next stage of compilation, and while the program is at it, verifies the grammar of the code, including syntax and spelling.

According to the same source, there are two primary methods for this process:
the <b>Loop and Switch</b> method, and the <b>Regular Expressions and Finite
Automata</b> method.
[Coursera on Lexical Analysis](https://www.coursera.org/articles/lexical-analysis)

For this project, we will be implementing the second of the primary types, meaning both the Automata and Regular Expressions.

### 1. Finite Automata in Prolog

#### Theory

An Automata are versions of finite state machines, or mechanisms to track 
and map the state of something as input is handled. 
In this case, we want to track and map the state of word validity as we read the given input, a word, character by character to determine whether it is a valid word of our dictionary.
This image below shows the different states and transitions used to track the word as its characters are read one by one.
![Automata Img](automata_img.drawio.png)

It's important to note here that this automata is a **Nondeterministic Finite Automata** (NFA), which according to Unstop.com, means that the automata may allow for multiple possible state transitions from one state to another with the same input.
- [Unstop on DFA vs NFA](https://unstop.com/blog/difference-between-dfa-and-nfa)

This is because there is a single case in our small dictionary where the word 'Alda' should move from the *g* state to the final accepted *z* state, meanwhile the word 'Aldalómë', having the exact same first four letters, will also be in the *g* state, but will need to continue on to another, non-final state for 
continued validation.

This is why a **Deterministic Finite Automata (DFA) cannot be used here**, which only allows for a single possible transition path between states with the same input.

#### The Code
Written in Prolog, the logic based and efficient, although less intuitive, progamming language, the automata can be implemented just by declaring the rules of the automata transitions, defining the accepted state, and recursively calling the same function which traverses the given word and uses the transitions to track the state.
<!-- 1. **Prolog Dictionary**: A logic-based implementation using finite state automata to a set of words given from a small sample of Elvish Lord of the Rings words through explicit state transitions.
2. **Python Regex Validator**: A pattern-matching implementation using regular expressions to validate words against predefined patterns.

Both implementations serve the same purpose but showcase different programming paradigms and validation techniques. -->

1. **Knowledge Base**:
   ```prolog
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
   ```
   This knowledge base defines all possible state transitions as facts in the form `move(FromState, ToState, Character)`, just like how they appear in the image of the automata above.

2. **Accepting State**:
   ```prolog
   accept(z).
   ```
   Defines that state 'z' is the only accepting state, meaning any word that correctly reaches this state is valid, and any word that does not is invalid.

3. **Character Encoding Fix**:
   ```prolog
   fix_char('Ã³', 'ó').
   fix_char(C, C).
   ```
   Handles potential character encoding issues, particularly with special characters.

4. **Word Processing Logic**:
   ```prolog
   % Base case - empty word at accepting state
   consult_dic([], CurrState) :-
       accept(CurrState), !.
   
   % Recursive case: Process each character step-by-step
    consult([CurrChar | Rest], CurrState) :-
        fix_char(CurrChar, FixedChar),
        (FixedChar = 'a', CurrState = g -> 
            (Rest = [] ->
                move(g, z, 'a'), % if rest is empty, then 'Alda' is moved directly to z state
                NewState = z;    % set NewState to z
                move(g, j, 'a'), % else, continue with extra letters after 'Alda'
                NewState = j     % set NewState to j
            );
            # writeln([CurrState, FixedChar]),
            move(CurrState, NewState, FixedChar)
        ),
        consult(Rest, NewState).
   ```
   The core logic recursively processes each character and transitions between states, with special handling for context-sensitive cases.

5. **Added Logic for NFA funcionality**
    ```prolog
    (FixedChar = 'a', CurrState = g -> 
            (Rest = [] ->
                NewState = z;    % set NewState to z
                NewState = j     % set NewState to j
            );
            # writeln([CurrState, FixedChar]),
            move(CurrState, NewState, FixedChar)
        ),
        ```

        this part of the main 'consult' rule uses if/else logic to check that in the case where the current character is 'a' and the current state *g*, if the rest of the list is empty in that moment (for the case of the word 'Alda'), then the state is manually moved to *z*, and if there are more letters to check, then moved to *j*.

#### How to Use
Run the Prolog file using a Prolog interpreter such as SWI-Prolog:

```bash
swipl my_quenya.pl

To test a set of predefined valid and non-valid words

?- run_tests.

To test individual words in an interactive session:

```prolog
?- consult(['A','i','g','l','o','s'], a).
true.

?- consult(['B','l','a'], a).
false.
```

    the above format should be used to test custom input, and always starting state a:
    ['char', 'char', 'char', etc.]

<!-- ### Prolog Time Complexity

- **State Transition Lookup**: O(1) due to Prolog's indexing on the first argument of facts
- **Word Processing**: O(n) where n is the input word length
- **Backtracking**: Mitigated by the cut operator (!) to prevent exponential behavior -->

### 3. Regular Expressions (Regex) in Python

#### Theory
<!-- ### An NFA Approach with the RE Module -->
The Regex method is much simpler than the automata in prolog, using an existing pattern-matching language that's very widely used and available. 
With regex, a single expression using regex syntax can be used repeatedly to gauge whether the input is a match (valid word), or not (invalid word).

The Python implementation defines this expression using the RE python module, and simply returns checks whether the input is a match:

#### The Code

1. **Regular Expression Pattern**: 
   ```python
   valid_pattern = re.compile(r'^(Aiglos|Ainu|Alda|Aldalómë|Alqua$')
   ```
   This pattern directly encodes all valid word patterns, including optional components.

2. **Validation Function**:
   ```python
   def validate_word(word):
       return bool(valid_pattern.match(word))
   ```
   Returns a boolean indicating whether the word matches the pattern.

3. **Interactive CLI**:
   ```python
   def main():
       while True:
           print("\nChoose an option:")
           print("1. Test a list of valid words")
           print("2. Test a list of invalid words")
           print("3. Enter a custom word")
           print("4. Exit")
           
           # Menu handling code...
   ```
   Provides a user-friendly command-line interface for testing words.

#### How to Use

Run the script using Python:

```bash
python lex_regex.py
```

The program presents an interactive menu with these options:

1. **Test a list of valid words**: Tests predefined valid words
2. **Test a list of invalid words**: Tests predefined invalid words
3. **Enter a custom word**: Tests a user-provided word
4. **Exit**: Terminates the program

Example session:
```
Choose an option:
1. Test a list of valid words
2. Test a list of invalid words
3. Enter a custom word
4. Exit

Enter your choice: 1
Aiglos: True
Ainu: True
Alda: True
Aldalómë: True
Alqua: True
```

### Comparing Time Complexities

- **Pattern Matching**: O(n) where n is the length of the input string
- **Menu Operation**: O(1) per interaction
- **Batch Testing**: O(m × n) where m is the number of words and n is the average word length

## References

### Prolog References
- [Unstop on DFA vs NFA](https://unstop.com/blog/difference-between-dfa-and-nfa)
- [Coursera on Lexical Analysis](https://www.coursera.org/articles/lexical-analysis)

### Regex/Python References

