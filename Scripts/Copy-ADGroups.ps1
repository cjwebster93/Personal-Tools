<#
### Copy groups from source user to another target user ###
#>


param (
    [Parameter(Mandatory)]
    [string]$SourceUser,

    [Parameter(Mandatory)]
    [string]$TargetUser
)

$Groups = Get-ADPrincipalGroupMembership $SourceUser | select SamAccountName

$currentGroups = Get-ADPrincipalGroupMembership $TargetUser | select SamAccountName
foreach ($group in $Groups) {
    
    $groupName = $group.SamAccountName

    if ($currentGroups.SamAccountName -notcontains $groupName) {
        
        Write-Host ("Adding to group $groupName")
        Add-ADGroupMember -Identity $groupName -Members $TargetUser
    } else {
        Write-Host -ForegroundColor Yellow ("Error adding to $groupName, they may already be a member.")
    }
}