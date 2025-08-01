<#
Checking for updates
    KB5000802 (version 2004/20H2)
	KB5000803 (Windows Server)
	KB5000808 (version 1909)
	KB5000809 (version 1809)
	KB5000822 (version 1803)
#>
#Contants
$LogFilePath = "C:\AgileICT\PrintBSODUpdate"
$LogFileName = "$env:COMPUTERNAME" + "_PrintBSODUpdate.log"
$LogPath = ("$LogFilePath\" + $LogFileName)
$updatelist = @("5000802", "5000803", "5000808", "5000809", "5000822")
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