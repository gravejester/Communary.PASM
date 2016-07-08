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
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.ToolBox
        .INPUTS
            System.String
        .OUTPUTS
            System.Boolean
        .NOTES
            Author: Øyvind Kallstad
            Date: 07.11.2014
            Version: 1.0
            Dependencies: Get-Soundex
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