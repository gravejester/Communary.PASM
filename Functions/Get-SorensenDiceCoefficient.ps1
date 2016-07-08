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
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.ToolBox
        .NOTES
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
            Dependencies: Get-NGram, Get-Intersection
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

    $string1Bigrams = Get-NGram -String $String1 -Size 2
    $string2Bigrams = Get-NGram -String $String2 -Size 2
    $intersections = (Get-Intersection $string1Bigrams $string2Bigrams -CaseSensitive:$CaseSensitive).count
    Write-Output ([double](2 * $intersections) / [double]($string1Bigrams.count + $string2Bigrams.count))
}