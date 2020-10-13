#Check if installed
$Installed = Test-Path -Path "C:\Program Files (x86)\Communication InPrint"
$Date = Get-Date -UFormat "%d/%m/%Y %R"
Write-Host("Inprint Installed: $Installed")
If ($Installed -eq 'False') 
{
    Write-Host("Installing Core package")
    try {
        msiexec.exe /i .\core.msi /qn
    }
    catch 
    Write-Host("Installing InPrint package")
    msiexec.exe /i .\inprint.msi /qn
    Write-Host("Installing Resources package")
    msiexec.exe /i .\inprint_resources_uk.msi /qn
    Write-Host("Installing Wordlist package")
    msiexec.exe /i .\wordlistmanager.msi /qn
    
    Write-Host("Install Complete at $Date")
}
