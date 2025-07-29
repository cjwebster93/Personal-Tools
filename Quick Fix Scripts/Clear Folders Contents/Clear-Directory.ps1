# Originally made to clear the default path below for bloating on an RWS - Craig Webster
param(
    [Parameter(Position=0)]
    [string]$FolderPath="C:\Windows\System32\config\systemprofile\TOSHIBA\eSTUDIOX\UNIDRV\Cache"
)

If (Test-Path -Path $FolderPath)
    {
        Write-Host -ForegroundColor Yellow ("Removing contents of: $FolderPath")
        Remove-Item -Recurse -Path $FolderPath -Force
}
else 
{
    Write-Host -ForegroundColor Green ("Directory not found: $FolderPath")
}