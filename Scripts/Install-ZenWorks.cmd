@echo off
REM This script is used to install the ZenWorks agent on a Windows machine.
REM It checks for the presence of the agent and installs it if not found.

SET CheckPath="C:\Program Files (x86)\Novell\ZENworks"
SET InstallerPath="\\PRS-Dc03\Blueloop\Client Software\Zenworks\PreAgentPkg_AgentCompleteDotNet.exe"

IF NOT EXIST %CheckPath% (
    REM Check if the agent is already installed
    echo ZenWorks agent not found. Installing now... > C:\tmp\ZenWorksInstall.log
    
    REM Install the ZenWorks agent using the provided path
    start /wait %InstallerPath%
    
    REM Check if the installation was successful
    IF ERRORLEVEL 1 (
        echo Installation failed. >> C:\tmp\ZenWorksInstall.log
        exit /b 1
    ) ELSE (
        echo ZenWorks agent installed successfully. >> C:\tmp\ZenWorksInstall.log
    )
) ELSE (
    echo ZenWorks agent is already installed. > C:\tmp\ZenWorksInstall.log
)
