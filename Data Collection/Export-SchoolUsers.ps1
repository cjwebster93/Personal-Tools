$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain();
$domain = $domain -split '\.'

$searchBase = 'OU=Users,OU=School,DC='+ $domain[0] + ',DC=' + $domain[1] + ',DC=sch,DC=uk'

$AllADUsers = Get-ADUser `
-searchbase $searchBase `
-Filter * -Properties * | Where-Object {$_.info -NE 'Migrated'} #ensures that updated users are never exported.

$AllADUsers |
Select-Object @{Label = "First Name";Expression = {$_.GivenName}},
@{Label = "Last Name";Expression = {$_.Surname}},
@{Label = "Display Name";Expression = {$_.DisplayName}},
@{Label = "Logon Name";Expression = {$_.sAMAccountName}},
@{Label = "Account Status";Expression = {if (($_.Enabled -eq 'TRUE')  ) {'Enabled'} Else {'Disabled'}}} | `

Export-Csv -Path C:\Users.csv -NoTypeInformation