function Get-FuzzyMatchScore {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string] $Search,

        [Parameter(Position = 1)]
        [string] $String
    )

    $score = 100

    # Use approximate string matching to get some values needed to calculate the score of the result
    $longestCommonSubstring = Get-LongestCommonSubstring -String1 $String -String2 $Search
    $levenshteinDistance = Get-LevenshteinDistance -String1 $String -String2 $Search
    $commonPrefix = Get-CommonPrefix -String1 $String -String2 $Search

    # By running the result through this regex pattern we get the length of the match as well as the
    # the index of where the match starts. The shorter the match length and the index, the more
    # score will be added for the match.
    $regexMatchFilter = $Search.ToCharArray() -join '.*?'
    $match = Select-String -InputObject $String -Pattern $regexMatchFilter -AllMatches
    $matchLength = ($match.Matches | Sort-Object Length | Select-Object -First 1).Value.Length
    $matchIndex = ($match.Matches | Sort-Object Length | Select-Object -First 1).Index

    # Calculate score
    $score = $score - $levenshteinDistance
    $score = $score * $longestCommonSubstring.Length
    $score = $score - $matchLength
    $score = $score - $matchIndex

    if ($commonPrefix) {
        $score =  $score + $commonPrefix.Length
    }

    Write-Output $score
}