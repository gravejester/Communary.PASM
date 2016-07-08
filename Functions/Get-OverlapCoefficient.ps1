function Get-OverlapCoefficient {
    <#
        .SYNOPSIS
            Get the Overlap Coefficient of two strings.
        .DESCRIPTION
            The overlap coefficient is a similarity measure related to the Jaccard index that measures the overlap between two sets,
            and is defined as the size of the intersection divided by the smaller of the size of the two sets.
        .EXAMPLE
            Get-OverlapCoefficient 'Pennsylvania' 'Pencilvaneya'
        .LINK
            http://en.wikipedia.org/wiki/Overlap_coefficient
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.ToolBox
        .NOTES
            Author: Øyvind Kallstad
            Date: 03.11.2014
            Version: 1.0
            Dependencies: Get-Intersection
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateNotNullorEmpty()]
        [string] $String1,

        [Parameter(Position = 1)]
        [ValidateNotNullorEmpty()]
        [string] $String2,

        [Parameter()]
        [switch] $CaseSensitive
    )

    if (-not($CaseSensitive)) {
        $String1 = $String1.ToLowerInvariant()
        $String2 = $String2.ToLowerInvariant()
    }

    try {
        $intersectionSize = (Get-Intersection $String1 $String2 -CaseSensitive:$CaseSensitive).Length
        $smallestStringSize = [Math]::Min($String1.Length,$String2.Length)

        Write-Output ($intersectionSize / $smallestStringSize)
    }

    catch {
        Write-Warning $_.Exception.Message
    }
}