#Crated by Craig Webster
#Tests for a key that will have been placed if this had been run already.
$Exists = Test-Path -Path "HKLM:\SOFTWARE\Agile\OfficeHub\Removed"

<#If it exists, then just exit.
Else, we remove the package and then put our key in to say this is done.
#>
If ($Exists) {
    Write-Host("This script has been run before... Exiting")
    exit
}
else {
    Get-AppxPackage *OfficeHub* | remove-appxpackage
    New-Item -Path "HKLM:\SOFTWARE\Agile\OfficeHub\Removed" -Force
}
