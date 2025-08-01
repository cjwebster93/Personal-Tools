@echo off
taskkill /F /IM Teams.exe
IF EXIST %appdata%\Microsoft\Teams (
    echo Teams cache found... deleting...
    rmdir %appdata%\Microsoft\Teams\blob_storage /Q /S
	rmdir %appdata%\Microsoft\Teams\Cache /Q /S
	rmdir %appdata%\Microsoft\Teams\databases /Q /S
	rmdir %appdata%\Microsoft\Teams\GPUCache /Q /S
	rmdir %appdata%\Microsoft\Teams\IndexedDB /Q /S
	rmdir "%appdata%\Microsoft\Teams\Local Storage" /Q /S
	rmdir %appdata%\Microsoft\Teams\tmp /Q /S
	del %appdata%\Microsoft\Teams\settings
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