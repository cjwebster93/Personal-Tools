#Custom script to set student password according to a coded template. Adjust as necessary.

#Get AD group we want to reset passwords on, also used for logging file name
$ADGroup = Read-Host -Prompt "What AD group will we be working on?"

#Start transcript with identifiable log name
$Path = Get-Location
$LogPath = ("$Path\$ADGroup" + '_Passwords.log')
Write-Host('Transcript log file will be: ' + $LogPath)
$CSVPath = ("$Path\$ADGroup" + '_Passwords.csv')
Write-Host('Output CSV File will be: ' + $CSVPath)
Start-Transcript -Path ($LogPath)

#Guess DFE from Agile-style domain name
$DFE = Get-CurrentUserDomain.substring(2,4)
Write-Host ('School DFE is ' + $DFE)
$ManDFE = Read-Host -'Prompt Is the DFE correct? If not, enter it now (else, leave blank)'
if ($ManDFE) {
    $DFE = $ManDFE
    Write-Host ('DFE set to ' + $DFE)
}

$userlist = Get-ADGroupMember $ADGroup
Foreach($user in $userlist) {
    
    $userinfo = Get-AdUser $user.SamAccountName -Properties GivenName, Surname  
    
    #Get initial characters and capitalise
    $GivenInit = ($userinfo.GivenName.substring(0,1)).ToUpper()
    #Write-Host($GivenInit)

    $SurInit   = ($userinfo.Surname.substring(0,1)).ToUpper()
    #Write-Host($SurInit)

    #Build password
    $Password  = $DFE + $GivenInit + $SurInit +"!"
    Write-Host('Generated password for ' + $user.name + ' is ' + $Password)

    #Set password
    Set-ADAccountPassword -Identity $userinfo.SamAccountName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force)
    Write-Host('Password reset for ' + $user.name + '!')

    #Export to csv
    $CSVContent = New-Object -TypeName psobject
    $CSVContent | Add-Member -MemberType NoteProperty -Name FullName -Value $userinfo.Name
    $CSVContent | Add-Member -MemberType NoteProperty -Name Username -Value $userinfo.SamAccountName
    $CSVContent | Add-Member -MemberType NoteProperty -Name Password -Value $Password

    Export-Csv -InputObject $CSVContent -Path ($Path + '\' + $ADGroup + '_Passwords.csv') -Append -NoTypeInformation
    }

Stop-Transcript