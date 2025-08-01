@echo off
taskkill /F /IM Teams.exe
IF EXIST %appdata%\Microsoft\Teams (
    echo Teams cache found... deleting...
    rmdir %appdata%\Microsoft\Teams /Q /S
    echo Done!
    echo -----------------------------------
) ELSE (
    echo Teams cache not found
)