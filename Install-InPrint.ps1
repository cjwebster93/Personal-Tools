#Start transcript with identifiable log name.
$Path = Get-Location
$LogPath = ("$Path\" + 'InPrintInstall.log')
Write-Host('Transcript log file will be: ' + $LogPath)
Start-Transcript -Path $LogPath

#Check if installed
$Installed = Test-Path -Path "C:\Program Files (x86)\Communication InPrint"
$Date = Get-Date -UFormat "%d/%m/%Y %R"
$Components = @('core','InPrint','inprint_resources_uk','wordlistmanager')

Write-Host("Inprint Installed: $Installed")
If (!$Installed) 
{
    Write-Host -ForegroundColor Yellow ("Starting installation at $Date")
    Foreach ($part in $Components)
    {
        try 
        {
            Write-Host("Installing $part")
            msiexec.exe /i "$Path\$part.msi" /qn
        }
        catch
        {
            Write-Host ("Error installing $part")
        }   
    }
    Write-Host -ForegroundColor Green ("All packages installed!")
}
Stop-Transcript