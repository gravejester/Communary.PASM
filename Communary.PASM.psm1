Add-Type -TypeDefinition @"
   public enum PasmAlgorithm
   {
      OverlapCoefficient,
      LongestCommonSubstring,
      LongestCommonSubsequence,
      Soundex,
      HammingDistance,
      RatcliffObershelpSimilarity,
      JaccardIndex,
      JaccardDistance,
      SorensenDiceCoefficient,
      SorensenDiceDistance,
      JaroDistance,
      JaroWinklerDistance,
      LevenshteinDistance
   }
"@

function Get-Intersection {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [array] $Array1,

        [Parameter(Position = 1, Mandatory)]
        [array] $Array2,

        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )
    
    if ($CaseSensitive) {
        Write-Output ($Array1 | Select-Object -Unique | Where-Object {$Array2 -ccontains $_})
    }

    else {
        Write-Output ($Array1 | Select-Object -Unique | Where-Object {$Array2 -contains $_})
    }
    
}

function Get-StringIntersection {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [string] $String1,

        [Parameter(Position = 1, Mandatory)]
        [string] $String2,

        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )

    if (-not($CaseSensitive)) {
        $String1 = $String1.ToLowerInvariant()
        $String2 = $String2.ToLowerInvariant()
    }

    Write-Output (($String1.GetEnumerator() | Select-Object -Unique | Where-Object {$String2.GetEnumerator() -ccontains $_}) -join '')
}

function Get-Union {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [array] $Array1,
 
        [Parameter(Position = 1, Mandatory)]
        [array] $Array2
    )
    Write-Output ($Array1 + $Array2 | Select-Object -Unique)
}

function Get-StringUnion {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [string] $String1,

        [Parameter(Position = 1, Mandatory)]
        [string] $String2,

        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )

    if (-not($CaseSensitive)) {
        $String1 = $String1.ToLowerInvariant()
        $String2 = $String2.ToLowerInvariant()
    }

    Write-Output (($String1.GetEnumerator() + $String2.GetEnumerator() | Select-Object -Unique) -join '')
}

function Get-NGrams {
    <#
        .SYNOPSIS
            Get the n-gram of a string.
        .DESCRIPTION
            An n-gram is a contiguous sequence of n items from a given sequence of text or speech.
        .EXAMPLE
            Get-NGrams 'Pennsylvania'
        .EXAMPLE
            Get-NGrams -String 'to be or not to be' -Size 3 -Separator ' '
        .EXAMPLE
            Get-NGrams 'Cys-Gly-Leu-Ser-Trp' 4 -Separator '-'
        .LINK
            http://en.wikipedia.org/wiki/N-gram
        .LINK
            https://github.com/gravejester/PASM
        .INPUTS
            System.String
        .OUTPUTS
            System.Array
        .NOTES
            Author: Øyvind Kallstad
            Date: 07.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [string] $String,

        # Defines the size of the n-gram. A size of 1 results in a unigram, a size of 2 (the default) results in a bigram, a size of 3 results in a trigram etc.
        [Parameter(Position = 1)]
        [int] $Size = 2,

        # Sequence separator
        [Parameter()]
        [string] $Separator
    )

    try {
        if ($Size -lt 1) { Write-Warning 'Size cannot be less than 1'; return }

        if (-not([string]::IsNullOrEmpty($Separator))) {
            $s = $String.Split($Separator)

            # return if size is greater than the number of items in array after split
            if ($Size -gt $s.Count) { Write-Warning "Size cannot be longer than $($s.count)"; return }

            for ($i = 0; $i -le ($s.Count - $Size); $i++) {
                Write-Output (,($s[$i..($i + ($Size - 1))]  -join $Separator))
            }
        }

        else {
            # return if size is greater than string length
            if ($Size -gt $String.Length) { Write-Warning "Size cannot be longer than string length ($($String.Length))"; return }

            for ($i = 0; $i -lt ($String.Length - ($Size - 1)); $i++) {
                Write-Output (,($String.Substring($i,$Size)))
            }
        }
    }

    catch {
        Write-Warning $_.Exception.Message
    }
}

