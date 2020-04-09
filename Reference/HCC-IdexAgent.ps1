#*******************************************************************************
#* Hampshire County Council - Corporate Services
#* 
#* File:			HCC-IdexAgent.ps1
#* Date:			03/07/2019
#* Creator:			HPSN2.1 Project Team  (01962 847007)
#* Purpose:			HCC Proxy Authentication,IdexAgent Options & Keytab Creation. 
#* Usage:			HCC Smoothwall Proxy Authentication. 
#* Version:			v1.0
#* Technology:		Powershell V3 and above.
#* Requirements		Windows Server, 2008 R2, 2012, 2016. IDexAgent V2_1.
#* History:			N/A
#*******************************************************************************

# Declare Variables
$SendAdDataSchedule = "03:00"
$IDExAgentKey = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\IDexAgent\Parameters"
$Logfile = "HCC-IdexAgent.log"
$ProxyAuthUser = "hccproxyauth"
$SmoothwallIDexVIP = "fwfidex.hiow.gov.uk"
$SmoothwallAuthVIP = "cache.hiow.gov.uk"
$SmoothwallAuthVIP2 = "proxy.hiow.gov.uk"
$SmoothwallAuthVIP3 = "cache.hants.gov.uk"
$KeytabTempFile1 = "-temp.keytab"
$KeytabTempFile2 = "-temp2.keytab"
$KeytabFile = "-proxy.keytab"
$destinationPort = 2948
$Time = 5000 
$ErrorFlag = "False"

# Functions
#----------------------------------------------------------------------------------------------------------------------------------
Function CheckTCPPortStatus
{
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$IPAddress,
    [Parameter(Mandatory=$True,Position=2)]
    [string]$Port,
    [Parameter(Mandatory=$True,Position=3)]
    [int]$Timeout
)
    $TCPObject = new-Object system.Net.Sockets.TcpClient
    if($TCPObject.ConnectAsync($IPAddress,$Port).Wait($Timeout))
    {
        $TCPObject.Close()
       # return "Open"
        Write-Output "$(Get-Date -format g) :IDEX Server  $IPAddress : $Port TRUE "  | Out-file $Logfile -append
    }
    else
    {
        $TCPObject.Close()
        # return "Closed or Filtered"
        Write-Output "$(Get-Date -format g) :IDEX Server  $IPAddress : $Port FALSE "  | Out-file $Logfile -append
    }
}
#----------------------------------------------------------------------------------------------------------------------------------
# Main Code

Write-Output "$(Get-Date -format g) :IDex Agent Start" | Out-file $Logfile -append
Write-Output "$(Get-Date -format g) :Powershell Version $($psversiontable.psversion.major)" | Out-file $Logfile -append
try {
        Import-Module ActiveDirectory
        Write-Output "$(Get-Date -format g) :Active Directory Module Installed" | Out-file $Logfile -append
    } 
catch 
    {
        Write-Output "$(Get-Date -format g) :Active Directory Module Missing -ERROR-" | Out-file $Logfile -append
        Exit
    }
