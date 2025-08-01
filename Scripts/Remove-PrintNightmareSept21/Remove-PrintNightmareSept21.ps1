<#
Checking for updates
    KB5005568 (Windows Server 2019)
    KB5005573 (Windows Server 2016)
    KB5005613 (Windows Server 2012 R2)
    KB5005627 (Windows Server 2012 R2)
    KB5005623 (Windows Server 2012)
    KB5005607 (Windows Server 2012)
    KB5005606 (Windows Server 2008)
    KB5005618 (Windows Server 2008)
    KB5005565 (Windows 10 2004, 20H2, and 21H1)
    KB5005566 (Windows 10 1909)
    KB5005615 (Windows 7 Windows Server 2008 R2)
#>
#Contants
$LogFilePath = "C:\AgileICT\PrintNightmareSept21"
$LogFileName = "$env:COMPUTERNAME" + "_PrintNightmareSept21.log"
$LogPath = ("$LogFilePath\" + $LogFileName)
$updatelist = @("5005568", "5005573", "5005613", "5005627")
Start-Transcript -Path $LogPath -Force
#Go though each KB ID and if found, we uninstall it
foreach ($update in $updatelist) {

        $Found = Get-Hotfix -ID "KB$update" -ErrorAction SilentlyContinue
        If ($Found) {
            & Write-Host -BackgroundColor Yellow -ForegroundColor Red("Removing $update")
            try {
                wusa.exe /uninstall /KB:$update /norestart
                Wait-Process -Name wusa
            } catch {
                Write-Error ("Error removing $update")
            }  
        } else {
            Write-Host("KB$update not found.")
        }
    }
Stop-Transcript