function Get-CommonPrefix {
    [CmdletBinding()]
    param( 
        [Parameter(Position = 0)]
        [string]$String1,
        
        [Parameter(Position = 1)]
        [string]$String2,
     
        # Maximum length of the returned prefix.   
        [Parameter()]
        [int]$MaxPrefixLength,

        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )

    if (-not($CaseSensitive)) {
        $String1 = $String1.ToLowerInvariant()
        $String2 = $String2.ToLowerInvariant()
    }

    $outputString = New-Object 'System.Text.StringBuilder'
    $shortestStringLength = [Math]::Min($String1.Length,$String2.Length)

    if (($shortestStringLength -lt $MaxPrefixLength) -or ($MaxPrefixLength -eq 0)) {
        $MaxPrefixLength = $shortestStringLength
    }

    for ($i = 0; $i -lt $MaxPrefixLength; $i++) {
        if ($String1[$i] -ceq $String2[$i]) {
            [void]$outputString.Append($String1[$i])
        }
        else { break }
    }

    Write-Output $outputString.ToString()
}

function Get-CommonSuffix {
    [CmdletBinding()]
    param( 
        [Parameter(Position = 0)]
        [string]$String1,
        
        [Parameter(Position = 1)]
        [string]$String2,
     
        # Maximum length of the returned suffix.   
        [Parameter()]
        [int]$MaxSuffixLength,

        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )

    if (-not($CaseSensitive)) {
        $String1 = $String1.ToLowerInvariant()
        $String2 = $String2.ToLowerInvariant()
    }

    $shortestStringLength = [Math]::Min($String1.Length,$String2.Length)

    if (($shortestStringLength -lt $MaxSuffixLength) -or ($MaxSuffixLength -eq 0)) {
        $MaxSuffixLength = $shortestStringLength
    }

    $tmp = Get-CommonPrefix ($String1[-1..-($String1.Length)] -join '') ($String2[-1..-($String2.Length)] -join '') -MaxPrefixLength $MaxSuffixLength -CaseSensitive:$CaseSensitive
    Write-Output ($tmp[-1..-($tmp.Length)] -join '')
}

function Get-OverlapCoefficient {
    <#
        .SYNOPSIS
            Get the Overlap Coefficient of two strings.
        .DESCRIPTION
            The overlap coefficient is a similarity measure related to the Jaccard index that measures the overlap between two sets, and is defined as the size of the intersection divided by the smaller of the size of the two sets.
        .EXAMPLE
            Get-OverlapCoefficient 'Pennsylvania' 'Pencilvaneya'
        .LINK
            http://en.wikipedia.org/wiki/Overlap_coefficient
        .LINK
            https://github.com/gravejester/PASM
        .NOTES
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateNotNullorEmpty()]
        [string] $String1,
 
        [Parameter(Position = 1)]
        [ValidateNotNullorEmpty()]
        [string] $String2,

        [Parameter()]
        [switch] $CaseSensitive
    )

    if (-not($CaseSensitive)) {
        $String1 = $String1.ToLowerInvariant()
        $String2 = $String2.ToLowerInvariant()
    }
    
    try {
        $intersectionSize = (Get-StringIntersection $String1 $String2 -CaseSensitive:$CaseSensitive).Length
        $smallestStringSize = [Math]::Min($String1.Length,$String2.Length)

        Write-Output ($intersectionSize / $smallestStringSize)
    }

    catch {
        Write-Warning $_.Exception.Message
    }
}

