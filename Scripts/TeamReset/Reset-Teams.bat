@echo off
taskkill /F /IM Teams.exe
IF EXIST %appdata%\Microsoft\Teams (
    echo Teams cache found... deleting...
    rmdir %appdata%\Microsoft\Teams /Q /S
    echo Done!
    echo -----------------------------------
    echo Attempting to restart Teams

    IF EXIST %localappdata%\Microsoft\Teams\current\Teams.exe (
        start %localappdata%\Microsoft\Teams\current\Teams.exe
    ) ELSE (
        echo Local Teams installation not found in %localappdata%
    )
) ELSE (
    echo Teams cache not found
)