function Select-SoundexString {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Search,

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