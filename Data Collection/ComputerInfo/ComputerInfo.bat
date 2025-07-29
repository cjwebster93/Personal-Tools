@echo off

set log=%COMPUTERNAME%.txt
echo System name: %COMPUTERNAME% >> %log%
echo ------------------------------------ >> %log%
echo Network Info >> %log%
ipconfig /all >> %log%