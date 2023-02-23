#Connect to Exchange Online
Connect-ExchangeOnline

#Create Arrays
$AccessList = [System.Collections.ArrayList]@()

#Get all maiboxes
$Mailboxes = Get-Mailbox;

#Get user to check for permissions
$User = Read-Host -Prompt "Enter the username of the user we're checking for in other people's calendars"

#Iterate through mailboxes looking for that user

foreach ($mailbox in $Mailboxes) {
    $Identity = $mailbox.UserPrincipalName + ":\Calendar"

    Write-Host -ForegroundColor Yellow ("Checking $Identity for $User permissions")
    $perms = Get-MailboxFolderPermission -Identity $Identity -User $User -ErrorAction SilentlyContinue

    if ($perms -ne $null) {
        $userFolder = $perms.Identity
        Write-Host -ForegroundColor Green ("Added $userFolder to list")
        $AccessList.Add($mailbox.Name)
    }
}

#Output AccessList
$AccessList

Disconnect-ExchangeOnline -Confirm