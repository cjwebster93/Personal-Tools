@echo off
REM Created by Craig Webster. Quickly clear all printer jobs on local spool
echo Stopping printer service...
net stop spooler
echo Deleting all pending print jobs...
del /Q /F /S "%windir%\System32\spool\PRINTERS\*.*"
echo Starting back up the print service...
net start spooler
echo DONE!
pause