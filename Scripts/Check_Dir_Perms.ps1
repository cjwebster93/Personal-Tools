<#
###   RUN THIS SCRIPT FROM EITHER OF THE SCHOOL'S DCs   ###

CURRENTLY BROKEN
#>

#Update this to the requred cohort year
$leaverYear = 2024


$leaverDir = "\\Prs-fp01\users\PUPIL\$leaverYear"
$leaverProf = "\\Prs-fp01\PupilProfiles$"

$Users = Get-ADUser -SearchBase "OU=$leaverYear Leavers,OU=Pupil,OU=PR,DC=portregis,DC=com" -Filter *

foreach ($user in $Users) {
    $userName = $user.UserPrincipalName.split("@")[0]
    $homeDir = "\\Prs-fp01\users\PUPIL\$leaverYear\$userName"

    if ((Test-Path -Path $homeDir)) {
        Write-Host "Checking permissions on $homeDir"
        $ACL = Get-ACL -Path $homeDir
        $userAccessExists = $false
        
        # Check if an access rule for $userName already exists
        foreach ($accessRule in $ACL.Access) {
            if ($accessRule.IdentityReference.Value -eq $userName) {
                $userAccessExists = $true
            }
        }
            
        if ($userAccessExists -eq $false) {
            $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$userName", "Modify", 'ContainerInherit,ObjectInherit', 'None', "Allow")
            $ACL.SetAccessRule($AccessRule)
            $ACL | Set-Acl -Path $homeDir
            Write-Host -ForegroundColor Yellow "Permissions added for $userName on $homeDir"
        }
        else {
            Write-Host -ForegroundColor Green "Permissions for $userName already exist on $homeDir"
        }
    } else {
        Write-Host -ForegroundColor DarkRed "Home directory for $userName not found!"
    }
    

    $profDir = "\\Prs-fp01\PupilProfiles$\$userName"
    if ((Test-Path -Path $profDir)) {
        Write-Host "Checking permissions on $profDir"
        $ACL = Get-ACL -Path $profDir
        $userAccessExists = $false

        # Check if an access rule for $userName already exists
        foreach ($accessRule in $ACL.Access) {
            if ($accessRule.IdentityReference.Value -eq $userName) {
                $userAccessExists = $true
            }
        }
        
        if ($userAccessExists -eq $false) {
            $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$userName", "Modify", 'ContainerInherit,ObjectInherit', 'None', "Allow")
            $ACL.SetAccessRule($AccessRule)
            $ACL | Set-Acl -Path $profDir
            Write-Host -ForegroundColor Yellow "Permissions added for $userName on $profDir"
        }
        else {
            Write-Host -ForegroundColor Green "Permissions for $userName already exist on $profDir"
        }
    } else {
        Write-Host -ForegroundColor DarkRed "Profile directory not for $userName found!"
    }
}