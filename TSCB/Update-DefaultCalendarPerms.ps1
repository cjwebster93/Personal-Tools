[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $AccessRights = 'AvailabilityOnly'
)


#Logging
$LogName = "CalendarPerms.log"
$LogRootPath = Get-Location
$LogPath = ("$LogRootPath\" + $LogName)
Write-Host('Transcript log file will be: ' + $LogPath)
Start-Transcript -Path $LogPath -Append

#Import Required Module
Try {
    Import-Module ExchangeOnlineManagement
} catch {
    Install-Module ExchangeOnlineManagement -AllowClobber -AcceptLicense -Force
    Import-Module ExchangeOnlineManagement
}

#Connect to Exchange Online
Write-Host ("Connecting to Exchange Online")
Connect-ExchangeOnline

#Get user calendars where Default user permission is NOT equal to $AccessRights variable

$allMailboxes = Get-User -RecipientTypeDetails UserMailbox

foreach ($user in $allMailboxes) {
    $name = $user.Name
    Write-Host ("Updating Default calendar permission for $name...")
    $cal = $user.Name+":\Calendar"
    try {
        Set-MailboxFolderPermission -Identity $cal -User Default -AccessRights $AccessRights
        Write-Host -ForegroundColor Green ("Updated Default permissions successfully!")
    } catch {
        Write-Host -ForegroundColor Red ("Error updating permissions for $name!")
    }
}


Stop-Transcript