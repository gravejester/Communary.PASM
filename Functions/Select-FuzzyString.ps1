function Select-FuzzyString {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Search,

        [Parameter(Position = 1, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [Alias('In')]
        [string] $Data,

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