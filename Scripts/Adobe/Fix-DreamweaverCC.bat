::Run this on user logon to preprovision the folder that Dreamwaever seems incapable of creating itself... - Craig Webster
@echo off
IF NOT EXIST "%appdata%\Adobe\Dreamweaver 2021\en_GB\Configuration\Menus" (
   mkdir "%appdata%\Adobe\Dreamweaver 2021\en_GB\Configuration\Menus"
)