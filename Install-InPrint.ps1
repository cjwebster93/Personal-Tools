#Installing packages in order
Write-Host("Installing Core package")
msiexec /i .\core.msi /qn
Write-Host("Installing InPrint package")
msiexec /i .\inprint.msi /qn
Write-Host("Installing Resources package")
msiexec /i .\inprint_resources_uk.msi /qn
Write-Host("Installing Wordlist package")
msiexec /i .\wordlistmanager.msi /qn
