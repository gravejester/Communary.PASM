function Select-ApproximateString {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Search,

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
        [string] $Tolerance = 'Strong',

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
            $pasmScore = Get-PasmScore -String1 $Search -String2 $string -CaseSensitive:$CaseSensitive
            if ($pasmScore -ge $toleranceValue) {
                Write-Output $string
            }
        }
    }
}