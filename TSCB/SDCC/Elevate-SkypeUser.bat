@echo off

REM Creating a Newline variable (the two blank lines are required!)
set NLM=^


set NL=^^^%NLM%%NLM%^%NLM%%NLM%

set choice=""

REM Elevate the Skype user to Administrator. Useful for applying updates to the apps in that profile

:Choice
SET /P choice=Please choose an action [1/2]: %NL% 1. Elevate Skype user to Administrator %NL% 2. Demote Skype user to Standard user %NL%

IF %choice%==1 GOTO Elevate
IF %choice%==2 GOTO Demote
GOTO Choice

:Elevate
echo Adding Skype user to local Administrators...
net localgroup Administrators Skype /add
echo Done
GOTO Exit

:Demote
echo Removing Skype user from local Administrators...
net localgroup Administrators Skype /delete
echo Done
GOTO Exit

:Exit
pause