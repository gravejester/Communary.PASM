# Communary.PASM
## PowerShell Approximate String Matching

This module contains three main functions for doing approximate string matching using the following methods:

- Fuzzy Search
- Soundex
- Approximate String Matching algorithms

All of the string matching algorithms are included as stand-alone functions, and can be used outside of this module.

There is also a helper function for comparing the included approximate string matching algorithms against each other.

#### Approximate String Matching Algorithms
- Overlap Coefficient
- Longest Common Substring
- Longest Common Subsequence
- Hamming Distance
- Ratcliff/Obershelp Similarity
- Jaccard Index
- Jaccard Distance
- Sorensen-Dice Coefficient
- Sorensen-Dice Distance
- Jaro Distance
- Jaro-Winkler Distance
- Levenshtein Distance

#### Fuzzy Search Algorithm
This algorithm is basically a wildcard search (where a wildcard is placed before and after each character in the search query), but additionally it will calculate a score according to a set of rules:

- An initial score of 100 is given for anything that matches the query
- The Levenshtein Distance is subtracted from the score
- The length of the longest common substring are multiplied with the score
- The length of the shortest regex match is subtracted from the score
- The length of the index of the regex match is subtracted from the score
- If a common prefix exists, the length of this is added to the score

#### Installation
If you have PowerShellGet, you can install it with:

    Install-Module Communary.PASM

Else, you would have to download the zip from this repository and manually unpack it to one of the module paths on your system.

#### How to used
[coming]