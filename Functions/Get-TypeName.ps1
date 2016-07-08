function Get-TypeName {
    param ($InputObject)
    Write-Output (($InputObject | Get-Member).TypeName | Select-Object -Unique)
}