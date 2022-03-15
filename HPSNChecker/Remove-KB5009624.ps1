$Check = Get-HotFix -Id KB5009624
If ($Check) {
    wusa /uninstall /kb:5009624 /quiet /norestart
    Write-Host ("Update found and removed")
} else {
    Write-Host ("Update not found")
}