@echo off
setlocal

:: Configuration
set vncVersion=2.8.81
set installDir=%ProgramFiles%\TightVNC

:: Download URL
set downloadUrl=https://www.tightvnc.com/download/%vncVersion%/tightvnc-%vncVersion%-gpl-setup-64bit.msi

:: Download TightVNC installer
echo Downloading TightVNC installer...
curl -o tightvnc-setup.msi %downloadUrl%

:: Install TightVNC silently
echo Installing TightVNC...
start /wait  msiexec.exe /i tightvnc-setup.msi /quiet

:: Configure TightVNC for no authentication and localhost only
echo Configuring TightVNC...
reg add "HKLM\SOFTWARE\TightVNC\Server" /v AllowLoopback /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\TightVNC\Server" /v Authentication /t REG_SZ /d None /f

:: Start TightVNC Server
echo Starting TightVNC Server...
"%installDir%\tvnserver.exe"

echo TightVNC Server installed and configured.
endlocal
