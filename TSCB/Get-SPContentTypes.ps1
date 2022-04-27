#Import Powershell modules
Import-Module Microsoft.Online.SharePoint.PowerShell
Import-Module PnP.PowerShell

#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
 
#Function to get the content type usage
Function Find-SPOContentTypeUsage([String]$SiteURL)
{
    Try{
        Write-host -f Yellow "Processing Site:" $SiteURL
 
        #Setup the context
        $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
        $Ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.Username, $Cred.Password)
     
        #Get All Lists of the Web
        $Ctx.Load($Ctx.Web)
        $Ctx.Load($Ctx.Web.Lists)
        $Ctx.Load($ctx.Web.Webs)
        $Ctx.ExecuteQuery()
        
        #Get site name
        $url = $site.Url -split "/"
        $SiteName = $url[$url.Count-1]

        #Generate Report Name
        $ReportOutput ="C:\Temp\$SiteName-ContentTypeUsage.csv"

        #Remove existing files
        if (Test-Path $ReportOutput) { Remove-Item $ReportOutput }

        #Get content types of each list from the web
        $ContentTypeUsages=@()
        ForEach($List in $Ctx.Web.Lists)
        {
            $ContentTypes = $List.ContentTypes
            $Ctx.Load($ContentTypes)
            $Ctx.Load($List.RootFolder)
            $Ctx.ExecuteQuery()
             
            #Get List URL
            If($Ctx.Web.ServerRelativeUrl -ne "/")
            {
                $ListURL=  $("{0}{1}" -f $Ctx.Web.Url.Replace($Ctx.Web.ServerRelativeUrl,''), $List.RootFolder.ServerRelativeUrl)
            }
            else
            {
                $ListURL=  $("{0}{1}" -f $Ctx.Web.Url, $List.RootFolder.ServerRelativeUrl)
            }
   
            #Get each content type data
            ForEach($CType in $ContentTypes)
            {
                $ContentTypeUsage = New-Object PSObject
                $ContentTypeUsage | Add-Member NoteProperty SiteURL($SiteURL)
                $ContentTypeUsage | Add-Member NoteProperty ListName($List.Title)
                $ContentTypeUsage | Add-Member NoteProperty ListURL($ListURL)
                $ContentTypeUsage | Add-Member NoteProperty ContentTypeName($CType.Name)
                $ContentTypeUsages += $ContentTypeUsage
            }
        }
        #Export the result to CSV file
        $ContentTypeUsages | Export-CSV $ReportOutput -NoTypeInformation -Append 
 
         #Iterate through each subsite of the current web and call the function recursively
        foreach ($Subweb in $Ctx.web.Webs)
        {
            #Call the function recursively to process all subsites underneaththe current web
            Find-SPOContentTypeUsage($Subweb.url)
        }
    }
    Catch {
    write-host -f Red "Error Generating Content Type Usage Report!" $_.Exception.Message
    }
}

#Get list of Sharepoint sites
Function Get-Sites($RootUrl) {
    Connect-SPOService -Url $RootUrl
    Write-Host ("Collecting SP site URLs...")
    $Sites = Get-SPOSite -Filter {Url -like '*/sites/*'}
    Write-Host ("Done!")
    return $Sites
}
  
 
#Fetch Sharepoint sites
$RootUrl = Read-Host -Prompt "Please enter the admin site URL e.g (https://xxxxxxx-admin.sharepoint.com)"

#Get Credentials to connect
$Cred= Get-Credential

$Sites=Get-Sites ($RootUrl)

#Call the function to get the content type usage
foreach ($Site in $Sites)
{
    Find-SPOContentTypeUsage($Site.Url)
}


#Read more: https://www.sharepointdiary.com/2017/04/sharepoint-online-find-content-type-usage-using-powershell.html#ixzz7RCILmTZ6

