# Import the AzureAD module
Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Specify the name of the Azure group you want to remove members from
$groupName = "GroupName"

# Get the members of the Azure group
$groupMembers = Get-AzureADGroupMember -ObjectId (Get-AzureADGroup -SearchString $groupName).ObjectId

# Loop through each member and remove them from the Exchange Global Address List
foreach ($member in $groupMembers) {
    $userPrincipalName = $member.UserPrincipalName

    # Set the HiddenFromAddressListsEnabled property in Exchange
    Set-Mailbox -Identity $userPrincipalName -HiddenFromAddressListsEnabled $true

    # Set the msExchHideFromAddressLists attribute in Active Directory
    $userDN = (Get-ADUser -Filter {UserPrincipalName -eq $userPrincipalName}).DistinguishedName
    Set-ADUser -Identity $userDN -Replace @{msExchHideFromAddressLists=$true}
}
