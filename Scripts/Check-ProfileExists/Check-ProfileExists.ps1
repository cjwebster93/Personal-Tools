[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$username,

    [Parameter(Mandatory = $true)]
    [string]$csvPath
)

# Define the path to the CSV file and the username to check
#$csvPath = "SCR.csv"  # Update this path
#$username = "noproof21"                # Update this username

# Import the list of hostnames from the CSV
$computers = Import-Csv -Path $csvPath

# Iterate through each computer
foreach ($computer in $computers) {
    $hostname = $computer.Hostname  # Assumes the CSV has a column named 'Hostname'
    $userPath = "\\$hostname\c$\Users\$username"

    if (Test-Path -Verbose -Path $userPath) {
        Write-Output "User folder exists on $hostname"
    } else {
        Write-Output "User folder NOT found on $hostname"
    }
}