$SchoolName = Read-Host "Please enter the School Name:-"
Write-Output "$(Get-Date -format g) :School Name : $SchoolName " | Out-file $Logfile -append
[int]$DFE = Read-Host "Please enter the School DFE\DCSF Number:-"
Write-Output "$(Get-Date -format g) :School DFE\DCSF : $DFE" | Out-file $Logfile -append
$KeytabFile = "Auth" + $DFE.Tostring() + $KeytabFile
$KeytabTempFile1 = "Auth" + $DFE.Tostring() + $KeytabTempFile1
$KeytabTempFile2 = "Auth" + $DFE.Tostring() + $KeytabTempFile2
Write-Output "$(Get-Date -format g) :School Keytab FileName : $KeytabFile" | Out-file $Logfile -append
Switch($DFE)
{
    {$_ -ge 1000 -and $_ -le 2018} {$SendAdDataSchedule = "01:00"}
    {$_ -ge 2019 -and $_ -le 2054} {$SendAdDataSchedule = "01:15"}
    {$_ -ge 2055 -and $_ -le 2116} {$SendAdDataSchedule = "01:30"}
    {$_ -ge 2117 -and $_ -le 2202} {$SendAdDataSchedule = "01:45"}
    {$_ -ge 2203 -and $_ -le 2256} {$SendAdDataSchedule = "02:00"}
    {$_ -ge 2257 -and $_ -le 2304} {$SendAdDataSchedule = "02:15"}
    {$_ -ge 2305 -and $_ -le 2345} {$SendAdDataSchedule = "02:30"}
    {$_ -ge 2346 -and $_ -le 2516} {$SendAdDataSchedule = "02:45"}
    {$_ -ge 2517 -and $_ -le 2723} {$SendAdDataSchedule = "03:00"}
    {$_ -ge 2724 -and $_ -le 3014} {$SendAdDataSchedule = "03:15"}
    {$_ -ge 3015 -and $_ -le 3120} {$SendAdDataSchedule = "03:30"}
    {$_ -ge 3121 -and $_ -le 3191} {$SendAdDataSchedule = "03:45"}
    {$_ -ge 3192 -and $_ -le 3392} {$SendAdDataSchedule = "04:00"}
    {$_ -ge 3393 -and $_ -le 3671} {$SendAdDataSchedule = "04:15"}
    {$_ -ge 3672 -and $_ -le 7053} {$SendAdDataSchedule = "04:30"}
    {$_ -ge 7054 -and $_ -le 9999} {$SendAdDataSchedule = "04:45"}
}

# Read & Update the current IDexAgent Paramaters.
if (Get-ItemProperty $IDExAgentKey -ErrorAction SilentlyContinue)
    {
        If (Get-ItemProperty $IDExAgentKey -Name SmoothwallIPAddr) {Write-Output "$(Get-Date -format g) :Smoothwall Address: $((Get-ItemProperty $IDExAgentKey -Name SmoothwallIPAddr).SmoothwallIPAddr)" | Out-file $Logfile -append}
        If (Get-ItemProperty $IDExAgentKey -Name SmoothwallPort) {Write-Output "$(Get-Date -format g) :Smoothwall Port: $((Get-ItemProperty $IDExAgentKey -Name SmoothwallPort).SmoothwallPort)" | Out-file $Logfile -append}
        If (Get-ItemProperty $IDExAgentKey -Name SendAdDataSchedule) {Write-Output "$(Get-Date -format g) :Smoothwall Send Time: $((Get-ItemProperty $IDExAgentKey -Name SendAdDataSchedule).SendAdDataSchedule)" | Out-file $Logfile -append}
        if (((Get-ItemProperty $IDExAgentKey -Name SendAdDataSchedule).SendAdDataSchedule) -ne  $SendAdDataSchedule) 
            {
                # Update Send Schedule for School.
                set-ItemProperty $IDExAgentKey -Name SendAdDataSchedule -Value $SendAdDataSchedule -ErrorAction SilentlyContinue
                Write-Output "$(Get-Date -format g) :Smoothwall Updated Send Time: $((Get-ItemProperty $IDExAgentKey -Name SendAdDataSchedule).SendAdDataSchedule)" | Out-file $Logfile -append
            }
        if (-not(Get-ItemProperty $IDExAgentKey -Name DisableMonitorLogons -ErrorAction SilentlyContinue )) 
            {
                # Create Registry Key to Disable Monitor Logons.
                New-ItemProperty $IDExAgentKey -Name DisableMonitorLogons -Value 1  -PropertyType DWORD -Force | Out-Null
                Write-Output "$(Get-Date -format g) :Updated Disable Monitor Logons: $((Get-ItemProperty $IDExAgentKey -Name DisableMonitorLogons).DisableMonitorLogons)" | Out-file $Logfile -append
            }
        if (Get-Service "IDexAgent" -ErrorAction SilentlyContinue) 
            {
                if ((Get-Service -Name "IDexAgent").Status -eq 'Running')
                {
                # Restart IDEXAgent Service
                Write-Output "$(Get-Date -format g) :Restarting Service IDexAgent " | Out-file $Logfile -append
                Get-Service -Name "IDexAgent" | restart-Service -ErrorAction SilentlyContinue
                if ((Get-Service -Name "IDexAgent").Status -eq 'Running') {Write-Output "$(Get-Date -format g) :Successfully Restarted Service IDexAgent " | Out-file $Logfile -append}
                }
            }
    }
    else 
    {
        Write-Host "IDEXAgent is Not Installed, Please install and run again"
        $ErrorFlag = "True"
        Write-Output "$(Get-Date -format g) :IDEXAgent Is Not Installed Exiting. Error Flag = $ErrorFlag " | Out-file $Logfile -append
    }

