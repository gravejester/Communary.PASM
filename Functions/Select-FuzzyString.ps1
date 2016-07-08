function Select-FuzzyString {
    <#
        .SYNOPSIS
            Perform fuzzy string search.
        .DESCRIPTION
            This function lets you perform fuzzy string search, and will
            calculate a score for each result found. This score can be used
            to sort the results to get the most relevant results first.
        .EXAMPLE
            Select-FuzzyString -Search $searchQuery -In $searchData
        .EXAMPLE
            $searchData | Select-FuzzyString $searchQuery
        .EXAMPLE
            $searchData | Select-FuzzyString $searchQuery | Sort-Object Score,Result -Descending
        .INPUTS
            System.String
            System.String[]
        .OUTPUTS
            System.Object
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

        # Set to True (default) it will calculate the match score.
        [Parameter()]
        [switch] $CalculateScore = $true
    )

    BEGIN {
        # Remove spaces from the search string
        $search = $Search.Replace(' ','')

        # Add wildcard characters before and after each character in the search string
        $quickSearchFilter = '*'

        $search.ToCharArray().ForEach({
            $quickSearchFilter += $_ + '*'
        })
    }

    PROCESS {
        foreach ($string in $Data) {

            # Trim to get rid of offending whitespace
            $string = $string.Trim()

            # Do a quick search using wildcards
            if ($string -like $quickSearchFilter) {

                Write-Verbose "Found match: $($string)"

                if ($CalculateScore) {

                    # Get score of match
                    $score = Get-FuzzyMatchScore -Search $Search -String $string

                    Write-Output (,([PSCustomObject][Ordered] @{
                        Score = $score
                        Result = $string
                    }))
                }

                else {
                    Write-Output $string
                }
            }
        }
    }
}