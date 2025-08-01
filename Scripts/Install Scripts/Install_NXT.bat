@echo off

REM Check existing install
IF NOT EXIST "C:\Program Files (x86)\LEGO Software\LEGO MINDSTORMS Edu NXT" (
	echo Installing...
	REM Silent install string specific to application installer
	"\\%userdomain%\dfs$\mansoft\Curriculum\Lego Education\NXT Software\v2.1.0\setup.exe" /q /acceptlicenses yes /log C:\AgileICT\Logs\NXTInstall.log
	echo Done!
) ELSE (
	REM echo that already installed.
	echo Already Installed!
	)