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

the above format should be used to test custom input, meaning: <br>
consult(X, Y)<br>
where X is the word to test between brackets and separated into its characters, and Y is always a.

### 2. Regular Expressions (Regex) in Python

#### Theory

The Regex method is much simpler than the automata in prolog, using an existing pattern-matching language that's very widely used and available. 
With regex, a single expression using regex syntax can be used repeatedly to gauge whether the input is a match (valid word), or not (invalid word).

The Python implementation defines this expression using the RE python module, and simply checks whether the input is a match:

#### The Code

1. **Regular Expression Pattern**: 
   ```python
   valid_pattern = re.compile(r'^A(iglos|inu|lqua|lda|ldalómë)$')
   ```
   The compile function creates a match object to compare future input to, in other words it's our regular expression to use.

2. **Validation Function**:
   ```python
   def validate_word(word):
       return bool(valid_pattern.fullmatch(word))
   ```
   Here the '.fullmatch' function is used, which takes the input and looks for a complete match, start to finish, of the given regular expression, which is better than '.search' or '.match' for us since we don't want any extra letters at the beginning or end of our word, just exact full matches. <br>
   [RE Module Documentation](https://docs.python.org/3/library/re.html)<br>
   It returns a boolean indicating whether the word matches the pattern.


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

**Time Complexity of NFA in Prolog**
According to probably an expert on StackOverflow, the running time for an NFA is O(m^2(n)), where m is the number of nodes (or states in this case), and the O(n) for a DFA.<br>
[DFAs vs NFAs time complexity](https://stackoverflow.com/questions/4580654/time-complexity-trade-offs-of-nfa-vs-dfa#:~:text=The%20construction%20time%20for%20a,DFA%20for%20a%20given%20string.)<br>
Now, it's true that I use an NFA for my specific case, but there is only a single node with NFA like behavior (the *g* state which may lead to final state *z* or continue to *j* state with the same input), and the logic to decide the outcome of that behavior is a single if/else statement.<br>
So really my code behaves more like a DFA overall.<br>
And so the time complexity should be O(n), where n is the length of the input string. And this makes sense, because there is a recursive iteration for each letter in the input string (given there's a valid state transition), and a lack of any further complex logic.<br>
Since the scope of this code is so small, you could even consider it a time complexity of O(1), given that the longest it will ever run without fail is to iterate through each letter of the 'Aldalómë' word, which is only 8 iterations long.<br>

**Time Complexity of Regex with Python**
The RE module for python uses backtracking, which is NFA behavior, and implies the possibility of exponential time complexity when using lazy quantifiers like '*', or '?'.<br>
[Python Regex Engine](https://www.oreilly.com/library/view/mastering-python-regular/9781783283156/ch05s03.html#:~:text=The%20re%20module%20uses%20a,Finite%20Automata%20(NFA)%20type.)<br>
But in our case, due to the simplicity of the regular expression we are using, especially the definite '^' at the beginning and '$' at the end, the matching process isn't so free.<br>
The input will be compared character by character to the defined regular expression, and against each of the 5 available words, almost in a for-loop with an if (currChar === word[i]) type of way, that upon failing an exact match for the 5 words will simply end and return false.<br>
At least that's how I understand it, it was really hard to find a source that explains exactly how the re module functions actually traverse the given input to find matches.<br>
So in the end I think you could say that due to the very minimal amount of characters to check, the rigidity of the regular expression, and the exactness of the matching method, this code will have a time complexity of O(n) where n is the amount of valid words in the dictionary, and since n = 5, effectively virtually O(1).<br>

## References

### Prolog References
- [Unstop on DFA vs NFA](https://unstop.com/blog/difference-between-dfa-and-nfa)
- [Coursera on Lexical Analysis](https://www.coursera.org/articles/lexical-analysis)
- [DFAs vs NFAs time complexity](https://stackoverflow.com/questions/4580654/time-complexity-trade-offs-of-nfa-vs-dfa#:~:text=The%20construction%20time%20for%20a,DFA%20for%20a%20given%20string.)

### Regex/Python References
- [RE Module Documentation](https://docs.python.org/3/library/re.html)
- [Python Regex Engine](https://www.oreilly.com/library/view/mastering-python-regular/9781783283156/ch05s03.html#:~:text=The%20re%20module%20uses%20a,Finite%20Automata%20(NFA)%20type.)
