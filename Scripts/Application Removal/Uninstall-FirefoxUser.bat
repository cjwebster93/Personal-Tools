@echo off
set filePath="C:\Users\%username%\AppData\Local\Mozilla Firefox\uninstall\helper.exe"
set MozillaDir="C:\Users\%username%\AppData\Local\Mozilla"
set FirefoxDir="C:\Users\%username%\AppData\Local\Mozilla Firefox"
set shortcutFF="C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Firefox.lnk"
set shortcutPBFF="C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Firefox Private Browsing.lnk"
set LogFile="%userprofile%\FFUninstall.log"

:: Uninstall Firefox
if exist %filePath% (
    echo Uninstalling Firefox... > %LogFile%
    %filePath% -ms
    echo Uninstalled Firefox! >> %LogFile%
    echo Removing Firefox directories... >> %LogFile%
    rmdir /s /q %MozillaDir%
    rmdir /s /q %FirefoxDir%
    echo Removed Firefox directories! >> %LogFile%
    echo Removing Firefox shortcuts... >> %LogFile%
    del %shortcutFF%
    del %shortcutPBFF%
    echo Done! >> %LogFile%
) else (
    echo File not found: %filePath% > %LogFile%
)