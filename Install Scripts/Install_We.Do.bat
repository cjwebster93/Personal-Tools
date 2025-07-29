@echo off

REM Check existing install
IF NOT EXIST "C:\Program Files (x86)\WeDo 2.0" (
	echo Installing...
	REM Silent install string specific to application installer
	"\\%userdomain%\dfs$\mansoft\Curriculum\Lego Education\WeDo 2.0\v1.9.385\WeDo2_Full_1.9.385_Global_WIN10.exe" /SILENT /LOG=C:\AgileICT\Logs\WeDoInstall.log
	echo Done!
) ELSE (
	REM echo that already installed.
	echo Already Installed!
	)