Describe 'FuzzySearch' {
    Context 'WithoutScores' {
        It 'Searches correctly' {
            $countries = Import-Csv .\countries.csv | Select-Object -ExpandProperty Name
            $countries | Select-FuzzyString 'norw' -CalculateScore:$false | Should Be 'Norway'
            ($countries | Select-FuzzyString 'kingd' -CalculateScore:$false).Count | Should Be 2
        }
    }

    Context 'WithScores' {
        It 'Searches correctly' {
            $countries = Import-Csv .\countries.csv | Select-Object -ExpandProperty Name
            ($countries | Select-FuzzyString 'norw').Result| Should Be 'Norway'
            ($countries | Select-FuzzyString 'norw').Score| Should Be 392
        }
    }
}

Describe 'SoundexSearch' {
    Context 'Search' {
        It 'Searches correctly' {
            $names = Get-Content .\names.txt
            ($names | Select-SoundexString 'Jon').Count | Should Be 4
        }
    }
}

Describe 'ApproximateSearch' {
    Context 'Default algorithm' {
        It 'Searches correctly' {
            $countries = Import-Csv .\countries.csv | Select-Object -ExpandProperty Name
            $countries | Select-ApproximateString 'georigi' | Should Be 'Georgia'
        }
    }
    Context 'HammingDistance' {
        It 'Searches correctly' {
            $countries | Select-ApproximateString 'georigi' -Algorithm HammingDistance | Should Be 'Georgia'
        }
    }
    Context 'JacccardDistance' {
        It 'Searches correctly' {
            $countries | Select-ApproximateString 'georigi' -Algorithm JaccardDistance | Should Be 'Georgia'
        }
    }
}