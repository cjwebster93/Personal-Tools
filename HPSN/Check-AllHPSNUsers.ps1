#Contants
$RootFilePath = "C:\AgileICT\UPNCheck"

#Logging
#$LogRootPath = Get-Location
$LogPath = ("$RootFilePath\" + $env:USERDOMAIN + '_UPNCheck.log')
Write-Host('Transcript log file will be: ' + $LogPath)
Start-Transcript -Path $LogPath -Append

#Get Domain
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain();
$dcs    = $domain -Split "\@";

$Verify = Read-Host ("Detected domain is $dcs. Is that correct? (Y/N)")
if ($Verify -eq 'N') {
    $dcs = Read-Host ("Please enter correct UPN (excluding '@')")
    if ($dcs -contains '@') {
        $dcs = $dcs -Split "\@"
    }
}
#Build our filter
$Filter = "UserPrincipalName -notlike ""*@"  + $dcs + '"'
Write-Host ("Checking for users not matching the UPN: $dcs")

#Force update all AD users to correct UPN
$UserList = Get-ADUser -Filter $Filter
Write-Host -ForegroundColor Yellow ("Users to change:")
$UserList

#Carry out changes
ForEach ($user in $UserList) {
    Set-ADUser -Identity $user.SamAccountName -UserPrincipalName (($user.SamAccountName) + '@' + $dcs);
    Write-Host -ForegroundColor Green ("Written changes for " + $user.Name);
    }
Stop-Transcript