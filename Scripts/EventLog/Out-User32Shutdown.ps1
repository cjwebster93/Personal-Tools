<#
    .SYNOPSIS
    This script will pop up a message box with information regarding the last shutdown
    initiated via a User32 API.

    .DESCRIPTION
    This script will filter the System log in Event Viewer for the latest event created
    by User32 with ID 1074. The parameters that detail the user, program, and reason
    for shutdown will then be displayed in a standard Windows message box.

    .EXAMPLE
    Out-User32Shutdown.ps1

    .NOTES
    This script is part of the PS-Admin-Tools toolbox for easily doing more complex
    but common administration tasks.

    Author(s): Rory Fewell <rory.fewell@agileict.co.uk>

    Agile ICT for Education (C) 2020
#>

[System.Reflection.Assembly]::Load(
    "System.Windows.Forms,"           +
    "Version=4.0.0.0,"                +
    "Culture=neutral,"                +
    "PublicKeyToken=b77a5c561934e089"
) | Out-Null;

try
{
    # Retrieve event data
    #
    $event = Get-WinEvent -FilterHashtable @{        `
                                    ID=1074;         `
                                    LogName='System' `
                          }                          `
                          -MaxEvents 1               `
                          -ErrorAction Stop;
    $eventXml    = [Xml]$event.ToXml();
    $params      = $eventXml.Event.EventData.Data;

    # Params
    #
    $dateOccurred = $event.TimeCreated;
    $process      = $params[0].InnerText;
    $reason       = $params[2].InnerText;
    $user         = $params[6].InnerText;

    [System.Windows.Forms.MessageBox]::Show(
        "Last User32 shutdown was at $dateOccurred`n"     +
        "The user responsible was $user via $process`n`n" +
        "Reason: $reason",
        "Recent Shutdown",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    );
}
catch [Exception]
{
    [System.Windows.Forms.MessageBox]::Show("No User32 API shutdowns recently.");
}
