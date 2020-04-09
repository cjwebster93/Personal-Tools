#Checks user AD information for compatibility with HPSN Smoothwall filtering

$user = Read-Host -Prompt 'Which user do we need to check? Enter their username'

#Get Domain
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain();
$dcs    = $domain -Split "\@";

$userinfo = Get-ADUser -Identity $user -Properties UserPrincipalName, MemberOf;
Write-Host ($userinfo);

#Check UPN
$UPNcheck = ($userinfo.SamAccountName + "@$dcs")
$UPNcheck

if ($userinfo.UserPrincipalName -cnotmatch $UPNcheck) {
    Set-ADUser -Identity $userinfo.SamAccountName -UserPrincipalName (($user.SamAccountName) + '@' + $dcs);
    Write-Host('UserPricipalName updated to ' + $userinfo.SamAccountName + '@' + $dcs)
} else {
    Write-Host('UserPricipalName is correct!')
}