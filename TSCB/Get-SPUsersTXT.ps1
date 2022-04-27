
Import-Module Microsoft.Online.SharePoint.PowerShell
Import-Module PnP.PowerShell



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
    Get-SPOUser -Site $site.Url  | Select-Object -Property DisplayName,LoginName,UserType,IsSiteAdmin > `
        "$ReportDir\$SiteName.txt"
}
#Disconnect from SPO
Disconnect-SPOService