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

Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Functions') | ForEach-Object {
    Get-ChildItem -Path $_.FullName | ForEach-Object {
        . $_.FullName
    }
}

Set-Alias -Name 'sfs' -Value Select-FuzzyString
Set-Alias -Name 'sss' -Value Select-SoundexString
Set-Alias -Name 'sas' -Value Select-ApproximateString