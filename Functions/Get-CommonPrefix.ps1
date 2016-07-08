function Get-CommonPrefix {
    <#
        .SYNOPSIS
            Find the common prefix of two strings.
        .DESCRIPTION
            This function will get the common prefix of two strings; that is, all
            the letters that they share, starting from the beginning of the strings.
        .EXAMPLE
            Get-CommonPrefix 'Card' 'Cartoon'
            Will get the common prefix of both string. Should output 'car'.
        .LINK
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.ToolBox
        .INPUTS
            System.String
        .OUTPUTS
            System.String
        .NOTES
            Author: Øyvind Kallstad
            Date: ?.?.2014
            Version 1.1
            Dependencies: none
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$String1,

        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
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

    # Let the maximum prefix length be the same as the length of the shortest of
    # the two input strings, unless defined by the MaxPrefixLength parameter.
    if (($shortestStringLength -lt $MaxPrefixLength) -or ($MaxPrefixLength -eq 0)) {
        $MaxPrefixLength = $shortestStringLength
    }

    # Loop from the start and add any characters found that are equal
    for ($i = 0; $i -lt $MaxPrefixLength; $i++) {
        if ($String1[$i] -ceq $String2[$i]) {
            [void]$outputString.Append($String1[$i])
        }
        else { break }
    }

    Write-Output $outputString.ToString()
}