$update = Get-Hotfix -ID KB4541329
If ($update) {
& wusa.exe /uninstall /KB:4541329 /norestart
& msg * This server will be rebooted in 5 minutes to fix a broken update. Please save your work and log off. Thanks from Agile. 2>$null 
& shutdown /r /t 300 -c "Reboot to remove KB4541329"
}