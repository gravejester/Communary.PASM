function Select-SoundexString {
    <#
        .SYNOPSIS
            Perform soundex string matching.
        .DESCRIPTION
            This function lets you perform string matching using
            the soundex algorithm. Note that this is only useful
            for shorter strings.
        .EXAMPLE
            Select-SoundexString -Search $searchQuery -In $searchData
        .EXAMPLE
            $searchData | Select-SoundexString $searchQuery
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
        [string] $Data
    )

    PROCESS {
        foreach ($string in $Data) {
            if ((Get-Soundex -String $string) -eq (Get-Soundex -String $Search)) {
                Write-Output $string
            }
        }
    }
}