if ($ErrorFlag -eq "False")
    {    
        Write-Output "$(Get-Date -format g) :UPN Section Start" | Out-file $Logfile -append
        $Forest = Get-ADDomain | select-object -ExpandProperty Forest
        Write-Output "$(Get-Date -format g) :School Forest FQDN: $Forest" | Out-file $Logfile -append
        $upn = Get-ADUser -Filter * -Properties userPrincipalName |where-object {$_.userPrincipalName -ne $null}|Select-Object -ExpandProperty UserprincipalName
        $upnMatch = $upn -like '*'+$Forest
        $upnMatchNumb = $upnMatch.count
        Write-Output "$(Get-Date -format g) :UPN Matched : $Forest  = $upnMatchNumb"  | Out-file $Logfile -append
        $upnNotMatch = $upn -notlike '*'+$Forest
        if ($upnNotmatch.count -gt 0 ) 
            {
                $MultipleUPN = $upnNotMatch[1].substring($upnNotMatch[1].IndexOf("@"),$upnNotMatch[1].length - $upnNotMatch[1].IndexOf("@"))
                $upnNotMatchNumb = $upnNotmatch.count
                Write-Output "$(Get-Date -format g) :UPN UnMatched : $MultipleUPN  =  $upnNotMatchNumb"  | Out-file $Logfile -append
                Write-Output "$(Get-Date -format g) :Multiple UPN's Detected & Different from Forest UPN : Keytab Not Created -ERROR-"  | Out-file $Logfile -append
            }
            else    
                    {
                        if ($upnMatchNumb -gt 0)
                            {
                                if ((Get-ADUser -Filter {sAMAccountName -eq $ProxyAuthUser} -ErrorAction SilentlyContinue) -and (Get-ADUser -Filter {cn -eq $ProxyAuthUser} -ErrorAction SilentlyContinue))
                                    {
                                        if ((get-aduser -filter {sAMAccountName -eq $ProxyAuthUser} -properties Name, PasswordNeverExpires).passwordneverexpires) {Write-Output "$(Get-Date -format g) :Service Account $ProxyAuthUser Password Never Expires: True"  | Out-file $Logfile -append}
                                        else {Write-Output "$(Get-Date -format g) :Service Account $ProxyAuthUser Password Never Expires: False -ERROR-"  | Out-file $Logfile -append}
                                        if ((get-aduser -filter {sAMAccountName -eq $ProxyAuthUser} -properties Name, CannotChangePassword).CannotChangePassword) {Write-Output "$(Get-Date -format g) :Service Account $ProxyAuthUser Cannot Change Password: True"  | Out-file $Logfile -append}
                                        else {Write-Output "$(Get-Date -format g) :Service Account $ProxyAuthUser Cannot Change Password: False -ERROR-"  | Out-file $Logfile -append}
                                        $SetspnVar = "HTTP/"+$SmoothwallAuthVIP+"@"+$forest.toupper()
                                        $SetspnVar2 = "HTTP/"+$SmoothwallAuthVIP2+"@"+$forest.toupper()
                                        $SetspnVar3 = "HTTP/"+$SmoothwallAuthVIP3+"@"+$forest.toupper()
                                        Write-Output "$(Get-Date -format g) :SPN String $setspnVar"  | Out-file $Logfile -append
                                        Write-Output "$(Get-Date -format g) :SPN String $setspnVar2"  | Out-file $Logfile -append
                                        Write-Output "$(Get-Date -format g) :SPN String $setspnVar3"  | Out-file $Logfile -append
                                        Invoke-Expression " setspn -U -A $SetspnVar $ProxyAuthUser " -ErrorAction SilentlyContinue
                                        Invoke-Expression " setspn -U -A $SetspnVar2 $ProxyAuthUser " -ErrorAction SilentlyContinue
                                        Invoke-Expression " setspn -U -A $SetspnVar3 $ProxyAuthUser " -ErrorAction SilentlyContinue
                                        Write-Output "$(Get-Date -format g) :SPN Record Created $(Invoke-Expression " setspn -U -L $ProxyAuthUser " -ErrorAction SilentlyContinue)"  | Out-file $Logfile -append
                                        # Create Keytab.
                                        Write-Output "$(Get-Date -format g) :Keytab File Created $SetspnVar $(Invoke-Expression "ktpass -princ $setspnVar -mapuser $ProxyAuthUser +rndPass -out $KeytabTempFile1 -ptype KRB5_NT_PRINCIPAL" -ErrorAction SilentlyContinue)"  | Out-file $Logfile -append
                                        Write-Output "$(Get-Date -format g) :Keytab File Created $SetspnVar2 $(Invoke-Expression "ktpass -princ $setspnVar2 -mapuser $ProxyAuthUser +rndPass -in $KeytabTempFile1 -out $KeytabTempFile2 -ptype KRB5_NT_PRINCIPAL" -ErrorAction SilentlyContinue)"  | Out-file $Logfile -append
                                        Write-Output "$(Get-Date -format g) :Keytab File Created $SetspnVar3 $(Invoke-Expression "ktpass -princ $setspnVar3 -mapuser $ProxyAuthUser +rndPass -in $KeytabTempFile2 -out $KeytabFile -ptype KRB5_NT_PRINCIPAL" -ErrorAction SilentlyContinue)"  | Out-file $Logfile -append
                                        # Remove temp Keytab Files
                                        Write-Output "$(Get-Date -format g) :Remove TempKeytabFile $KeytabTempFile1 $(remove-item "$KeytabTempFile1" -erroraction silentlycontinue)"  | Out-file $Logfile -append
                                        Write-Output "$(Get-Date -format g) :Remove TempKeytabFile $KeytabTempFile2 $(remove-item "$KeytabTempFile2" -erroraction silentlycontinue)"  | Out-file $Logfile -append
                                    }
                                else 
                                    {
                                        $ErrorFlag = "True"
                                        Write-Output "$(Get-Date -format g) :AD User $ProxyAuthUser Does not exist or match CN Error Flag $ErrorFlag  -ERROR-"  | Out-file $Logfile -append
                                        Write-Output "$(Get-Date -format g) :AD User sAMAccountName:" (Get-ADUser -Filter {sAMAccountName -eq $ProxyAuthUser} -ErrorAction SilentlyContinue) | Out-file $Logfile -append                                        
                                    }
                            }
                    }
        Write-Output "$(Get-Date -format g) :UPN Section Stop" | Out-file $Logfile -append
    }
