@echo off

REM Software info
set AppName="ApplicationName"
set InstallerPath="InstallerPath"
set ProgFiles="ProgFiles path"
set Switches="switches e.g. /S"

REM Check existing install
IF NOT EXIST %ProgFiles% (
	echo Installing %AppName%...
	REM Silent install string specific to application installer
	%InstallerPath% %Switches%
	echo Done!
) ELSE (
	REM echo that already installed.
	echo Already Installed!
	)