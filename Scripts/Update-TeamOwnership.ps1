
$LogPath = Get-Location
[string]$Date = Get-Date -Format hhmm-ddMMyy
$LogFile = $LogPath,"\ClassOwner",$Date,".log" -join ""

Start-Transcript -Path $LogFile

$Subjects = @(
    'Maths',
    'English',
    'History',
    'Art',
    'Geography',
    'RS',
    'Latin',
    'Computer',
    'Craft',
    'Class',
    'Music',
    'Humanities',
    'French',
    'Ceramics',
    'Drama',
    'Science',
    'Ceramics',
    'Technology',
    'Life Skills',
    'Spanish',
    'Design'
)

#Owner to add to Teams
$NewOwner = 'myschoolportal@portregis.com'

#Import Microsoft Teams module
Import-Module MicrosoftTeams

#Connect to Microsoft Teams
Connect-MicrosoftTeams

#Get all Teams
$AllTeams = Get-Team

#Iterate through subjects and pick out the class Teams

foreach ($subject in $Subjects) {
    $Classes = $AllTeams | Where-Object {$_.DisplayName -like "$subject*"}

    foreach ($Class in $Classes) {
        #Assign needed attributes for convenience.
        $GroupID = $Class.GroupID
        $GroupName = $Class.DisplayName

        #Check if the user is already added as an Owner to the Team and add if false.
        If (!(Get-TeamUser -GroupId $GroupID | Where-Object {($_.User -eq $NewOwner) -and ($_.Role -eq 'Owner')})){
            Add-TeamUser -GroupId $GroupID -User $NewOwner -Role Owner

            Write-Host -ForegroundColor Green ("$NewOwner added as owner of $GroupName")
        } else {
            Write-Host -ForegroundColor Yellow ("$NewOwner already owner of $GroupName")
        }
    }
}

#Disconnect
Disconnect-MicrosoftTeams

Stop-Transcript