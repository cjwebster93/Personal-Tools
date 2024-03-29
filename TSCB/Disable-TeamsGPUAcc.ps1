param(

    #Define parameters and values
    [string]$newWebLanguage = "en-GB", #Updated to "en-GB"
    [bool]$newDisableGpu = $true, #Disable GPU - can be overriden on execution
    [string]$desktopConfigFile = "$env:userprofile\\AppData\Roaming\Microsoft\Teams\desktop-config.json",
    [string]$cookieFile = "$env:userprofile\\AppData\Roaming\Microsoft\teams\Cookies",
    [string]$registryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
    [string]$registryDisplayName = "Microsoft Teams",
    [string]$processName = "Teams",
    [switch]$Silent = $false, #--- Does NOT work as Cookies file cannot be cleared whilst the client is running
    [switch]$Restart = $false #Restarts the Teams client on completion of changes.
)

#Check if Teams is installed
$registryPathCheck = Get-ChildItem -Path $registryPath -Recurse | Get-ItemProperty | Where-Object { $_.DisplayName -eq $registryDisplayName } -ErrorAction SilentlyContinue
$initialState = Get-Process $processName -ErrorAction SilentlyContinue

#Read the Teams desktop config file and convert from JSON
$config = (Get-Content -Path $desktopConfigFile | ConvertFrom-Json -ErrorAction SilentlyContinue)

#Check if required parameter value is already set within Teams desktop config file
$configCheck = $config | Where-Object { ($_.currentWebLanguage -ne $newWebLanguage) -or ($_.appPreferenceSettings.disableGpu -ne $newDisableGpu) } -ErrorAction SilentlyContinue

#If changes need to be made, then execute.
if ($configCheck) {


    #Check if Teams process is running, unless the -Silent switch has been used
    if (!$Silent) {
        Stop-Process -Name Teams -ErrorAction SilentlyContinue
        $processCheck = Get-Process $processName -ErrorAction SilentlyContinue
    }

    #Read the Teams desktop config file and convert from JSON
    #$config = (Get-Content -Path $desktopConfigFile | ConvertFrom-Json -ErrorAction SilentlyContinue)

    #Check if required parameter value is already set within Teams desktop config file
    #$configCheck = $config | Where-Object {($_.currentWebLanguage -ne $newWebLanguage) -or ($_.appPreferenceSettings.disableGpu -ne $newDisableGpu)} -ErrorAction SilentlyContinue

    #Check if Teams cookie file exists
    $cookieFileCheck = Get-Item -path $cookieFile -ErrorAction SilentlyContinue

    #1-If Teams is installed ($registryPathCheck not null)
    #2-If Teams desktop config settings current value doesn't match parameter value ($configCheck not null)
    #3-If Teams process is running ($processCheck not null)
    #4-Then terminate the Teams process and wait 5 seconds
    if ($registryPathCheck -and $configCheck -and $processCheck) {
        Get-Process $processName | Stop-Process -Force
        Start-Sleep 5
    }

    #Check if Teams process is stopped
    $processCheckFinal = Get-Process $processName -ErrorAction SilentlyContinue

    #1-If Teams is installed ($registryPathCheck not null)
    #2-If Teams desktop config settings current value doesn't match parameter value ($configCheck not null)
    #3-Then update Teams desktop config file with new parameter value
    if ($registryPathCheck -and $configCheck) {
        $config.currentWebLanguage = $newWebLanguage
        $config.appPreferenceSettings.disableGpu = $newDisableGpu
        $config | ConvertTo-Json -Compress | Set-Content -Path $desktopConfigFile -Force

        #1-If Teams process is stopped ($processCheckFinal is null)
        #2-If Teams cookie file exists ($cookieFileCheck not null)
        #3-Then delete cookies file

        if (!$processCheckFinal -and $cookieFileCheck) {
            Remove-Item -path $cookieFile -Force
        }
    }

    #Restart the Teams client after changes have been made, if it has been told to do so (-Restart) and it was running to begin with.
    if ($Restart -and $initialState) {
        Start-Process -FilePath "$env:userprofile\\AppData\Local\Microsoft\Teams\current\Teams.exe" -ErrorAction SilentlyContinue
    }
    Write-Host -ForegroundColor Green ("Changes complete")
} else {
    Write-Host -ForegroundColor Green ("No changes required")
}