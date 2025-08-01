<#
### Script to populate an AD group based on folders named by username ###
# Adjust $SharePath and $ADGroup as required #
# Craig Webster @ Blueloop LTD
#>

$SharePath = "\\prs-fp01\USERS\STAFF"
$ADGroup = "StaffFolderRedirection"

$Users = (Get-ChildItem -Directory -Path $SharePath).Name

$CurrentMembers = (Get-ADGroupMember -Identity $ADGroup).SamAccountName


foreach ($user in $Users) {
    
    if (Get-ADUser -Identity $user -ErrorAction SilentlyContinue) {
        if ($CurrentMembers -notcontains $user) {
            Add-ADGroupMember -Identity $ADGroup -Members $user
            Write-Host -ForegroundColor Green("Added $user to group $ADGroup!")
        }
        else {
            Write-Host ("User $user already added to group $ADGroup")
        }
        
    }
    else {
        Write-Host -ForegroundColor Yellow ("User $user not found")
    }
    
}
