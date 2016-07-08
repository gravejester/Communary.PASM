function Get-JaccardIndex {
    <#
        .SYNOPSIS
            Get the Jaccard Index of two strings.
        .DESCRIPTION
            The Jaccard index, also known as the Jaccard similarity coefficient, measures similarity between finite sample sets, 
            and is defined as the size of the intersection divided by the size of the union of the sample sets.
        .EXAMPLE
            Get-JaccardIndex 'karolin' 'kharolin'
            Calculate the Jaccard Index for the two strings. The output should be 0.875
        .EXAMPLE
            Get-JaccardIndex (1,2,4) (2,4,6)
            Calculate the Jaccard Index for the two sets. The output should be 0.5
        .LINK
            http://en.wikipedia.org/wiki/Jaccard_index
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.ToolBox
        .NOTES
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
            Dependencies: Get-Intersection, Get-Union
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $a,
 
        [Parameter(Position = 1, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $b,
 
        # Makes matches case-sensitive. By default, matches are not case-sensitive.
        # This parameter is only applicable if the input are strings.
        [Parameter()]
        [switch] $CaseSensitive
    )
 
    try {
        # verify both inputs are the same type
        if (-not ($a.GetType().Name -eq $b.GetType().Name)) {
            Write-Warning 'Both inputs need to be of the same type.'
            break
        }
        
        if ($a.GetType().Name -eq 'String') {
            if (-not($CaseSensitive)) {
                $a = $a.ToLower()
                $b = $b.ToLower()
            }
            $aArray = $a.ToCharArray()
            $bArray = $b.ToCharArray()
        }
        else {
            $aArray = $a
            $bArray = $b
        }
        
        # get intersection size and union size of both strings
        $intersectionSize = (Get-Intersection $aArray $bArray -CaseSensitive:$CaseSensitive).Length
        $unionSize = (Get-Union $aArray $bArray -CaseSensitive:$CaseSensitive).Length
 
        # calculate jaccard index by dividing union size with intersection size
        Write-Output ($intersectionSize / $unionSize)
    }
 
    catch {
        Write-Warning $_.Exception.Message
    }
}