function Get-LongestCommonSubstring {
    <#
        .SYNOPSIS
            Get the longest common substring of two strings.
        .DESCRIPTION
            Get the longest common substring of two strings.
        .EXAMPLE
            Get-LongestCommonSubstring -Source 'Karolin' -Target 'kathrin' -CaseSensitive
        .LINK
            https://fuzzystring.codeplex.com/
        .LINK
            http://en.wikipedia.org/wiki/Longest_common_substring_problem
        .LINK
            https://github.com/gravejester/PASM
        .NOTES
            Adapted to PowerShell from code by Kevin Jones (https://fuzzystring.codeplex.com/)
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string] $String1,
 
        [Parameter(Position = 1)]
        [string] $String2,
 
        [Parameter()]
        [switch] $CaseSensitive
    )
 
    if (-not($CaseSensitive)) {
        $String1 = $String1.ToLowerInvariant()
        $String2 = $String2.ToLowerInvariant()
    }
 
    $array = New-Object 'Object[,]' $String1.Length, $String2.Length
    $stringBuilder = New-Object System.Text.StringBuilder
    $maxLength = 0
    $lastSubsBegin = 0
 
    for ($i = 0; $i -lt $String1.Length; $i++) {
        for ($j = 0; $j -lt $String2.Length; $j++) {
            if ($String1[$i] -cne $String2[$j]) {
                $array[$i,$j] = 0
            }
            else {
                if (($i -eq 0) -or ($j -eq 0)) {
                    $array[$i,$j] = 1
                }
                else {
                    $array[$i,$j] = 1 + $array[($i - 1),($j - 1)]
                }
                if ($array[$i,$j] -gt $maxLength) {
                    $maxLength = $array[$i,$j]
                    $thisSubsBegin = $i - $array[$i,$j] + 1
                    if($lastSubsBegin -eq $thisSubsBegin) {
                        [void]$stringBuilder.Append($String1[$i])
                    }
                    else {
                        $lastSubsBegin = $thisSubsBegin
                        $stringBuilder.Length = 0
                        [void]$stringBuilder.Append($String1.Substring($lastSubsBegin, (($i + 1) - $lastSubsBegin)))
                    }
                }
            }
        }
    }
 
    Write-Output $stringBuilder.ToString()
}

Function Get-LongestCommonSubsequence {
    <#
        .SYNOPSIS
            Get the longest common subsequence between two strings.
        .DESCRIPTION
            Get the longest common subsequence between two strings.
        .EXAMPLE
            Get-LongestCommonSubsequence -String1 'Pennsylvania' -String2 'pencilvaneya' -CaseSensitive
        .LINK
            https://gallery.technet.microsoft.com/scriptcenter/Longest-common-subsequence-173c0f45
        .LINK
            http://en.wikipedia.org/wiki/Longest_common_subsequence_problem
        .LINK
            https://github.com/gravejester/PASM
        .NOTES
            Author: Barry Chum
    #>
    [CmdletBinding()]
    Param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullorEmpty()]
        [string] $String1,
 
        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullorEmpty()]
        [string] $String2,
    
        [Parameter()]
        [switch] $CaseSensitive
    )
 
    if (-not($CaseSensitive)) {
        $String1 = $String1.ToLowerInvariant()
        $String2 = $String2.ToLowerInvariant()
    }
   
    $lengths = New-Object 'object[,]' ($String1.Length + 1), ($String2.Length + 1)
  
    for($i = 0; $i -lt $String1.length; $i++) {
      for ($j = 0; $j -lt $String2.length; $j++) {
        if ($String1[$i] -ceq $String2[$j]) {
          $lengths[($i+1),($j+1)] = $lengths[$i,$j] + 1
        } else {
          $lengths[($i+1),($j+1)] = [math]::max(($lengths[($i+1),$j]),($lengths[$i,($j+1)]))  
        }
      }
    }
  
    $lcs = @()
    $x = $String1.length
    $y = $String2.length
 
    while (($x -ne 0) -and ($y -ne 0)) {
        if ( $lengths[$x,$y] -eq $lengths[($x-1),$y]) {
            --$x
        }
        elseif ($lengths[$x,$y] -eq $lengths[$x,($y-1)]) {
            --$y
        }
        else {
            if ($String1[($x-1)] -ceq $String2[($y-1)]) {
                $lcs = ,($String1[($x-1)]) + $lcs
            }
            --$x
            --$y
        }
    }
    Write-Output $lcs
}

