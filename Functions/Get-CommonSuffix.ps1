function Get-CommonSuffix {
    <#
        .SYNOPSIS
            Find the common suffix of two strings.
        .DESCRIPTION
            This function will get the common suffix of two strings; that is, all
            the letters that they share, starting from the end of the strings.
        .EXAMPLE
            Get-CommonPrefix 'Morning' 'Lasting'
            Will get the common suffix of both string. Should output 'ing'.
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
            Dependencies: Get-CommonPrefix
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]$String1,

        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullOrEmpty()]
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

    # Let the maximum prefix length be the same as the length of the shortest of
    # the two input strings, unless defined by the MaxPrefixLength parameter.
    if (($shortestStringLength -lt $MaxSuffixLength) -or ($MaxSuffixLength -eq 0)) {
        $MaxSuffixLength = $shortestStringLength
    }

    $tmp = Get-CommonPrefix ($String1[-1..-($String1.Length)] -join '') ($String2[-1..-($String2.Length)] -join '') -MaxPrefixLength $MaxSuffixLength -CaseSensitive:$CaseSensitive
    Write-Output ($tmp[-1..-($tmp.Length)] -join '')
}