function Get-SorensenDiceDistance {
    <#
        .SYNOPSIS
            Get the Sorensen Dice Distance between two strings.
        .DESCRIPTION
            Uses the Sorensen Dice Coefficient to calculate the distance between two strings.
        .EXAMPLE
            Get-SorensenDiceDistance -String1 'night' -String2 'nacht'
        .LINK
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.PASM
        .NOTES
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
            Dependencies: Get-SorensenDiceCoefficient
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