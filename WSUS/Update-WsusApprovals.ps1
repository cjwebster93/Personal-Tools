<#
    .SYNOPSIS
    This script will automatically manage update approvals in WSUS.

    .DESCRIPTION
    This script will utilize regular expression for more fine-grained automated
    approving/declining of updates in WSUS.

    It will perform the following actions:

      -- Decline updates based on regex match
      -- Decline superseded updates
      -- Unapprove updates that are not needed
      -- Approve updates that are needed

    .EXAMPLE
    Update-WsusApprovals

    .NOTES
    This script is part of the PS-Admin-Tools toolbox for easily doing more complex
    but common administration tasks.

    Author(s): Rory Fewell <rory.fewell@agileict.co.uk>

    Agile ICT for Education (C) 2020
#>

$LIST_TYPE = "System.Collections.Generic.List[String]";


#
# Connect to WSUS
#
[void][System.Reflection.Assembly]::Load(
    "Microsoft.UpdateServices.Administration, " +
    "Version=4.0.0.0, "                         +
    "Culture=neutral, "                         +
    "PublicKeyToken=31bf3856ad364e35"
);

$wuServer = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer();


#
# Track what was done
#
$updatesApprovedNeeded     = New-Object -TypeName $LIST_TYPE;
$updatesDeclinedRegex      = New-Object -TypeName $LIST_TYPE;
$updatesDeclinedSuperseded = New-Object -TypeName $LIST_TYPE;
$updatesUnapproved         = New-Object -TypeName $LIST_TYPE;


#
# Construct our computer scopes
#
$allComputersScope    =
    New-Object -TypeName Microsoft.UpdateServices.Administration.ComputerTargetScope;
$computerTargetGroups = $wuServer.GetComputerTargetGroups();


#
# Construct our update scopes
#
$anyExceptDeclinedScope =
    New-Object -TypeName Microsoft.UpdateServices.Administration.UpdateScope;

$anyExceptDeclinedScope.ApprovedStates =
    [Microsoft.UpdateServices.Administration.ApprovedStates]::HasStaleUpdateApprovals -bor
    [Microsoft.UpdateServices.Administration.ApprovedStates]::LatestRevisionApproved  -bor
    [Microsoft.UpdateServices.Administration.ApprovedStates]::NotApproved;
    

#
# Manage updates to decline based on regex
#
$declinePatterns = @(
    "Windows 10.*for (x86|ARM64)",
    "\.NET Framework.*Windows 10 Version \d+ \(",
    "(farm-deployment|Office Online|SharePoint)",
    "Microsoft.*64-Bit Edition",
    "Microsoft Edge-(Beta|Dev).*",
    "Microsoft Edge.*(ARM64|x86).*"
);
$updatesToRegexMatch = $wuServer.GetUpdates($anyExceptDeclinedScope);

$updateCount = $updatesToRegexMatch.Count;

for ($i = 0; $i -lt $updateCount; $i++)
{
    $foundMatch = $FALSE;
    $update     = $updatesToRegexMatch[$i];

    foreach ($rule in $declinePatterns)
    {
        if ($update.Title -match $rule)
        {
            $foundMatch = $TRUE;
            break;
        }
    }

    if ($foundMatch)
    {
        $updatesDeclinedRegex.Add($update.Title);
        $update.Decline();
    }

    Write-Progress -Activity        "Declining updates via regex..." `
                   -Status          "Progress"                       `
                   -PercentComplete (($i + 1) / $updateCount * 100);
}

Write-Progress -Activity "Declining updates via regex..." `
               -Completed;


#
# Manage updates to decline based on supersedence
#
$updatesToCheckSupersedence = $wuServer.GetUpdates($anyExceptDeclinedScope);

$updateCount = $updatesToCheckSupersedence.Count;

for ($i = 0; $i -lt $updateCount; $i++)
{
    $update = $updatesToCheckSupersedence[$i];

    if ($update.IsSuperseded)
    {
        $updatesDeclinedSuperseded.Add($update.Title);
        $update.Decline();
    }

    Write-Progress -Activity        "Declining superseded updates..." `
                   -Status          "Progress"                       `
                   -PercentComplete (($i + 1) / $updateCount * 100);
}

Write-Progress -Activity "Declining superseded updates..." `
               -Completed;


#
# Manage updates to (un)approve based on needed count
#
$updatesToCheckNeeded = $wuServer.GetUpdates($anyExceptDeclinedScope);

$updateCount = $updatesToCheckNeeded.Count;

for ($i = 0; $i -lt $updateCount; $i++)
{
    $update             = $updatesToCheckNeeded[$i];
    $updateInstallInfos = $update.GetUpdateInstallationInfoPerComputerTarget(
        $allComputersScope
    );

    $computersNeeded = ($updateInstallInfos | Where-Object {
        $_.UpdateInstallationState -ne [Microsoft.UpdateServices.Administration.UpdateInstallationState]::Installed     -and
        $_.UpdateInstallationState -ne [Microsoft.UpdateServices.Administration.UpdateInstallationState]::NotApplicable -and
        $_.UpdateInstallationState -ne [Microsoft.UpdateServices.Administration.UpdateInstallationState]::Unknown;
    }).Count;

    if ($computersNeeded -eq 0)
    {
        $updatesUnapproved.Add($update.Title);

        foreach ($computerTargetGroup in $computerTargetGroups)
        {
            try
            {
                $update.Approve(
                    [Microsoft.UpdateServices.Administration.UpdateApprovalAction]::NotApproved,
                    $computerTargetGroup
                ) | Out-Null;
            }
            catch { }
        }
    }
    else
    {
        $updatesApprovedNeeded.Add($update.Title);

        foreach ($computerTargetGroup in $computerTargetGroups)
        {
            try
            {
                $update.Approve(
                    [Microsoft.UpdateServices.Administration.UpdateApprovalAction]::Install,
                    $computerTargetGroup
                ) | Out-Null;
            }
            catch { }
        }
    }

    Write-Progress -Activity        "Managing needed updates..." `
                   -Status          "Progress"                           `
                   -PercentComplete (($i + 1) / $updateCount * 100);
}

Write-Progress -Activity "Managing needed updates..." `
               -Completed;


#
# Display the results
#
Write-Host "The following updates were declined via match:`n";
$updatesDeclinedRegex;

Write-Host "`nThe following updates were declined due to supersedence:`n";
$updatesDeclinedSuperseded;

Write-Host "`nThe following updates were unapproved because they are not needed:`n";
$updatesUnapproved;

Write-Host "`nThe following updates were approved because they are needed:`n";
$updatesApprovedNeeded

Write-Host "`nAll done - you should inspect the results and run cleanups manually.`n`n"
