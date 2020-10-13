@echo off
IF EXIST "C:\Program Files\Veyon\uninstall.exe" (
   echo Veyon found, uninstalling...
   "C:\Program Files\Veyon\uninstall.exe" /S
echo Uninstall complete
) ELSE (
   echo Veyon is not installed
)