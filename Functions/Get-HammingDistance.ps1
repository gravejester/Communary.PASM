function Get-HammingDistance {
    <#
        .SYNOPSIS
            Get the Hamming Distance between two strings or two positive integers.
        .DESCRIPTION
            The Hamming distance between two strings of equal length is the number of positions at which the
            corresponding symbols are different. In another way, it measures the minimum number of substitutions
            required to change one string into the other, or the minimum number of errors that could have
            transformed one string into the other. Note! Even though the original Hamming algorithm only works for
            strings of equal length, this function supports strings of unequal length as well.

            The function also calculates the Hamming distance between two positive integers (considered as binary
            values); that is, it calculates the number of bit substitutions required to change one integer into
            the other.
        .EXAMPLE
            Get-HammingDistance 'karolin' 'kathrin'
            Calculate the Hamming distance between the two strings. The result is 3.
        .EXAMPLE
            Get-HammingDistance 'karolin' 'kathrin' -NormalizedOutput
            Calculate the normalized Hamming distance between the two strings. The result is 0.571428571428571.
        .EXAMPLE
            Get-HammingDistance -Int1 61 -Int2 15
            Calculate the hamming distance between 61 and 15. The result is 3.
        .LINK
            http://en.wikipedia.org/wiki/Hamming_distance
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.ToolBox
        .NOTES
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
    #>
    [CmdletBinding(DefaultParameterSetName = 'String')]
    param (
        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'String')]
        [ValidateNotNullOrEmpty()]
        [string] $String1,

        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'String')]
        [ValidateNotNullOrEmpty()]
        [string] $String2,

        [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'Integer')]
        [ValidateNotNullOrEmpty()]
        [uint32] $Int1,

        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'Integer')]
        [ValidateNotNullOrEmpty()]
        [uint32] $Int2,

        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter(ParameterSetName = 'String')]
        [switch] $CaseSensitive,

        # Normalize the output value. When the output is not normalized the maximum value is the length of the longest string, and the minimum value is 0,
        # meaning that a value of 0 is a 100% match. When the output is normalized you get a value between 0 and 1, where 1 indicates a 100% match.
        [Parameter(ParameterSetName = 'String')]
        [switch] $NormalizeOutput
    )

    try {
        if ($PSCmdlet.ParameterSetName -eq 'String') {
            # handle case insensitivity
            if (-not($CaseSensitive)) {
                $String1 = $String1.ToLowerInvariant()
                $String2 = $String2.ToLowerInvariant()
            }

            # set initial distance
            $distance = 0

            # get max and min length of the input strings
            $maxLength = [Math]::Max($String1.Length,$String2.Length)
            $minLength = [Math]::Min($String1.Length,$String2.Length)

            # calculate distance for the length of the shortest string
            for ($i = 0; $i -lt $minLength; $i++) {
                if (-not($String1[$i] -ceq $String2[$i])) {
                    $distance++
                }
            }

            # add the remaining length to the distance
            $distance = $distance + ($maxLength - $minLength)

            if ($NormalizeOutput) {
                Write-Output (1 - ($distance / $maxLength))
            }

            else {
                Write-Output $distance
            }
        }

        else {
            $distance = 0
            $value = $Int1 -bxor $Int2
            while ($value -ne 0) {
                $distance++
                $value = $value -band ($value - 1)
            }
            Write-Output $distance
        }
    }

    catch {
        Write-Warning $_.Exception.Message
    }
}