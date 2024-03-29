@Echo off
If EXIST "c:\Wbem.txt" GOTO END

:BEGIN
Echo.Checking following services...
Echo IPHelper (iphlpsvc)
Echo SMS Agent Host (CcmExec)
Echo Security Centre (wscsvc) 
Echo Windows Management Instrumentation (winmgmt)
Echo.

Set Service1="ccmexec"
Set Service2="iphlpsvc" 
Set Service3="wscsvc" 
Set Service4="winmgmt"

:CHECK
for /F "tokens=3 delims=: " %%H in ('sc query %Service1% ^| findstr "        STATE"') do (
  	Set Service1State=%%H
	if /I "%%H" NEQ "STOPPED" (
   		echo.%Service1% still STOP_PENDING. Press Any key to check again otherwise Ctrl C out of the script
   		net stop %Service1%
		timeout 10
		cls
		GOTO Check
		)
	)
for /F "tokens=3 delims=: " %%H in ('sc query %Service2%  ^| findstr "        STATE"') do (
  	Set Service2State=%%H
	if /I "%%H" NEQ "STOPPED" (
   		echo.%Service2% still STOP_PENDING. Press Any key to check again otherwise Ctrl C out of the script
		net stop %Service2%
		timeout 10
		cls
		GOTO Check
		)
	)
for /F "tokens=3 delims=: " %%H in ('sc query %Service3% ^| findstr "        STATE"') do (
	Set Service3State=%%H
	if /I "%%H" NEQ "STOPPED" (
   		echo.%Service3% still STOP_PENDING. Press Any key to check again otherwise Ctrl C out of the script
   		net stop %Service3%
		timeout 10
		cls
		GOTO Check
		)
	)
for /F "tokens=3 delims=: " %%H in ('sc query %Service4% ^| findstr "        STATE"') do (
	Set Service4State=%%H
	if /I "%%H" NEQ "STOPPED" (
   		echo.%Service4% still STOP_PENDING. Press Any key to check again otherwise Ctrl C out of the script
   		net stop %Service4%
		timeout 10
		cls
		GOTO Check
		)
	)

:STATUS
CLS
Echo.%Service1% is %Service1State%
Echo.%Service2% is %Service2State%
Echo.%Service3% is %Service3State%
Echo.%Service4% is %Service4State%
echo.
echo.All Services Stopped... Please Wait... Repairing WBEM Repository
del C:\Windows\System32\wbem\Repository\*.* /q
rd C:\Windows\System32\wbem\Repository* /q
timeout 5
cls
echo.Fix complete. Your computer will Restart in 60 seconds.
shutdown -r -t 60
echo.WBEM Script Control > c:\WBEM.txt
timeout 60
