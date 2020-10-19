#Contants
$RootFilePath = "D:\users\profiles\"

#Logging
$LogRootPath = Get-Location
$LogPath = ("$LogRootPath\" + 'ProfileReset.log')
Write-Host('Transcript log file will be: ' + $LogPath)
Start-Transcript -Path $LogPath -Append

#Prompt for user scope
$Scope = Read-Host "Specify OU scope e.g. OU=2017,OU=Students,OU=Users,OU=School,DC=SCH3186,DC=hants,DC=sch,DC=uk"

#Break down the path
$ScopePart = $Scope.Split(",")
$i=0
Foreach ($Part in $ScopePart) {

    
    $Part = $Part.Substring(3)
    $ScopePart[$i] = $Part
    $i++
}

#Fetch our users in that OU
$Users = Get-ADUser -Filter * -SearchBase $Scope -SearchScope OneLevel -Properties Name

#Run through wach user's profile folder and rename the profiles to .old
Foreach ($User in $Users) {
    Write-Host "Checking profile for"($User.Name)
    $ProfilePath = $RootFilePath+$ScopePart[1]+"\"+$ScopePart[0]+"\"+$User.SamAccountName
    
    Try {
        #Check for a profile.V6 folder
         If (Get-ChildItem -Filter 'profile.V6' -Path $ProfilePath) {
            Write-Host "Profile Found"
            Rename-Item -Path "$ProfilePath\profile.v6" -NewName "$ProfilePath\profile.v6.old"
            Write-Host "Renamed profile"
            }
            else {
            Write-Host "Cannot find active V6 profile"
            }
        
        }
    Catch {
        #Well... we couldn't find it
        Write-Host "Error locating user path"
        }
}
Stop-Transcript