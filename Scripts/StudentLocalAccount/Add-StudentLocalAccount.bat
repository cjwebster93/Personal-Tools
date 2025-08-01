@echo off

REM Set contants.
set Username=student
set Password=Warren.Park!

REM Check if user exists
net user %Username%
IF %ERRORLEVEL% EQU 0 (
    echo User already exists... 
    EXIT 1
) ELSE (
    REM Create local user account
    echo Adding student account...
    net user %Username% %Password% /ADD
    echo User account created :)
    EXIT 0
)

