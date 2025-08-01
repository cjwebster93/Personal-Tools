@echo off

REM Set your service name below
set service=[service]

echo Stopping %service%...
net stop %service%

echo Starting %service%
net start %service%

echo %service% restarted at %time% %date% > Service-Restart.txt
