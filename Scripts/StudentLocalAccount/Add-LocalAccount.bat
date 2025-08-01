@echo off
REM Quick local user creation script by Craig Webster

REM Set contants. Change as required
set Username=[Username]
set Password=[Password]

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

