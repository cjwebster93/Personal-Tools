<#
 # Make sure you have a Global Administrator account availble which is an owner on as many Sharepoint sites as possible.
 #By Craig Webster - The Silver Cloud Business
 #>

 #Import REquired Module
 Try {
     Import-Module Microsoft.Online.SharePoint.PowerShell
 } catch {
     Install-Module Microsoft.Online.SharePoint.PowerShell -AllowClobber -AcceptLicense -Force
     Import-Module Microsoft.Online.SharePoint.PowerShell
 }
 


#region ***Parameters***
$ReportDir="C:\Temp"
#endregion
$RootUrl = Read-Host -Prompt "Please enter the admin site URL e.g (https://xxxxxxx-admin.sharepoint.com)"

Connect-SPOService -Url $RootUrl
Write-Host ("Collecting SP site URLs...")
$Sites = Get-SPOSite -Filter {Url -like '*/sites/*'}
Write-Host ("Done!")

foreach ($site in $Sites) {
    $url = $site.Url -split "/"
    $SiteName = $url[$url.Count-1]
    Write-Host -ForegroundColor Yellow ($SiteName)
    Get-SPOUser -Site $site.Url  | Select-Object -Property DisplayName,LoginName,UserType,IsSiteAdmin | Export-Csv `
        "$ReportDir\$SiteName.csv" `
        -NoTypeInformation `
        -Force
}
#Disconnect from SPO
Disconnect-SPOService
Write-Host -ForegroundColor Green ("Reports can be found in $ReportDir")