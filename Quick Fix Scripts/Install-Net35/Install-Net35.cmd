@echo off

IF NOT EXIST C:\AgileICT\NetFX3.txt (


    echo Bypassing WSUS server...
    reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v UseWUServer /t REG_DWORD /d 0 /f
    echo Installing NetFX3...
    dism /online /enable-feature /featurename:netfx3 /all /limitaccess
    echo Adding file to track completion...
    reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v UseWUServer /t REG_DWORD /d 1 /f
    echo NetFX3 installed > C:\AgileICT\NetFX3.txt


    echo Done!
    ) ELSE (
    echo Script already run... )
)
