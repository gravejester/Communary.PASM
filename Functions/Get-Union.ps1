function Get-Union {
    <#
        .SYNOPSIS
            Get the union of two sets.
        .DESCRIPTION
            This function returns all distinct elements of two sets, also called the union of two sets.
        .EXAMPLE
            Get-Union (1,10,2,1) (1,2,3)
        .EXAMPLE
            Get-Union 'John' 'Ronny'
        .EXAMPLE
            Get-Union 'Jon' 'jon' -CaseSensitive
        .LINK
            http://en.wikipedia.org/wiki/Union_%28set_theory%29
            https://communary.wordpress.com/
            https://github.com/gravejester/Communary.ToolBox
        .INPUTS
            System.Array
            System.String
        .NOTES
            Author: Øyvind Kallstad
            Date: 21.05.2015
            Version: 1.0
            Dependencies: Get-TypeName
    #>
    [OutputType([System.Array])]
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        $Set1,

        [Parameter(Position = 1, Mandatory = $true)]
        $Set2,

        # Makes string unions case sensitive.
        [Parameter()]
        [switch] $CaseSensitive
    )

    try {
        # if sets are strings, convert to array of chars
        if ($Set1 -is [string]) {
            if (-not($CaseSensitive)) {
                $Set1 = $Set1.ToLowerInvariant()
            }
            $Set1 = $Set1.ToCharArray()
        }
        if ($Set2 -is [string]) {
            if (-not($CaseSensitive)) {
                $Set2 = $Set2.ToLowerInvariant()
            }
            $Set2 = $Set2.ToCharArray()
        }

        # check that the sets are arrays
        if (-not($set1.GetType().IsArray) -or -not($Set2.GetType().IsArray)) {
            Write-Warning 'Oops! Input must be arrays!'
            break
        }

        # get the types of the elements in the sets
        $arrayTypesSet1 = Get-TypeName $Set1
        $arrayTypesSet2 = Get-TypeName $Set2

        # check that the sets do not contain mixed types
        if (($arrayTypesSet1 -is [array]) -and ($arrayTypesSet2 -is [array])) {
            Write-Warning 'Oops! One, or both, of the sets contain mixed types!'
            break
        }

        # check that the sets contain the same type
        if ($arrayTypesSet1 -ne $arrayTypesSet2) {
            Write-Warning 'Oops! The two sets contain different types!'
            break
        }

        # create hash sets
        $hashSet1 = New-Object System.Collections.Generic.HashSet[$arrayTypesSet1] (,($set1 -as "$arrayTypesSet1[]"))
        $hashSet2 = New-Object System.Collections.Generic.HashSet[$arrayTypesSet2] (,($set2 -as "$arrayTypesSet2[]"))

        # get the union between them
        $hashSet1.UnionWith($hashSet2)

        # convert hashset to array and write output to pipeline
        $outputArray = New-Object -TypeName "$arrayTypesSet1[]" ($hashSet1.Count)
        $hashSet1.CopyTo($outputArray)
        Write-Output $outputArray
    }

    catch {
        Write-Warning $_.Exception.Message
    }
}