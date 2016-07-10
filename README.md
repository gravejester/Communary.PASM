# Communary.PASM
## PowerShell Approximate String Matching

This module contains three main functions for doing approximate string matching using the following methods:

- Fuzzy Search
- [Soundex](https://en.wikipedia.org/wiki/Soundex)
- Approximate String Matching algorithms

All of the string matching algorithms are included as stand-alone functions, and can be used outside of this module.

There is also a helper function for comparing the included approximate string matching algorithms against each other.

#### Approximate String Matching Algorithms
- [Overlap Coefficient](https://en.wikipedia.org/wiki/Overlap_coefficient)
- [Longest Common Substring](https://en.wikipedia.org/wiki/Longest_common_substring_problem)
- [Longest Common Subsequence](https://en.wikipedia.org/wiki/Longest_common_subsequence_problem)
- [Hamming Distance](https://en.wikipedia.org/wiki/Hamming_distance)
- [Ratcliff/Obershelp Similarity](http://collaboration.cmc.ec.gc.ca/science/rpn/biblio/ddj/Website/articles/DDJ/1988/8807/8807c/8807c.htm)
- [Jaccard Index](https://en.wikipedia.org/wiki/Jaccard_index)
- [Jaccard Distance](https://en.wikipedia.org/wiki/Jaccard_index)
- [Sorensen-Dice Coefficient](https://en.wikipedia.org/wiki/S%C3%B8rensen%E2%80%93Dice_coefficient)
- [Sorensen-Dice Distance](https://en.wikipedia.org/wiki/S%C3%B8rensen%E2%80%93Dice_coefficient)
- [Jaro Distance](https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance)
- [Jaro-Winkler Distance](https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance)
- [Levenshtein Distance](https://en.wikipedia.org/wiki/Levenshtein_distance)

#### Fuzzy Search Algorithm
This algorithm is basically a wildcard search (where a wildcard is placed before and after each character in the search query), but additionally it will calculate a score according to this set of rules:

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

#### How to use
All functions (should) have built-in help with examples of how to use them.