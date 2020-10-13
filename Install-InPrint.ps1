#Check if installed
$Installed = Test-Path -Path "C:\Program Files (x86)\Communication InPrint"
$Date = Get-Date -UFormat "%d/%m/%Y %R"
$Components = {
    core,
    InPrint,
    inprint_resources_uk,
    wordlistmanager
}
Write-Host("Inprint Installed: $Installed")
If ($Installed -eq 'False') 
{   Foreach ($part in $Components)
    {
        try 
        {
            Write-Host("Installing $part")
            "msiexec.exe /i $part.msi /qn"
        }
        catch
        {
            Write-Host ("Error installing $part")
        }   
    }
}
