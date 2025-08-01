<#
    Script to clear relevant reg keys to fix frozen start menu/taskbar (Early 2021)
    User -Restart 0/1 or $true/$false to silently configure the restart timer.

    Craig Webster
#>

[CmdletBinding()]
param (
    [Parameter(Position=0)]
    $Restart
)

#Clear and recreate relevant reg keys
Write-Host -ForegroundColor  Yellow ("Resetting reg keys...")

Remove-Item "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\RestrictedServices\Configurable\System" 
New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\RestrictedServices\Configurable\System" 

Remove-Item "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" 
New-Item "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" 

Remove-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Notifications" -Recurse 
New-Item "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Notifications"

If ($null -eq $Restart) {
    Write-Host("A restart is required for changes to take effect, do you want to do this now?")
    $response = Read-Host -Prompt "Enter Y/N"
    switch ($response) {
        "Y" {
            $Restart = $true
          }
        "N" {
            $Restart = $false
        }
        Default {$Restart = $false}
    }
}

If ($Restart -eq $true) {
    Write-Host -ForegroundColor Yellow ("Setting 5 minute restart timer...")
    shutdown.exe /r /f /t 300 /c "Restart scheduled in 5 mins for server maintenance."
    Write-Host -ForegroundColor Green ("Done!!!")
} else {
    Write-Host -ForegroundColor Yellow("Restart is required for changes to take effect.")
}