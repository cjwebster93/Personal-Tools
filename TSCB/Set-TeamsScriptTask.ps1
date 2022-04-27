[CmdletBinding()]
param (
    [string]$ScriptName='Disable-TeamsGPUAcc-TTSpec.ps1',
    [string]$ScriptFolderPath='C:\TSCB\Scripts'
)

#Copy script to permenant location

Write-Host -ForegroundColor Yellow 'Check script is available in payload...'
if (Test-Path -Path ".\$ScriptName") {
    Write-Host -ForegroundColor Green 'Script found!'
    if (!(Test-Path -Path $ScriptFolderPath)) {
        Write-Host -ForegroundColor Yellow 'Creating Scripts Directory...'
        New-Item -ItemType Directory -Path $ScriptFolderPath
    }
    Write-Host -ForegroundColor Yellow 'Copying script to directory...'
    Copy-Item -Path $ScriptName -Destination $ScriptFolderPath -Force
    Write-Host -ForegroundColor Green 'Script Saved!'
}

#Create scheduled task for user logon

$trigger=New-ScheduledTaskTrigger -AtLogOn
$settings=New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
$action=New-ScheduledTaskAction -Execute "$ScriptFolderPath\$ScriptName"

Register-ScheduledTask -Action $action -Settings $settings -Trigger $trigger -TaskName "Apply Teams Settings" -Description "Checks and applys changes to desired Teams settings is required."