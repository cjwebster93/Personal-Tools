
#Building the directory path
$RootPath='D:\users\profiles\staff'
$Users=Get-ChildItem -Path $RootPath -Directory # | Select-Object Name

#Recursively going thorugh the immediate subdirectories of each user and enabling inheritance on those items.
foreach ($user in $Users) {
    $UserPath = "$RootPath\$user"
    $files = Get-ChildItem -Path $UserPath -Directory
    #$files
    foreach ($file in $files) {
        $FilePath = "$UserPath\$file"
        $Permission=get-acl -Path $FilePath
        #$Permission
        Write-Host ("Setting inheritance on $file")
        $Permission.SetAccessRuleProtection($False,$true)
        Set-Acl -Path $FilePath -AclObject $Permission
    }
    Write-Host -ForegroundColor Yellow ("$user Done!")
    
}
Write-Host -ForegroundColor Green ("All done!")