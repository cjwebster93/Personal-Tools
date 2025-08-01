# Import the AzureAD module
Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Specify the name of the Azure group you want to remove members from
$groupName = "GroupName"

# Get the members of the Azure group
$groupMembers = Get-AzureADGroupMember -ObjectId (Get-AzureADGroup -SearchString $groupName).ObjectId

# Loop through each member and remove them from the Exchange Global Address List
foreach ($member in $groupMembers) {
    Set-Mailbox -Identity $member.UserPrincipalName -HiddenFromAddressListsEnabled $true
}
