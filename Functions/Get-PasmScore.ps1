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
        'HammingDistance' {$score = ([Math]::Round((Get-HammingDistance -String1 $String1 -String2 $String2 -NormalizeOutput -CaseSensitive:$CaseSensitive) * 100))}
        'RatcliffObershelpSimilarity' {$score = ([Math]::Round((Get-RatcliffObershelpSimilarity -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'JaccardIndex' {$score = ([Math]::Round((Get-JaccardIndex -a $String1 -b $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'JaccardDistance' {$score = ([Math]::Round((1 - (Get-JaccardDistance -a $String1 -b $String2 -CaseSensitive:$CaseSensitive)) * 100))}
        'SorensenDiceCoefficient' {$score = ([Math]::Round((Get-SorensenDiceCoefficient -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'SorensenDiceDistance' {$score = ([Math]::Round((1 - (Get-SorensenDiceDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive)) * 100))}
        'JaroDistance' {$score = ([Math]::Round((Get-JaroWinklerDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive -OnlyCalculateJaroDistance) * 100))}
        'JaroWinklerDistance' {$score = ([Math]::Round((Get-JaroWinklerDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive) * 100))}
        'LevenshteinDistance' {$score = ([Math]::Round((Get-LevenshteinDistance -String1 $String1 -String2 $String2 -CaseSensitive:$CaseSensitive -NormalizeOutput) * 100))}
    }

    Write-Output $score
}