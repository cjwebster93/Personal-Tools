# Define group names
$sourceGroup = "Staff_o365_A3_Licensed"
$targetGroup = "Staff_o365_A1_Licensed"

# Define the OU to limit the scope
$ouDN = "OU=Staff_Leavers,OU=Staff,OU=PR,DC=portregis,DC=com"

# Define log file path
$logDir = ".\log"
$logFile = Join-Path $logDir "AD_Group_Changes_$(Get-Date -Format 'yyyyMMdd').txt"

# Ensure log directory exists
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir | Out-Null
}

# Function to write to log
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logFile -Append
}

# Get all members of the source group
$groupMembers = Get-ADGroupMember -Identity $sourceGroup -Recursive | Where-Object { $_.objectClass -eq 'user' }

foreach ($member in $groupMembers) {
    $user = Get-ADUser -Identity $member.DistinguishedName -Properties Enabled, DistinguishedName

    if (-not $user.Enabled -and $user.DistinguishedName -like "*$ouDN") {
        try {
            Remove-ADGroupMember -Identity $sourceGroup -Members $user -Confirm:$false
            Write-Log "Removed $($user.SamAccountName) from $sourceGroup"

            Add-ADGroupMember -Identity $targetGroup -Members $user
            Write-Log "Added $($user.SamAccountName) to $targetGroup"
        }
        catch {
            Write-Log "Error processing $($user.SamAccountName): $_"
        }
    }
}
