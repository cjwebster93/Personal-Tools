#Checks user AD information for compatibility with HPSN Smoothwall filtering

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

#Loop to be inserted here to handle user lists

#Get the user information, particularly UPN and Group Memberships
$userinfo = $null

While (!$userinfo) {
    #This will be removed when user input is automated...
    $user = Read-Host -Prompt 'Which user do we need to check? Enter their username'.ToLower()
    
    try {
        $userinfo = Get-ADUser -Identity $user -Properties UserPrincipalName, MemberOf;
    } catch {
        Write-Host("User not found.")
    }
}

#Check UPN
$UPNcheck = ($userinfo.SamAccountName + "@$dcs")

if ($userinfo.UserPrincipalName -cnotmatch $UPNcheck) {
    Set-ADUser -Identity $userinfo.SamAccountName -UserPrincipalName (($userinfo.SamAccountName) + '@' + $dcs);
    Write-Host('UserPricipalName updated to ' + $userinfo.SamAccountName + '@' + $dcs)
} else {
    Write-Host('UserPricipalName is correct!')
}

#Check user groups