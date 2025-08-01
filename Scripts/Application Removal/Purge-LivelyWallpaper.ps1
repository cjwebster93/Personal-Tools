
# This script removes Lively Wallpaper from the system. It will log the results to C:\tmp\LivelyWallpaper-Removal.log
function Get-TimeStamp {
  return "[{0:dd/MM/yyyy} {0:HH:mm:ss}]" -f (Get-Date)
}
Function Write-MCLOutput ([string]$Text){
  Write-Host $Text    
  return $Text
}
$AppPackage = Get-AppxPackage -Name *LivelyWallpaper* -AllUsers

$LogFile = "C:\tmp\LivelyWallpaper-Removal.log"

if ($AppPackage -eq $null) {
    Write-Host "$(Get-TimeStamp) - Lively Wallpaper is not installed."
    exit
} else {
    Write-MCLOutput "$(Get-TimeStamp) - Lively Wallpaper is installed." | Out-File -FilePath $LogFile -Append
    try {
      Write-MCLOutput "$(Get-TimeStamp) - Removing Lively Wallpaper." | Out-File -FilePath $LogFile -Append
      Remove-AppPackage -Package $AppPackage.PackageFullName -AllUsers
    }
    catch {
      Write-MCLOutput "$(Get-TimeStamp) - Failed to remove Lively Wallpaper." | Out-File -FilePath $LogFile -Append
    }
    
}