function Get-Soundex {
    <#
        .SYNOPSIS
            Get the soundex code of a string.
        .DESCRIPTION
            Soundex is a phonetic algorithm for indexing names by sound, as pronounced in English. 
            The goal is for homophones to be encoded to the same representation so that they can be matched despite minor differences in spelling. 
            The algorithm mainly encodes consonants; a vowel will not be encoded unless it is the first letter.
        .EXAMPLE
            Get-Soundex 'Tymczak'
        .LINK
            http://en.wikipedia.org/wiki/Soundex
        .LINK
            https://github.com/gravejester/PASM
        .NOTES
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [string] $String
    )
 
    # convert to upper case and strip of illegal characters
    $String = $String.ToUpper()
    $String = [regex]::Replace($String, '[^\w\s]', [System.String]::Empty)
        
    $maxSoundexLength = 4   
    $previousWasHorW = $false    
    $soundex = New-Object System.Text.StringBuilder
 
    # soundex always starts with the first letter of the string
    [void]$soundex.Append($String[0])
 
    for ($i = 1; $i -lt $String.Length; $i++) {
 
        $soundexNumberForCurrentCharacter = ConvertTo-SoundexNumber $String[$i]
        
        # don't add 0s as these are not part of the soundex    
        if ($soundexNumberForCurrentCharacter -ne 0) {
 
            # if soundex same as previous, don't add
            if ($soundexNumberForCurrentCharacter -eq (ConvertTo-SoundexNumber $String[($i -1)])) {
                continue
            }
 
            # two letters with the same number separated by 'h' or 'w' are coded as a single number
            if (($i -gt 2) -and ($previousWasHorW) -and ($soundexNumberForCurrentCharacter -eq (ConvertTo-SoundexNumber ($String[$i-2])))) {
                continue
            }
 
            [void]$soundex.Append($soundexNumberForCurrentCharacter)
        }
 
        $previousWasHorW = @('H','W') -contains $String[$i]
    }
 
    $soundexNumberForFirstChar = ConvertTo-SoundexNumber $String[0]
 
    # remove same numbers adjacent at the start of the soundex
    Write-Output (($soundex[0] + ($soundex.ToString().Substring(1)).TrimStart("$soundexNumberForFirstChar")).PadRight($maxSoundexLength, '0').Substring(0, $maxSoundexLength))
}
 
function ConvertTo-SoundexNumber {
    param([char]$Char)
 
    $a1 = @('B','F','P','V')
    $a2 = @('C','G','J','K','Q','S','X','Z')
    $a3 = @('D','T')
    $a4 = @('L')
    $a5 = @('M','N')
    $a6 = @('R')
 
    # convert char to soundex number
    switch ($Char) {
        {$a1 -contains $_} {$soundexNumber = 1;break}
        {$a2 -contains $_} {$soundexNumber = 2;break}
        {$a3 -contains $_} {$soundexNumber = 3;break}
        {$a4 -contains $_} {$soundexNumber = 4;break}
        {$a5 -contains $_} {$soundexNumber = 5;break}
        {$a6 -contains $_} {$soundexNumber = 6;break}
        DEFAULT {$soundexNumber = 0}
    }
 
    Write-Output $soundexNumber
}

function Get-HammingDistanceEx {
    <#
        .SYNOPSIS
            Get the Hamming Distance between two strings.
        .DESCRIPTION
            The Hamming distance between two strings of equal length is the number of positions at which the corresponding symbols are different. 
            In another way, it measures the minimum number of substitutions required to change one string into the other, or the minimum number of errors that could have transformed one string into the other.
            Note! Even though the original Hamming algorithm only works for strings of equal length, this function supports strings of unequal length as well.
        .EXAMPLE
            Get-HammingDistance  -Source 'karolin' -Target 'kathrin'
        .LINK
            http://en.wikipedia.org/wiki/Hamming_distance
        .LINK
            https://github.com/gravejester/PASM
        .NOTES
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String1,
 
        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String2,
 
        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive,
 
        # Normalize the output value. When the output is not normalized the maximum value is the length of the longest string, and the minimum value is 0,
        # meaning that a value of 0 is a 100% match. When the output is normalized you get a value between 0 and 1, where 1 indicates a 100% match.
        [Parameter()]
        [switch] $NormalizeOutput
    )
 
    try {
        # handle case insensitivity
        if (-not($CaseSensitive)) {
            $String1 = $String1.ToLowerInvariant()
            $String2 = $String2.ToLowerInvariant()
        }
 
        # set initial distance
        $distance = 0
 
        # get max and min length of the input strings
        $maxLength = [Math]::Max($String1.Length,$String2.Length)
        $minLength = [Math]::Min($String1.Length,$String2.Length)
    
        # calculate distance for the length of the shortest string
        for ($i = 0; $i -lt $minLength; $i++) {
            if (-not($String1[$i] -ceq $String2[$i])) {
                $distance++
            }
        }
 
        # add the remaining length to the distance
        $distance = $distance + ($maxLength - $minLength)
                
        if ($NormalizeOutput) {
            Write-Output (1 - ($distance / $maxLength))
        }
 
        else {
            Write-Output $distance
        }
    }
 
    catch {
        Write-Warning $_.Exception.Message
    }
}

