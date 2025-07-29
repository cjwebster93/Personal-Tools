#Created by Craig Webster

$ModuleCheck = Get-Module -Name PSWinddowsUpdate

If ($ModuleCheck -eq $null) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module PSWindowsUpdate -Force
    Import-Module PSWindowsUpdate -Force
    Write-Host("Installed module")
}
else {
    Write-Host ("Module already installed!")
}
Write-Host ("Installing updates...")
Get-WindowsUpdate -AcceptAll -Install -Verbose -AutoReboot | Out-File C:\PSWindowsUpdate.log