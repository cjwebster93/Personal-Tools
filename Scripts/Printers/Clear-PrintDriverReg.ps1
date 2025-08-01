<#

    Script created to check for and remove third party drivers from the system - 
    useful for reinstalling printers from scratch via Group Policy.

    This ONLY removes the printer driver key from the registry, in order to trick it into reinstalling

    Use -CheckOnly to search for keys without removing them.

    Written by Craig Webster

 #>

 ### PARAMETERS AND MAIN VARIABLES ###
param ([switch] $CheckOnly=$false)

#Get administrattor status
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$elevated = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

#Array of paths
$Paths = @("HKLM:\\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows x64\Drivers\Version-3\", `
            "HKLM:\\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows x64\Drivers\Version-4\")

#Check V3 drivers
$V3Drivers = Get-ChildItem `
   -Path $Paths[0] | `
   Where-Object {`
       ($_.PSChildName -notlike "Cute*") -and `
       ($_.PSChildName -notlike "*Microsoft*")`
   } | Select-Object -Property Name, PSChildName

#Check V4 drivers
$V4Drivers = Get-ChildItem `
  -Path $Paths[1] | `
  Where-Object {`
      ($_.PSChildName -notlike "Cute*") -and `
      ($_.PSChildName -notlike "*Microsoft*")`
  } | Select-Object -Property Name, PSChildName

#Report back on found drivers (V3 & V4)
foreach ($driver in $V3Drivers) {
Write-Host ("Located $($driver.PSChildName)")
}
foreach ($driver in $V4Drivers) {
Write-Host ("Located $($driver.PSChildName)")
}
 

#Remove drivers if "CheckOnly" has been omitted, and only if any matching keys were found in the registry
If (!$CheckOnly -and ($V3Drivers -or $V4Drivers)) {
    If (!$elevated) {
        Write-Host -ForegroundColor Red ("Not running as Administrator!")
    } else {
        Write-Host -ForegroundColor Yellow ("Removing Drivers...")
        Foreach ($driver in $V3Drivers) {
            $driver.Name = $driver.Name.Replace('HKEY_LOCAL_MACHINE', 'HKLM:')
        
            Remove-Item -Path $driver.Name -Recurse -Force
        }
        Foreach ($driver in $V4Drivers) {
            $driver.Name = $driver.Name.Replace('HKEY_LOCAL_MACHINE', 'HKLM:')
        
            Remove-Item -Path $driver.Name -Recurse -Force
        }
        
        Write-Host -ForegroundColor Green ("Done!")
    }
    
        
} Else {
    Write-Host ("No action taken")
}
    