function Get-RatcliffObershelpSimilarity {
    <#
        .SYNOPSIS
            Get the Ratcliff/Obershelp Similarity between two strings.
        .DESCRIPTION
            The best way to describe the Ratcliff/Obershelp pattern-matching algorithm, in using conventional computer terminology, is as a wild-card search that doesn't require wild cards.
            Instead, the algorithm creates its own wildcards, based on the closest matches found between the strings. Specifically, the algorithm works by examining two strings passed to it 
            and locating the largest group of characters in common. The algorithm uses this group of characters as an anchor between the two strings. The algorithm then places any group of 
            characters found to the left or the right of this anchor on a stack for further examination. This procedure is repeated for all substrings on the stack until there is nothing 
            left to examine. The algorithm calculates the score returned as twice the number of characters found in common divided by the total number of characters in the two strings; 
            the score is returned as an integer, reflecting a percentage match.
        .EXAMPLE
            Get-RatcliffObershelpSimilarity -String1 'Pennsylvania' -String2 'Pencilvaneya'
        .LINK
            http://collaboration.cmc.ec.gc.ca/science/rpn/biblio/ddj/Website/articles/DDJ/1988/8807/8807c/8807c.htm
        .LINK
            https://github.com/gravejester/PASM
        .NOTES
            Author: Øyvind Kallstad
            Date: 05.11.2014
            Version: 1.0
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

function Get-JaccardIndex {
    <#
        .SYNOPSIS
            Get the Jaccard Index of two strings.
        .DESCRIPTION
            The Jaccard index measures similarity between finite sample sets, and is defined as the size of the intersection divided by the size of the union of the sample sets.
        .EXAMPLE
            Get-JaccardIndex 'karolin' 'kharolin'
        .LINK
            http://en.wikipedia.org/wiki/Jaccard_index
        .LINK
            https://github.com/gravejester/PASM
        .NOTES
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String1,
 
        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String2,
 
        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )
 
    try {
        # handle case insensitivity
        if (-not($CaseSensitive)) {
            $String1 = $String1.ToLowerInvariant()
            $String2 = $String2.ToLowerInvariant()
        }
 
        # get intersection size and union size of both strings
        $intersectionSize = (Get-StringIntersection $String1 $String2 -CaseSensitive:$CaseSensitive).Length
        $unionSize = (Get-StringUnion $String1 $String2 -CaseSensitive:$CaseSensitive).Length
 
        # calculate jaccard index by dividing union size with intersection size
        Write-Output ($intersectionSize / $unionSize)
    }
 
    catch {
        Write-Warning $_.Exception.Message
    }
}

function Get-JaccardDistance {
    <#
        .SYNOPSIS
            Get the Jaccard Distance between two strings.
        .DESCRIPTION
            The Jaccard distance, which measures dissimilarity between sample sets, is complementary to the Jaccard coefficient and is obtained by subtracting the Jaccard coefficient from 1,
            or, equivalently, by dividing the difference of the sizes of the union and the intersection of two sets by the size of the union
        .EXAMPLE
            Get-JaccardDistance 'karolin' 'kharolin'
        .LINK
            http://en.wikipedia.org/wiki/Jaccard_index
        .NOTES
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String1,
 
        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String2,
 
        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )
 
    try {
        # handle case insensitivity
        if (-not($CaseSensitive)) {
            $String1 = $String1.ToLowerInvariant()
            $String2 = $String2.ToLowerInvariant()
        }
        
        # calculate the jaccard distance
        $jaccardDistance = 1 - (Get-JaccardIndex -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive)
        Write-Output $jaccardDistance
    }
 
    catch {
        Write-Warning $_.Exception.Message
    }
}

