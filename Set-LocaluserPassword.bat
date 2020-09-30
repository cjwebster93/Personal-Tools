@echo off
IF NOT EXIST "C:\AgileICT\LocaluserReset\" (
    echo Script has not been run before!
    net user localuser [password]
    mkdir "C:\AgileICT\LocaluserReset"
)