
<#
###   RUN THIS SCRIPT FROM EITHER OF THE SCHOOL'S DCs   ###
#>

#Update this to the requred cohort year
$leaverYear = 2026


$leaverDir = "\\Prs-fp01\users\PUPIL\$leaverYear"
$leaverProf = "\\Prs-fp01\PupilProfiles$"

$Users = Get-ADUser -SearchBase "OU=$leaverYear Leavers,OU=Pupil,OU=PR,DC=portregis,DC=com" -Filter *

foreach ($user in $Users) {
    $userName =  $user.UserPrincipalName.split("@")[0]
    $homeDir = "\\Prs-fp01\users\PUPIL\$leaverYear\$userName"
    
    if (!(Test-Path -Path $homeDir)) {
        Write-Host -ForegroundColor Yellow ("Home dir not found for $userName. Creating....")
        New-Item -Path "$leaverDir" -Name $userName -ItemType "directory"

        #Add user permissions
        $ACL = Get-ACL -Path $homeDir
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$userName","Modify",'ContainerInherit,ObjectInherit', 'None',"Allow")
        $ACL.SetAccessRule($AccessRule)
        $ACL | Set-Acl -Path $homeDir
        (Get-ACL -Path $homeDir).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

        #Create subfolders
        New-Item -Path "$homeDir" -Name "Documents" -ItemType "directory"
        New-Item -Path "$homeDir" -Name "Downloads" -ItemType "directory"
        New-Item -Path "$homeDir" -Name "Favorites" -ItemType "directory"
        New-Item -Path "$homeDir" -Name "Pictures" -ItemType "directory"
        New-Item -Path "$homeDir" -Name "Music" -ItemType "directory"
    } else {
        Write-Host -ForegroundColor Green ("Home directory for $userName already exists.")
    }

    $profDir = "\\Prs-fp01\PupilProfiles$\$userName"
    if (!(Test-Path -Path $profDir)) {
        Write-Host -ForegroundColor Yellow ("Profile dir not found for $userName. Creating....")
        New-Item -Path "$leaverProf" -Name $userName -ItemType "directory"

        #Add user permissions
        $ACL = Get-ACL -Path $profDir
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("$userName","Modify",'ContainerInherit,ObjectInherit', 'None',"Allow")
        $ACL.SetAccessRule($AccessRule)
        $ACL | Set-Acl -Path $profDir
        (Get-ACL -Path $profDir).Access | Format-Table IdentityReference,FileSystemRights,AccessControlType,IsInherited,InheritanceFlags -AutoSize

        #Create subfolders
        New-Item -Path "$profDir" -Name "AppData" -ItemType "directory"
        New-Item -Path "$profDir" -Name "Desktop" -ItemType "directory"
        New-Item -Path "$profDir" -Name "Start Menu" -ItemType "directory"
    } else {
        Write-Host -ForegroundColor Green ("Profile directory for $userName already exists.")
    }
}