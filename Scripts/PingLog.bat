@echo off
set LogFile=Pinglog.log
Set ServerName="8.8.8.8"

:Main
echo Running 20 second response test...
call :Ping > %LogFile%

:Ping
Echo Running response test against the server: %ServerName%...
ping %ServerName% -n 20
echo Ping log saved to Pinglog.log
exit /B