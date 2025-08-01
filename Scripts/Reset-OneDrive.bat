@echo off
set OneDrivePath1="C:\Program Files\Microsoft OneDrive\OneDrive.exe"

if exist %OneDrivePath1% (
    echo OneDrive found at %OneDrivePath1%
    %OneDrivePath1% /reset
    echo OneDrive reset command executed.
) else (
    echo OneDrive not found at %OneDrivePath1%
)
pause