function Get-SorensenDiceCoefficient {
    <#
        .SYNOPSIS
            Get the Sorensen Dice Coefficient of two strings.
        .DESCRIPTION
            The Sørensen–Dice index, is a statistic used for comparing the similarity of two samples.
        .EXAMPLE
            Get-SorensenDiceCoefficient -String1 'night' -String2 'night'
        .LINK
            http://en.wikipedia.org/wiki/S%C3%B8rensen%E2%80%93Dice_coefficient
        .NOTES
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String1,
 
        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String2,

        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )

    # handle case insensitivity
    if (-not($CaseSensitive)) {
        $String1 = $String1.ToLowerInvariant()
        $String2 = $String2.ToLowerInvariant()
    }

    $string1Bigrams = Get-NGrams -String $String1 -Size 2
    $string2Bigrams = Get-NGrams -String $String2 -Size 2
    $intersections = (Get-Intersection $string1Bigrams $string2Bigrams -CaseSensitive:$CaseSensitive).count
    Write-Output ([double](2 * $intersections) / [double]($string1Bigrams.count + $string2Bigrams.count))
}
 
function Get-SorensenDiceDistance {
    <#
        .SYNOPSIS
            Get the Sorensen Dice Distance between two strings.
        .DESCRIPTION
            Uses the Sorensen Dice Coefficient to calculate the distance between two strings.
        .EXAMPLE
            Get-SorensenDiceDistance -String1 'night' -String2 'nacht'
        .NOTES
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String1,
 
        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String2,

        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )
 
    Write-Output (1 - (Get-SorensenDiceCoefficient -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive))
}

function Get-JaroWinklerDistance {
    <#
        .SYNOPSIS
            Get the Jaro-Winkler distance between two strings.
        .DESCRIPTION
            The Jaro–Winkler distance (Winkler, 1990) is a measure of similarity between two strings. 
            It is a variant of the Jaro distance metric (Jaro, 1989, 1995), a type of string edit distance.
        .EXAMPLE
            Get-JaroDistance 'MARTHA' 'MARHTA' -Jaro
            This will get the Jaro Distance between the two strings.
        .EXAMPLE
            Get-JaroDistance 'MARTHA' 'MARHTA'
            This will get the Jaro-Winkler Distance between the two strings.
        .EXAMPLE
            Get-JaroDistance 'MARTHA' 'MARHTA' -NormalizedOutput
            This will get the normalized Jaro-Winkler Distance between the two strings.
        .LINK
            http://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance
        .LINK
            https://github.com/gravejester/PASM
        .LINK
            http://stackoverflow.com/questions/19123506/jaro-winkler-distance-algorithm-in-c-sharp
        .NOTES
            Adapted from code by leebickmtu posted to http://stackoverflow.com/questions/19123506/jaro-winkler-distance-algorithm-in-c-sharp
            Author: Øyvind Kallstad
            Date: 07.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string] $String1,

        [Parameter(Position = 1)]
        [string] $String2,

        # The Winkler modification will not be applied unless the percent match was at or above the mWeightThreshold percent without the modification. 
        # Winkler's paper used a default value of 0.7
        [Parameter()]
        [double] $WeightThreshold = 0.7,

        # Size of the prefix to be concidered by the Winkler modification.
        # Winkler's paper used a default value of 4
        [Parameter()]
        [int] $NumChars = 4,

        # Only output Jaro Distance.
        [Parameter()]
        [Alias('Jaro')]
        [switch] $OnlyCalculateJaroDistance,

        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive,

        # A normalized output will fall in the range 0 (perfect match) to 1 (no match).
        [Parameter()]
        [switch] $NormalizeOutput
    )

    if (-not($CaseSensitive)) {
        $String1 = $String1.ToLowerInvariant()
        $String2 = $String2.ToLowerInvariant()
    }

    # two characters from string1 and string2 respectively, are considered matching only if they are the same and not farther than:
    $searchRange = ([Math]::Max($String1.Length,$String2.Length) / 2) - 1
   
    $matched1 = New-Object 'Bool[]' $String1.Length
    $matched2 = New-Object 'Bool[]' $String2.Length
    
    # calculate matching characters between the two strings
    $matchingCharacters = 0
    for ($i = 0; $i -lt $String1.Length; $i++) {
        $start = [Math]::Max(0,($i - $searchRange))
        $end = [Math]::Min(($i + $searchRange + 1), $String2.Length)
        for ($j = $start; $j -lt $end; $j++) {
            if ($matched2[$j]) { continue }
            if ($String1[$i] -cne $String2[$j]) { continue }
            $matched1[$i] = $true
            $matched2[$j] = $true
            $matchingCharacters++
            break
        }
    }
    if ($matchingCharacters -eq 0) { return 0.0 }

    # calculate transpositions
    $halfTransposed = 0
    $k = 0
    for ($i = 0; $i -lt $String1.Length; $i++) {
        if (-not($matched1[$i])) { continue }
        while (-not($matched2[$k])) { $k++ }
        if ($String1[$i] -cne $String2[$k]) { $halfTransposed++ }
        $k++
    }
    $transposed = $halfTransposed / 2

    # calculate the Jaro Distance
    [double]$jaroDistance = (($matchingCharacters / $String1.Length) + ($matchingCharacters / $String2.Length) + (($matchingCharacters - $transposed) / $matchingCharacters)) / 3

    if ($OnlyCalculateJaroDistance) {
        $output =  $jaroDistance
    }

    else { # calculate Jaro-Winkler

        if ($jaroDistance -le $WeightThreshold) { 
            $output =  $jaroDistance 
        }

        # continue if Jaro Distance is greater than the weight threshold
        else { 
            $max = [Math]::Max($NumChars, ([Math]::Min($String1.Length,$String2.Length)))
            $position = 0
            while (($position -lt $max) -and ($String1[$position] -ceq $String2[$position])) { $position++ }
            if ($position -eq 0) {
                $output =  $jaroDistance
            }
            
            else {
                $output =  ($jaroDistance + ($position * 0.1 * (1.0 - $jaroDistance)))
            }
            
        }
    }

    if ($NormalizeOutput) {
        Write-Output (1 - $output)
    }

    else {
        Write-Output $output
    }
}

