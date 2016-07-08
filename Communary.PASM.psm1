Add-Type -TypeDefinition @"
   public enum PasmAlgorithm
   {
      OverlapCoefficient,
      LongestCommonSubstring,
      LongestCommonSubsequence,
      Soundex,
      HammingDistance,
      RatcliffObershelpSimilarity,
      JaccardIndex,
      JaccardDistance,
      SorensenDiceCoefficient,
      SorensenDiceDistance,
      JaroDistance,
      JaroWinklerDistance,
      LevenshteinDistance
   }
"@

function Get-PasmScore {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String1,

        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $String2,

        [Parameter()]
        [switch] $CaseSensitive,

        [Parameter()]
        [PasmAlgorithm] $Algorithm = [PasmAlgorithm]::JaccardDistance
    )

    switch ($Algorithm) {
        'OverlapCoefficient' {$score = ([Math]::Round((Get-OverlapCoefficient -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'LongestCommonSubstring' {$score = ([Math]::Round(((Get-LongestCommonSubstring -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive).Length / [Math]::Min($String1.Length,$String2.Length)) * 100))}
        'LongestCommonSubsequence' {$score = ([Math]::Round((((Get-LongestCommonSubsequence -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive).count) / ([Math]::Min($String1.Length,$String2.Length))) * 100))}
        'Soundex' {if (Compare-Soundex -String1 $String1 -String2 $String2) {$score = 100} else {$score = 0}} 
        'HammingDistance' {$score = ([Math]::Round((Get-HammingDistanceEx -String1 $String1 -String2 $String2 -NormalizeOutput -CaseSensitive:$CaseSensitive) * 100))}
        'RatcliffObershelpSimilarity' {$score = ([Math]::Round((Get-RatcliffObershelpSimilarity -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'JaccardIndex' {$score = ([Math]::Round((Get-JaccardIndex -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'JaccardDistance' {$score = ([Math]::Round((1 - (Get-JaccardDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive)) * 100))}
        'SorensenDiceCoefficient' {$score = ([Math]::Round((Get-SorensenDiceCoefficient -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'SorensenDiceDistance' {$score = ([Math]::Round((1 - (Get-SorensenDiceDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive)) * 100))}
        'JaroDistance' {$score = ([Math]::Round((Get-JaroWinklerDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive -OnlyCalculateJaroDistance) * 100))}
        'JaroWinklerDistance' {$score = ([Math]::Round((Get-JaroWinklerDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'LevenshteinDistance' {$score = ([Math]::Round((Get-LevenshteinDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive -NormalizeOutput) * 100))}
    }

    Write-Output $score
}

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
        $pasmScore = Get-PasmScore -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive -Algorithm $a
        Write-Output (,([PSCustomObject] [Ordered] @{
            String1 = $String1
            String2 = $String2
            Algorithm = $a
            Score = $pasmScore
        }))
    }
}

function Search-For {
    <#
        .SYNOPSIS
            Approximate String Search.
        .EXAMPLE
            Search-For 'John' -In $names -Tolerance Normal
        .EXAMPLE
            $names | Search-For 'John'
        .NOTES
            Author: Øyvind Kallstad
            Date: 07.11.2014
            Version: 1.0
    #>
    [CmdletBinding()]
    param (
        # Word to search for.
        [Parameter(Position = 0)]
        [string] $Word,

        # String, or collection of strings, to search in.
        [Parameter(ValueFromPipeline)]
        [string[]] $In,

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
        foreach ($string in $In) {
            $pasmScore = Get-PasmScore -String1 $Word -String2 $string -CaseSensitive:$CaseSensitive
            if ($pasmScore -ge $toleranceValue) {
                Write-Output $string
            }
        }
    }
}