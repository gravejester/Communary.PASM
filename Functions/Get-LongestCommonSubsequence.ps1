function Get-LongestCommonSubsequence {
    <#
        .SYNOPSIS
            Get the longest common subsequence between two strings.
        .DESCRIPTION
            Get the longest common subsequence between two strings.
        .EXAMPLE
            Get-LongestCommonSubsequence -String1 'Pennsylvania' -String2 'pencilvaneya' -CaseSensitive
        .LINK
            https://gallery.technet.microsoft.com/scriptcenter/Longest-common-subsequence-173c0f45
            http://en.wikipedia.org/wiki/Longest_common_subsequence_problem
            https://github.com/gravejester/Communary.ToolBox
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