#Custom script to set student password according to a coded template. Adjust as necessary.

Start-Transcript -Path 'C:\AgileICT\Logs\StudentPasswords.txt'

$userlist = Get-ADGroupMember 'students'
Foreach($user in $userlist) {
    
    $userinfo = Get-AdUser $user.SamAccountName -Properties GivenName, Surname  
    
    #Get initial characters and capitalise
    $GivenInit = ($userinfo.GivenName.substring(0,1)).ToUpper()
    #Write-Host($GivenInit)

    $SurInit   = ($userinfo.Surname.substring(0,1)).ToUpper()
    #Write-Host($SurInit)

    #Build password
    $Password  = "Midhurst" + $GivenInit + $SurInit +"!"
    Write-Host('Generated password for ' + $user.name + ' is ' + $Password)

    #Set password
    Set-ADAccountPassword -Identity $userinfo.SamAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force)
    Write-Host('Password reset for ' + $user.name + '!')

    #Export to csv
    $CSVContent = New-Object -TypeName psobject
    $CSVContent | Add-Member -MemberType NoteProperty -Name FullName -Value $userinfo.Name
    $CSVContent | Add-Member -MemberType NoteProperty -Name Username -Value $userinfo.SamAccountName
    $CSVContent | Add-Member -MemberType NoteProperty -Name Password -Value $Password

    Export-Csv -InputObject $CSVContent -Path 'C:\AgileICT\Logs\StudentPasswords.csv' -Append -NoTypeInformation
    }

Stop-Transcript