$A1Staff = Get-ADGroupMember -Identity "Staff_o365_A1_Licensed"

$DisabledUsers = foreach ($staff in $A1Staff) {Get-ADUser -Identity $staff.SamAccountName -Properties * | Where-Object Enabled -eq $False}

$DisabledUsers | Select-Object SamAccountName,Name,Enabled,whenChanged | Export-Csv -Path DisabledA1Staff.csv -NoTypeInformation -NoClobber -Force