function Get-LevenshteinDistance {
    <#
        .SYNOPSIS
            Get the Levenshtein distance between two strings.
        .DESCRIPTION
            The Levenshtein Distance is a way of quantifying how dissimilar two strings (e.g., words) are to one another by counting the minimum number of operations required to transform one string into the other.
        .EXAMPLE
            Get-LevenshteinDistance -Source 'kitten' -Target 'sitting'
        .LINK
            http://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#C.23
        .LINK
            https://github.com/gravejester/PASM
        .LINK
            http://en.wikipedia.org/wiki/Edit_distance
        .NOTES
            Author: Øyvind Kallstad
            Date: 07.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$String1, 

        [Parameter(Position = 1)]
        [string]$String2,

        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive,

        # A normalized output will fall in the range 0 (perfect match) to 1 (no match).
        [Parameter()]
        [switch] $NormalizeOutput
    )

    if (-not($CaseSensitive)) {
        $String1 = $String1.ToLowerInvariant()
        $String2 = $String2.ToLowerInvariant()
    }
 
    $d = New-Object 'Int[,]' ($String1.Length + 1), ($String2.Length + 1)
        
    try {
        for ($i = 0; $i -le $d.GetUpperBound(0); $i++) {
            $d[$i,0] = $i
        }
 
        for ($i = 0; $i -le $d.GetUpperBound(1); $i++) {
            $d[0,$i] = $i
        }
 
        for ($i = 1; $i -le $d.GetUpperBound(0); $i++) {
            for ($j = 1; $j -le $d.GetUpperBound(1); $j++) {
                $cost = [Convert]::ToInt32((-not($String1[$i-1] -ceq $String2[$j-1])))
                $min1 = $d[($i-1),$j] + 1
                $min2 = $d[$i,($j-1)] + 1
                $min3 = $d[($i-1),($j-1)] + $cost
                $d[$i,$j] = [Math]::Min([Math]::Min($min1,$min2),$min3)
            }
        }

        $distance = ($d[$d.GetUpperBound(0),$d.GetUpperBound(1)])
 
        if ($NormalizeOutput) {
            Write-Output (1 - ($distance) / ([Math]::Max($String1.Length,$String2.Length)))
        }

        else {
            Write-Output $distance
        }   
    }
 
    catch {
        Write-Warning $_.Exception.Message
    }
}

