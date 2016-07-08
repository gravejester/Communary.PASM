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
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.ToolBox
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