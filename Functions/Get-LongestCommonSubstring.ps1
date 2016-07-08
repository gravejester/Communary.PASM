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
            http://en.wikipedia.org/wiki/Longest_common_substring_problem
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.ToolBox
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