function Compare-Soundex {
    <#
        .SYNOPSIS
            Compare two strings using Soundex to check for similarity.
        .DESCRIPTION
            This function will return true if two (english) words sound alike, and false otherwise.
        .EXAMPLE
            Compare-Soundex 'Johnny' 'Jonny'
            Will return True
        .LINK
            https://github.com/gravejester/PASM
        .INPUTS
            System.String
        .OUTPUTS
            System.Boolean
        .NOTES
            Author: Øyvind Kallstad
            Date: 07.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [string] $String1,

        [Parameter(Position = 1, Mandatory)]
        [string] $String2
    )

    if ((Get-Soundex -String $String1) -eq (Get-Soundex -String $String2)) {
        return $true
    }

    else {
        return $false
    }
}

function Get-PasmScore {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String1,

        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String2,

        [Parameter()]
        [switch] $CaseSensitive,

        [Parameter()]
        [PasmAlgorithm] $Algorithm = [PasmAlgorithm]::JaccardDistance
    )

    switch ($Algorithm) {
        'OverlapCoefficient' {$score = ([Math]::Round((Get-OverlapCoefficient -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'LongestCommonSubstring' {$score = ([Math]::Round(((Get-LongestCommonSubstring -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive).Length / [Math]::Min($String1.Length,$String2.Length)) * 100))}
        'LongestCommonSubsequence' {$score = ([Math]::Round((((Get-LongestCommonSubsequence -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive).count) / ([Math]::Min($String1.Length,$String2.Length))) * 100))}
        'Soundex' {if (Compare-Soundex -String1 $String1 -String2 $String2) {$score = 100} else {$score = 0}} 
        'HammingDistance' {$score = ([Math]::Round((Get-HammingDistanceEx -String1 $String1 -String2 $String2 -NormalizeOutput -CaseSensitive:$CaseSensitive) * 100))}
        'RatcliffObershelpSimilarity' {$score = ([Math]::Round((Get-RatcliffObershelpSimilarity -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'JaccardIndex' {$score = ([Math]::Round((Get-JaccardIndex -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'JaccardDistance' {$score = ([Math]::Round((1 - (Get-JaccardDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive)) * 100))}
        'SorensenDiceCoefficient' {$score = ([Math]::Round((Get-SorensenDiceCoefficient -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'SorensenDiceDistance' {$score = ([Math]::Round((1 - (Get-SorensenDiceDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive)) * 100))}
        'JaroDistance' {$score = ([Math]::Round((Get-JaroWinklerDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive -OnlyCalculateJaroDistance) * 100))}
        'JaroWinklerDistance' {$score = ([Math]::Round((Get-JaroWinklerDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'LevenshteinDistance' {$score = ([Math]::Round((Get-LevenshteinDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive -NormalizeOutput) * 100))}
    }

    Write-Output $score
}

function Compare-PasmAlgorithms {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String1,

        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String2,

        [Parameter()]
        [switch] $CaseSensitive
    )

    foreach ($a in ([enum]::GetNames('PasmAlgorithm'))) {
        $pasmScore = Get-PasmScore -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive -Algorithm $a
        Write-Output (,([PSCustomObject] [Ordered] @{
            String1 = $String1
            String2 = $String2
            Algorithm = $a
            Score = $pasmScore
        }))
    }
}

function Search-For {
    <#
        .SYNOPSIS
            Approximate String Search.
        .EXAMPLE
            Search-For 'John' -In $names -Tolerance Normal
        .EXAMPLE
            $names | Search-For 'John'
        .NOTES
            Author: Øyvind Kallstad
            Date: 07.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param (
        # Word to search for.
        [Parameter(Position = 0)]
        [string] $Word,

        # String, or collection of strings, to search in.
        [Parameter(ValueFromPipeline)]
        [string[]] $In,

        # Algorithm to use for approximate string matching.
        [Parameter()]
        [PasmAlgorithm] $Algorithm = [PasmAlgorithm]::JaroWinklerDistance,

        # Matching tolerance.
        [Parameter()]
        [ValidateSet('Strong','Normal','Weak')]
        [string] $Tolerance = 'Strong',

        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )

    BEGIN {
        switch ($Tolerance) {
            'Strong' { $toleranceValue = 80}
            'Normal' { $toleranceValue = 60}
            'Weak' { $toleranceValue = 40}
        }
    }

    PROCESS {
        foreach ($string in $In) {
            $pasmScore = Get-PasmScore -String1 $Word -String2 $string -CaseSensitive:$CaseSensitive
            if ($pasmScore -ge $toleranceValue) {
                Write-Output $string
            }
        }
    }
}