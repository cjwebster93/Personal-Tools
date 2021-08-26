
param ([switch] $Remove=$false)

$Drivers = Get-ChildItem `
    -Path "HKLM:\\SYSTEM\CurrentControlSet\Control\Print\Environments\Windows x64\Drivers\Version-3\" | `
    Where-Object {`
        ($_.PSChildName -notlike "Cute*") -and `
        ($_.PSChildName -notlike "Microsoft*")`
    } | Select-Object -Property Name, PSChildName
Write-Host ("Located $($Drivers.Name)")

If ($Remove) {
    Write-Host -ForegroundColor Yellow ("Removing Drivers...")
    Foreach ($driver in $Drivers) {
        $driver.Name = $driver.Name.Replace('HKEY_LOCAL_MACHINE', 'HKLM:')
        #$driver.Name
        Remove-Item -Path $driver.Name -Recurse -Force
    } 
} Else {
    Write-Host ("No action taken")
}
    
