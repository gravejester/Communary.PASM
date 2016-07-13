# Build script for AppVeyor

[System.Version]$buildNumber = $env:APPVEYOR_BUILD_NUMBER
[System.Version]$currentManifestVersion = (Import-LocalizedData -FileName Communary.PASM.psd1).ModuleVersion

if ($buildNumber -gt $currentManifestVersion) {
    Update-ModuleManifest -Path .\Communary.PASM.psd1 -ModuleVersion $buildNumber
}