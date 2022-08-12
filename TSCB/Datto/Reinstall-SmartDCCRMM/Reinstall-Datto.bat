@echo off

set Logfile=%COMPUTERNAME%_RMM.log

echo "Reinstalling Datto RMM Agent on %COMPUTERNAME%..." >> %Logfile%

REM Uninstall Datto RMM Agent
echo "Uninstalling Datto RMM Agent..." >> %Logfile%
Call "C:\Program Files (x86)\CentraStage\uninst.exe" 
timeout 10
echo "Uninstalled Datto RMM Agent!" >> %Logfile%

REM Remove all directories as described https://rmm.datto.com/help/en/Content/4WEBPORTAL/Devices/ServersLaptopsDesktops/Windows/InstallWindows.htm
echo "Removing directories..." >> %Logfile%
rmdir /s /q "C:\Program Files (x86)\CentraStage"
echo "Removed C:\Program Files (x86)\CentraStage..." >> %Logfile%

rmdir /s /q "C:\Windows\System32\config\systemprofile\AppData\Local\CentraStage"
echo "Removed C:\Windows\System32\config\systemprofile\AppData\Local\CentraStage" >> %Logfile%

rmdir /s /q "C:\Windows\SysWOW64\config\systemprofile\AppData\Local\CentraStage"
echo "Removed C:\Windows\SysWOW64\config\systemprofile\AppData\Local\CentraStage" >> %Logfile%

rmdir /s /q "%userprofile%\AppData\Local\CentraStage"
echo "Removed %userprofile%\AppData\Local\CentraStage" >> %Logfile%

rmdir /s /q "%allusersprofile%\CentraStage"
echo "Removed %allusersprofile%\CentraStage" >> %Logfile%

echo "All directories removed!" >> %Logfile%

REM Remove all registry keys as described https://rmm.datto.com/help/en/Content/4WEBPORTAL/Devices/ServersLaptopsDesktops/Windows/InstallWindows.htm

echo "Removing registry keys..." >> %Logfile%
reg delete "HKEY_CLASSES_ROOT\cag" /f
reg delete "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\CentraStage" /f
echo "Removed registry keys!" >> %Logfile%

REM Install Datto RMM Agent
echo "Installing Datto RMM Agent..." >> %Logfile%
start /wait .\AgentSetup_Smart+DCC.exe
echo "Installed Datto RMM Agent!" >> %Logfile%

echo Script completed! >> %Logfile%

echo "Removed registry keys!" >> %Logfile%

