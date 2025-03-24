# Project README

## Overview

This project consists of two main components:

1. **Prolog Dictionary**: A Prolog-based dictionary system that validates whether a given word is valid according to a predefined set of transformations.
2. **Regex Validation**: A Python script that uses regular expressions (regex) to validate if a word matches one of a set of predefined valid words.

---

## Prolog Dictionary

### How It Works:

- The Prolog file defines a set of rules to validate whether a sequence of letters can be transformed into a valid word, starting from an initial state and ending at a valid state.
- **Knowledge Base**: The `move/3` predicates define valid transitions between states using letters (e.g., `move(a, b, 'A').` means that the letter 'A' transitions from state `a` to state `b`).
- **Accepting State**: The `accept/1` predicate defines that a word is valid if it reaches the final state `z`.
- **Fixing Misread Characters**: The `fix_char/2` predicate ensures that specific misread characters (such as 'Ã³' being interpreted as 'ó') are corrected before validation.
- **Consultation of Dictionary**: The `consult_dic/2` predicate processes a list of letters, checking each letter’s transition and ensuring it leads to a valid state.

### Time Complexity:

The time complexity of the Prolog solution primarily depends on the length of the input word (`n`) and the number of transitions in the knowledge base. In the worst case, the program would need to examine each character of the word and follow the corresponding transitions.

- **Worst-case time complexity**: O(n), where `n` is the length of the word being processed, assuming the transition rules are simple and do not introduce deep recursion.

### Example Use Case:

```prolog
consult_dic(['A', 'i', 'g', 'l', 'o', 's'], a).
This will check if the word 'Aiglos' is valid according to the transformations in the Prolog knowledge base.

Regex Validation
How It Works:
The Python script uses regular expressions (regex) to check whether a given word matches a set of valid words. The regular expression is designed to match the following words:

Aiglos

Ainu

Alda

Aldalómë

Alqua

The Regex Pattern:
python
Copy
Edit
valid_pattern = re.compile(r'^(A(i(g|n|d)|l(g|q|o)|d(lómë)?|q(ua)?))$')
This regex pattern matches the following rules:

The first letter must be 'A'.

The second letter must be 'i' or 'l'.

The third letter can vary depending on the word: 'g', 'n', 'd', etc.

The following characters must match the exact sequence required by each valid word.


Time Complexity:
The time complexity of the regex validation depends on the length of the input string (n) and the complexity of the regex pattern.

Worst-case time complexity: O(n), where n is the length of the word being tested. This is because the regex engine processes each character once and attempts to match it against the pattern.

Example Use Case:
Enter 1 to test predefined valid words, 2 for predefined non-valid words, or 3 for your own
input.

Comparison:
The Prolog dictionary is more flexible, allowing for complex state transitions and logic-based validations, but can be slower depending on the number of rules and transitions.

The regex solution is faster for simple validation tasks and allows for quick matching of predefined patterns.

References:
Prolog Documentation: https://www.swi-prolog.org/

Regex Documentation: https://docs.python.org/3/library/re.html

Prolog and Regex Time Complexity: The time complexity is based on basic algorithmic principles. In Prolog, it depends on the depth of recursion and the number of rules, while in regex, it depends on the length of the string and the complexity of the regex pattern.