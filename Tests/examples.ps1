# Examples of use

$countries = Import-Csv .\countries.csv | Select-Object -ExpandProperty Name
$names = Get-Content .\names.txt

Write-Host ''

Write-Host '$countries | Select-FuzzyString uga' -ForegroundColor Green
$countries | Select-FuzzyString uga | Out-String

Write-Host '$countries | Select-FuzzyString uga | Sort-Object Score,Result -Descending' -ForegroundColor Green
$countries | Select-FuzzyString uga | Sort-Object Score,Result -Descending | Out-String

Write-Host '$names | Select-SoundexString john' -ForegroundColor Green
$names | Select-SoundexString john | Out-String