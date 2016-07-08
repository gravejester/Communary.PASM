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
            http://stackoverflow.com/questions/19123506/jaro-winkler-distance-algorithm-in-c-sharp
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.ToolBox
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