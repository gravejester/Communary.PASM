function Get-RatcliffObershelpSimilarity {
    <#
        .SYNOPSIS
            Get the Ratcliff/Obershelp Similarity between two strings.
        .DESCRIPTION
            The best way to describe the Ratcliff/Obershelp pattern-matching algorithm, in using conventional computer terminology, 
            is as a wild-card search that doesn't require wild cards. Instead, the algorithm creates its own wildcards, based on the 
            closest matches found between the strings. Specifically, the algorithm works by examining two strings passed to it and 
            locating the largest group of characters in common. The algorithm uses this group of characters as an anchor between the 
            two strings. The algorithm then places any group of characters found to the left or the right of this anchor on a stack 
            for further examination. This procedure is repeated for all substrings on the stack until there is nothing left to examine. 
            The algorithm calculates the score returned as twice the number of characters found in common divided by the total number 
            of characters in the two strings; the score is returned as an integer, reflecting a percentage match.
        .EXAMPLE
            Get-RatcliffObershelpSimilarity -String1 'Pennsylvania' -String2 'Pencilvaneya'
        .LINK
            http://collaboration.cmc.ec.gc.ca/science/rpn/biblio/ddj/Website/articles/DDJ/1988/8807/8807c/8807c.htm
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.ToolBox
        .NOTES
            Author: Øyvind Kallstad
            Date: 05.11.2014
            Version: 1.0
            Dependencies: Get-LongestCommonSubstring
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string] $String1,
 
        [Parameter(Position = 1)]
        [string] $String2,
 
        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )
 
    try {
 
        # exit if both strings are empty (so we don't get a divide by zero error)
        if (($String1.Length -eq 0) -and ($String2.Length -eq 0)) { return }
    
        # handle case sensitivity
        if (-not($CaseSensitive)) {
            $String1 = $String1.ToLowerInvariant()
            $String2 = $String2.ToLowerInvariant()
        }
 
        $score = 0
 
        # get the combinded length of both strings
        $combindedStringLength = ($String1.Length + $String2.Length)
 
        Write-Verbose "Comparing '$($String1)' (length: $($String1.length)) and '$($String2)' (length: $($String2.length)) with a combined length of $($combindedStringLength)"
 
        # create a stack
        $stack = New-Object 'System.Collections.Stack'
 
        # push the two strings to the stack
        $stack.Push($String2)
        $stack.Push($String1)
 
        # do work until the stack is empty
        while ($stack.Count -ne 0) {
 
            # clean slate - just in case ;)
            Remove-Variable -Name String1,String2,rightString1,rightString2,leftString1,leftString2,lcs -ErrorAction 'SilentlyContinue'
 
            # pop the first two items from the stack
            if ($stack.Count -gt 0) {
                $String1 = $stack.Pop(); Write-Verbose "String1 from stack: $String1"
            }
 
            if ($stack.Count -gt 0) {
                $String2 = $stack.Pop(); Write-Verbose "String2 from stack: $String2"
            }
 
            # get the longest common substring of the two strings
            # check if we have two strings before calling the next function - saves a few cpu cycles if we only have 1 string :)
            if (($String1.Length -gt 0) -and ($String2.Length -gt 0)) {
                $lcs = Get-LongestCommonSubstring -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive
            } else { $lcs = ''}
 
            # only do the rest if a common substring is found
            if ($lcs -ne '') {
                
                # calculate new score
                $score += $lcs.Length * 2
                Write-Verbose "Longest common substring found was '$($lcs)', which gives us a score of $($lcs.Length * 2). Total score is $($score)"
 
                # get the characters to the left and right of the lcs for both strings
                $rightString1 = $String1.Substring($String1.IndexOf($lcs)+($lcs.length)); Write-Verbose "RightString1: $rightString1"
                $rightString2 = $String2.Substring($String2.IndexOf($lcs)+($lcs.length)); Write-Verbose "RightString2: $rightString2"
                if (($string1.IndexOf($lcs) -gt 0)) { $leftString1 = $String1.Substring(0,$String1.IndexOf($lcs)); Write-Verbose "LeftString1: $leftString1" }
                if (($string2.IndexOf($lcs) -gt 0)) { $leftString2 = $String2.Substring(0,$String2.IndexOf($lcs)); Write-Verbose "LeftString2: $leftString2" }
                
                # any strings found are pushed back to the stack
                if ($leftString2.Length -ne 0) { $stack.Push($leftString2); Write-Verbose "Pushed '$($leftString2)' back to the stack" }
                if ($leftString1.Length -ne 0) { $stack.Push($leftString1); Write-Verbose "Pushed '$($leftString1)' back to the stack" }
                if ($rightString2.Length -ne 0) { $stack.Push($rightString2); Write-Verbose "Pushed '$($rightString2)' back to the stack" }
                if ($rightString1.Length -ne 0) { $stack.Push($rightString1); Write-Verbose "Pushed '$($rightString1)' back to the stack" }
            }
 
            else {
                Write-Verbose 'No common substring found'
            }
        }
        
        Write-Output ($score / $combindedStringLength)
    }
 
    catch {
        Write-Warning $_.Exception.Message
    }
}