# Check VIP Port and Operating System
Write-Output "$(Get-Date -format g) :IDex VIP & Port Section Start"  | Out-file $Logfile -append
$OSystem = (Get-WmiObject Win32_OperatingSystem).Caption
Write-Output "$(Get-Date -format g) :Operating System : $OSystem"  | Out-file $Logfile -append
Switch ($OSystem)
    {
        {$_ -like "*Windows Server 2008*"} {CheckTCPPortStatus $SmoothwallIDexVIP $destinationPort $Time} 
        {$_ -like "*Windows Server 2012*" -or $_ -like "*Windows Server 2016*"  }
            {
                $Result = Test-netconnection -computername $SmoothwallIDexVIP -port $destinationPort | select-object -ExpandProperty tcptestsucceeded
                Write-Output "$(Get-Date -format g) :IDex Server  $SmoothwallIDexVIP : $destinationPort : $Result"  | Out-file $Logfile -append 
            }
    }
Write-Output "$(Get-Date -format g) :IDex VIP & Port Section Stop"  | Out-file $Logfile -append
Write-Output "$(Get-Date -format g) :IDEX Agent SendAdData $(Invoke-Expression "& 'C:\Program Files\Smoothwall\IDexAgent\SendAdDataNow.exe'" -ErrorAction SilentlyContinue)"  | Out-file $Logfile -append
Write-Output "$(Get-Date -format g) :IDex Agent Stop" | Out-file $Logfile -append