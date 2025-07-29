@echo off

REM Check existing install
IF NOT EXIST "C:\Program Files (x86)\Scratch 3" (
	echo Installing...
	REM Silent install string specific to application installer
	"\\%userdomain%\dfs$\mansoft\CuriculumSoftware\Scratch 3.0\Scratch 3.24.0 Setup.exe" /S /allusers
	echo Done!
) ELSE (
	REM echo that already installed.
	echo Already Installed!
	)