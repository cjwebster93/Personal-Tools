#Constants
$HantsDNS = "172.26.1.41"
$DNSSearch = "*.16"

$LogName = "DNS_Changes.log"
#Functions
Function Set-SecondaryDNS
{
    param (
        [Parameter(Position=0, Mandatory=$TRUE)]
        [string]$InterfaceIndex
    )
    $DNS = Get-DnsClientServerAddress -InterfaceIndex $InterfaceIndex | Select ServerAddresses
    #$DNS = $DNS[0].ServerAddresses + ", $HantsDNS"
    $DNS = $DNS[0].ServerAddresses -join ", "
    $DNSString = ($DNS, $HantsDNS) -join ", "
    Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex  -ServerAddresses $DNS -Verbose
    Write-Host -ForegroundColor Green ("Secondary DNS added to $InterfaceIndex.")
}

#Logging
$LogRootPath = Get-Location
$LogPath = ("$LogRootPath\" + $LogName)
Write-Host('Transcript log file will be: ' + $LogPath)
Start-Transcript -Path $LogPath -Append

#Select NICs with local DNS server set
Write-Host -ForegroundColor Yellow ("Looking for NICs with local DC IP set as DNS (xx.xx.xx.16)...")
$Nics = Get-DnsClientServerAddress | Where-Object -Property ServerAddresses -Like $DNSSearch

#For each one, add the Hants DNS as a secondary address
If ($Nics) {
    Foreach ($nic in $Nics)
    {
        $NicIndex = $nic.CimInstanceProperties | Where-Object Name -eq "InterfaceIndex" | Select -ExpandProperty Value
        Write-Host ("NIC with index $NicIndex selected...")
        Write-Host ("Setting secondary DNS on Nic with Index $NicIndex")
        Set-SecondaryDNS -InterfaceIndex $NicIndex
        }
}
else 
{
    Write-Host -ForegroundColor Yellow ("No matching NICs found, choose from one of the below options:")
    $List = (Get-DnsClientServerAddress | Select-Object InterfaceAlias,InterfaceIndex)
    Write-Host ($List)
    $Nics = Read-Host -Prompt ("Enter InterfaceIndex")
    Set-SecondaryDNS -Interfaceindex $Nics
}


Stop-Transcript