@echo off
echo Closing New Microsoft Teams...

:: Kill Teams process
taskkill /f /im ms-teams.exe >nul 2>&1

:: Wait a moment to ensure it's closed
timeout /t 3 /nobreak >nul

echo Deleting New Teams local cache...

:: Delete Teams UWP cache and local data
rmdir /s /q "%LocalAppData%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams"
rmdir /s /q "%LocalAppData%\Packages\MSTeams_8wekyb3d8bbwe\AC"
rmdir /s /q "%LocalAppData%\Packages\MSTeams_8wekyb3d8bbwe\TempState"

echo Teams UWP data reset complete.

:: Optional: Relaunch Teams (if installed for current user)
start "" "ms-teams.exe"

::pause
