function Get-JaccardDistance {
    <#
        .SYNOPSIS
            Get the Jaccard Distance between two strings.
        .DESCRIPTION
            The Jaccard distance, which measures dissimilarity between sample sets, is complementary to the 
            Jaccard coefficient and is obtained by subtracting the Jaccard coefficient from 1, or, equivalently, 
            by dividing the difference of the sizes of the union and the intersection of two sets by the size of the union
        .EXAMPLE
            Get-JaccardDistance 'karolin' 'kharolin'
        .LINK
            http://en.wikipedia.org/wiki/Jaccard_index
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.ToolBox
        .NOTES
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
            Dependencies: Get-JaccardIndex
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory)]
        [ValidateNotNullOrEmpty()]
        $a,
 
        [Parameter(Position = 1, Mandatory)]
        [ValidateNotNullOrEmpty()]
        $b,
 
        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )
 
    try {
        # calculate the jaccard distance
        $jaccardDistance = 1 - (Get-JaccardIndex $a $b -CaseSensitive:$CaseSensitive)
        Write-Output $jaccardDistance
    }
 
    catch {
        Write-Warning $_.Exception.Message
    }
}