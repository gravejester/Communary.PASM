Import-Module $PSScriptRoot\..\Communary.PASM.psd1 -Force

InModuleScope 'Communary.PASM' {
    Describe 'Approximate String Matching algorithms' {
        It 'Longest Common Substring' {
            Get-LongestCommonSubstring Pennsylvania Pencilvaneya | Should -Be 'lvan'
        }

        It 'Levenshtein Distance' {
            Get-LevenshteinDistance Pennsylvania Pencilvaneya | Should -BeExactly 5
        }
    }

    Describe 'Select Functions' {
        It 'Select-FuzzySearch without scores' {
            $countries = Import-Csv $PSScriptRoot\countries.csv | Select-Object -ExpandProperty Name
            $countries | Select-FuzzyString 'norw' -CalculateScore:$false | Should -Be 'Norway'
            ($countries | Select-FuzzyString 'kingd' -CalculateScore:$false).Count | Should -Be 2
        }

        It 'Select-FuzzySearch with scores' {
            $countries = Import-Csv $PSScriptRoot\countries.csv | Select-Object -ExpandProperty Name
            ($countries | Select-FuzzyString 'norw').Result| Should -Be 'Norway'
            ($countries | Select-FuzzyString 'norw').Score| Should -Be 392
        }
    }

    Describe 'Misc' {
        It 'Get-CommonPrefix' {
            Get-CommonPrefix 'Card' 'Cartoon' | Should -Be 'car'
            Get-CommonPrefix 'Card' 'Cartoon' -CaseSensitive | Should -Be 'Car'
        }

        It 'Get-FuzzyMatchScore' {
            Get-FuzzyMatchScore 'Microsoft Corporation' 'soft' | Should -Be 332
            Get-FuzzyMatchScore 'Microsoft Corporation' 'Microsoft' | Should -Be 801
            Get-FuzzyMatchScore 'Microsoft Corporation' 'Microsoft Corporation' | Should -Be 2100
        }
    }
}