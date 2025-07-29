[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
#Set the output file path
$FilePath = 'T:\NetInfo'
$FileName = $FilePath + '\NetInfo_' + $env:COMPUTERNAME + '_' + $env:USERNAME + '.txt'

#Get the logged on user
$LoggedUser = $env:USERNAME #Get-WMIObject -class Win32_ComputerSystem | select username
Write-Host($LoggedUser)

#Get computer IP
$IPAddr = (Get-NetIPAddress | where-object {$_.IPAddress -like '192.*'})[0].IPAddress.ToString()
Write-Host("IP Address: "+$IPAddr)

#Get time
$TimeStamp = Get-Date
Write-Host("Time: " + $TimeStamp)

$FileContents = @"
Logged on user: $LoggedUser
Computer IP: $IPAddr
$TimeStamp
"@
#Output our info file
If (-not (test-path -Path $FilePath -PathType Container)) {
    New-Item -Path $FilePath -ItemType Directory
}
Out-File -FilePath $FileName -InputObject $FileContents -Force

[System.Windows.Forms.MessageBox]::Show(
    "Information has been saved to $FilePath",
    "Complete",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)