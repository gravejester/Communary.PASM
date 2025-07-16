function Select-ApproximateString {
    <#
        .SYNOPSIS
            Perform approximate string matching.
        .DESCRIPTION
            This function lets you perform string matching using
            different approximate string matching algorithms.
        .EXAMPLE
            Select-ApproximateString -Search $searchQuery -In $searchData
        .EXAMPLE
            $searchData | Select-ApproximateString $searchQuery -Algorithm HammingDistance -Tolerance Weak
        .INPUTS
            System.String
            System.String[]
        .OUTPUTS
            System.String
        .NOTES
            Author: Øyvind Kallstad
            Date: 08.07.2016
            Version: 1.0
        .LINK
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.PASM
    #>
    [CmdletBinding()]
    param (
        # The search query.
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Search,

        # The data you want to search through.
        [Parameter(Position = 1, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('In')]
        [string] $Data,

        # Algorithm to use for approximate string matching.
        [Parameter()]
        [PasmAlgorithm] $Algorithm = [PasmAlgorithm]::JaroWinklerDistance,

        # Matching tolerance.
        [Parameter()]
        [ValidateSet('Strong','Normal','Weak')]
        [string] $Tolerance = 'Normal',

        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )

    BEGIN {
        switch ($Tolerance) {
            'Strong' { $toleranceValue = 80}
            'Normal' { $toleranceValue = 60}
            'Weak' { $toleranceValue = 40}
        }
    }

    PROCESS {
        foreach ($string in $Data) {
            $pasmScore = Get-PasmScore -String1 $Search -String2 $string -Algorithm $Algorithm -CaseSensitive:$CaseSensitive
            if ($pasmScore -ge $toleranceValue) {
                Write-Output $string
            }
        }
    }
}
