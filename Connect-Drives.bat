:: Script to connect shared and personal drives. Written for use at on standalone machines - Craig Webster
@echo off
:: Set DC server IP (Change as required)
set server_ip=172.21.174.16
echo Server IP set is %server_ip%

:: Attach drives
echo Set Drive Name...
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##%server_ip%#staffhomes$#%username%#documents /v _LabelFromReg /t REG_SZ /f /d "My Documents"
echo Connect Drive...
net use U: \\%server_ip%\staffhomes$\%username%\documents

echo Set Drive Name...
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##%server_ip%#teares$ /v _LabelFromReg /t REG_SZ /f /d "Teacher Resources"
echo Connect Drive...
net use T: \\%server_ip%\teares$

echo Set Drive Name...
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##%server_ip%#officeres$ /v _LabelFromReg /t REG_SZ /f /d "Office Resources"
echo Connect Drive...
net use O: \\%server_ip%\officeres$

echo Set Drive Name...
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##%server_ip%#slt$ /v _LabelFromReg /t REG_SZ /f /d "SLT"
echo Connect Drive...
net use L: \\%server_ip%\slt$

echo Set Drive Name...
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##%server_ip%#media$ /v _LabelFromReg /t REG_SZ /f /d "Media"
echo Connect Drive...
net use M: \\%server_ip%\media$

echo Set Drive Name...
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##%server_ip%#studsav$ /v _LabelFromReg /t REG_SZ /f /d "Student Saves"
echo Connect Drive...
net use S: \\%server_ip%\studsav$

echo Set Drive Name...
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2\##%server_ip%#studres$ /v _LabelFromReg /t REG_SZ /f /d "Student Resources"
echo Connect Drive...
net use R: \\%server_ip%\studres$

echo Done!