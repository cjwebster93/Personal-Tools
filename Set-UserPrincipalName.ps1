# MAKE SURE YOU UPDATE THE SCHOOL'S DOMAIN INFO IN THIS COMMAND BFORE RUNNING
# Used to batch update the UPN suffix on a schools Active Directory
Get-ADuser -Filter * | foreach-object {Set-ADUser -Identity $_.SamAccountName -UserPrincipalName (($_.SamAccountName) + "@SCH[DFE Here].hants.sch.uk")}