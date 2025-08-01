@echo off

set delay=5


:countdown
echo Starting TestWise in %delay% seconds...
timeout /t 1 > nul
set /a delay -= 1
if %delay% GTR 0 (
    GOTO :countdown
)

echo Starting TestWise now!
timeout /t 1 > nul
"C:\Program Files\Google\Chrome\Application\chrome.exe" https://www.testwise.com/platform/code