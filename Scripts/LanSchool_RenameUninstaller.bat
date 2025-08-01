@echo off

if exist "C:\Windows\Installer\{1C9EBF9F-DE7D-4C24-BB50-E44069166AEB}\ARPPRODUCTICON.exe" (
	ren C:\Windows\Installer\{1C9EBF9F-DE7D-4C24-BB50-E44069166AEB}\ARPPRODUCTICON.exe C:\Windows\Installer\{1C9EBF9F-DE7D-4C24-BB50-E44069166AEB}\ARPPRODUCTICON.com
	echo Uninstall file renamed.
	) else (
	echo File doesn't exist!
	)