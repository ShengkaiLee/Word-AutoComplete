# COMS 4995 Parallel Functional Programming: Word AutoComplete


## Introduction: 
Word AutoComplete, or Word AutoSuggestion is a feature in which an application predicts the rest of a word a user is typing. It is most commonly used in search engines, like Google, to suggest queries when users begin typing the first few letters of their search string. 
These auto-suggestions should be as responsive as possible: they need to show up on the screen before users finish typing, otherwise the suggestion becomes pointless and useless. Hence, the speed of Word AutoSuggestion is crucial, which brought us to this project: speeding up word auto-suggestion with parallelism in Haskell.


## Command:
### Install package
```
stack install parallel
stack install split
```
### Compile program
```
git clone https://github.com/wy2249/word-autocompletion.git

cd Parallel

stack ghc -- -O2  main.hs -threaded -rtsopts -eventlog 
./main test.txt +RTS -N4  -s -ls
threadscope main.eventlog
```

## Project Details:
### Word Cleanup: 
Given a large enough text file as the dictionary of suggestion, we want to clean it up by discarding all non-alphabetic characters aside from whitespace and treating what's left as lowercase, and finally producing a list of cleaned words.
An example of “Word Cleanup” result: [“haskell”, “plt”, “programming”...]

### Word Count: 
Given the large cleaned words list, we want to generate (word, frequency) pairs to help us provide top N word suggestions based on frequency in the future. 
An example of “Word Count” result: [(“haskell”, 4995), (“plt”, 4115)]

### N-grams Count: 
Given the large cleaned n-grams list, we want to generate (n-grams, frequency) pairs to provide top N phrase suggestions based on frequency in the dictionary. 
An example of ‘3-grams Count’ result:
[(“haskell is great”, 10), (“best programming language”, 4995)]

### Word AutoComplete: 
Based on the result from Word Count, we move further to implement our own version of Word AutoComplete. It accepts a word from the user's input and return some suggestion to the user in the following three conditions:
If our dictionary contains the same word as the user’s input, we return the same word.
If the prefix of any word in our dictionary does not match the user’s input, we still return the same word. (i.e. we don’t have any suggestion)
Otherwise, we search/traverse our list. Find out the word whose prefix matches the user’s input and has the highest frequency.

### N-grams AutoComplete: 
Similar to our Word AutoComplete, It accepts a sentence L from the user's input, 0 < len(L) <= N-1, and tries to return some suggestion.


