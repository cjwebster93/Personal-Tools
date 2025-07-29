#Created by Craig Webster

$SN = get-ciminstance -classname win32_bios | format-list serialnumber
Write-Output -InputObject $SN
$SN > C:\Serial.txt
Write-Host "Info saved to C:\Serial.txt"
Pause