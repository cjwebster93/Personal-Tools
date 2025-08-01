### Get-Mailbox | Set-MailboxMessageConfiguration -DefaultFontName Canto -DefaultFontSize 12 -DefaultFontColor '#002060'

#Logfile Location
$PathToLogFile = "\\prs-dc02\c$\IT_Support\PS Commands\OutlookSettings\Logs"
$LogFile = "$PathToLogFile\OutlookSettings-$(Get-Date -Format "yyyy-MM-dd_HHmm").txt"
$PasswordKey = "C:\IT_Support\PS Commands\Azure\PW\PW.key"

# Function to Timestamp Log File Entries
function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

#Condition - create Log folder if it doesn't exist
if ( !(test-path $PathToLogFile)) {
    new-item $PathToLogFile -type directory -Force
    Write-Output "$(Get-TimeStamp) -- Start Logging: Logs Folder being created (PathToLogFile) : $PathToLogFile " | Out-file $LogFile -append
} ELSE {
#Because the folder already exists - Check and Delete old log file
if ( !(test-path $LogFile)) {
    Write-Output "$(Get-TimeStamp) -- Start Logging: Folder existed but not a file, so new one created! : $LogFile " | Out-file $LogFile -append
   } ELSE {
    #File already exists so deleting it
    Remove-Item $LogFile -Force
    Write-Output "$(Get-TimeStamp) -- Start Logging: Logs Folder & File already exists, old file deleted! : $PathToLogFile " | Out-file $LogFile -append
   }
}

##########################################################
## Checking Modules Are installed and Loading up if not ##
##########################################################
Write-Output "$(Get-TimeStamp) -- ----------------------------------------- --" | Out-file $LogFile -append
Write-Output "$(Get-TimeStamp) --  Checking Required Modules are installed  --" | Out-file $LogFile -append
Write-Output "$(Get-TimeStamp) -- ----------------------------------------- --" | Out-file $LogFile -append

If (!(Get-module ExchangeOnlineManagement )) {
    Write-Output "$(Get-TimeStamp) -- ExchangeOnlineManagement Module NOT detected " | Out-file $LogFile -append
      Import-Module ExchangeOnlineManagement
    Write-Output "$(Get-TimeStamp) -- ExchangeOnlineManagement Module import command processed " | Out-file $LogFile -append
      Clear-Host
      } else {
    Write-Output "$(Get-TimeStamp) -- ExchangeOnlineManagement Module detected " | Out-file $LogFile -append
    }


### Main Script ###

$DefaultFontName = 'Canto'
$DefaultFontSize = 12
$DefaultfontColour = '#002060'

Write-Output "$(Get-TimeStamp) -- Current Settings are: $DefaultFontName, Size $DefaultFontSize in colour $DefaultFontColour."

$TenantUname = "o365admin@portregisschool.onmicrosoft.com"
#$TenantUname = "blueloop@portregis.com"
Write-Output "$(Get-TimeStamp) -- Tenant Username variable set ( $TenantUname )" | Out-file $LogFile -append
$TenantPass = cat "C:\IT_Support\PS Commands\Azure\PW\PW.key" | ConvertTo-SecureString
Write-Output "$(Get-TimeStamp) -- Tenant User Password set (encrypted) ( $TenantPass )  --" | Out-file $LogFile -append
$TenantCredentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $TenantUname, $TenantPass
Write-Output "$(Get-TimeStamp) -- Tenant Credentials variable set           --" | Out-file $LogFile -append

#Connect to Exchange Online
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Connect-ExchangeOnline -Credential $TenantCredentials | Out-file $LogFile -append
Write-Output "$(Get-TimeStamp) -- Connection to ExchangeOnline initiated           --" | Out-file $LogFile -append

#Get all mailboxes and set the following attributes on all
Get-Mailbox | Set-MailboxMessageConfiguration -DefaultFontName $DefaultFontName -DefaultFontSize $DefaultFontSize -DefaultFontColor $DefaultfontColour
Write-Output "$(Get-TimeStamp) -- All mailbox settings updated!                    --"

#Disconnect
Disconnect-ExchangeOnline