function Compare-PasmAlgorithms {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String1,

        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String2,

        [Parameter()]
        [switch] $CaseSensitive
    )

    foreach ($a in ([enum]::GetNames('PasmAlgorithm'))) {
        $pasmScore = 0
        $pasmScore = Get-PasmScore -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive -Algorithm $a
        Write-Output (,([PSCustomObject] [Ordered] @{
            String1 = $String1
            String2 = $String2
            Algorithm = $a
            Score = $pasmScore
        }))
    }
}