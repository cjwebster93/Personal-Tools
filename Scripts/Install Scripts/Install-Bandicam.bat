@echo off
IF NOT EXIST "C:\Program Files (x86)\Bandicam\bdcam.exe" (
    echo Starting Bandicam install...
    start \\%userdomain%\dfs$\mansoft\Core\Bandicam\bdcamsetup.exe /S
) Else (
    echo Software already exists.
)