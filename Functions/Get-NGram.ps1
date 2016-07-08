function Get-NGram {
    <#
        .SYNOPSIS
            Get the n-gram of a string.
        .DESCRIPTION
            An n-gram is a contiguous sequence of n items from a given sequence of text or speech.
        .EXAMPLE
            Get-NGram 'Pennsylvania'
        .EXAMPLE
            Get-NGram -String 'to be or not to be' -Size 3 -Separator ' '
        .EXAMPLE
            Get-NGram 'Cys-Gly-Leu-Ser-Trp' 4 -Separator '-'
        .LINK
            http://en.wikipedia.org/wiki/N-gram
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.ToolBox
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
        [Parameter(Position = 0, Mandatory = $true)]
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