<#
    .SYNOPSIS
    Export-BitLockerKeys.ps1

    .DESCRIPTION
    Export BitLocker Recovery Keys from Active Directory for all computers or computers in a specific OU to CSV file.

    .LINK
    www.alitajran.com/export-bitlocker-recovery-keys-active-directory-powershell/

    .NOTES
    Written by: ALI TAJRAN
    Website:    alitajran.com
    X:          x.com/alitajran
    LinkedIn:   linkedin.com/in/alitajran

    .CHANGELOG
    V1.00, 09/25/2024 - Initial version
#>

param(
    # Full path for the CSV report (must be provided)
    [Parameter(Mandatory = $true)]
    [string]$OutputPath,

    # Organizational Unit to search for computers (it will search for all computers if not provided)
    [string]$OU = ""
)

# Get the current user's identity
$currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
# Create a principal object from the identity to check roles
$principal = [Security.Principal.WindowsPrincipal]::new($currentIdentity)

# Check if the current user is an administrator
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Only Administrators can read BitLocker Recovery Keys." -ForegroundColor Red
    exit
}

# Determine the search base for computers
if ($OU -ne "") {
    $Computers = Get-ADComputer -Filter 'ObjectClass -eq "computer"' -Property Name, DistinguishedName, OperatingSystem -SearchBase $OU | Sort-Object Name
}
else {
    $Computers = Get-ADComputer -Filter 'ObjectClass -eq "computer"' -Property Name, DistinguishedName, OperatingSystem | Sort-Object Name
}

# Initialize report list
$report = [System.Collections.Generic.List[Object]]::new()

foreach ($computer in $Computers) {
    $params = @{
        Filter     = "objectclass -eq 'msFVE-RecoveryInformation'"
        SearchBase = $computer.DistinguishedName
        Properties = 'msFVE-RecoveryPassword', 'whencreated'
    }

    $bitlockerInfo = Get-ADObject @params | Sort-Object -Property WhenCreated -Descending | Select-Object -First 1

    if ($bitlockerInfo) {
        $ReportLine = [PSCustomObject][ordered]@{
            ComputerName      = $computer.Name
            RecoveryPassword  = $bitlockerInfo.'msFVE-RecoveryPassword'
            RecoveryID        = $bitlockerInfo.Name.Substring(26, 36)
            Date              = $bitlockerInfo.Name.Substring(0, 10)
            Time              = $bitlockerInfo.Name.Substring(11, 8)
            DistinguishedName = $Computer.DistinguishedName
            OperatingSystem   = $Computer.OperatingSystem
        }
        $report.Add($ReportLine)
    }
    else {
        $ReportLine = [PSCustomObject][ordered]@{
            ComputerName      = $computer.Name
            RecoveryPassword  = "No BitLocker information found"
            RecoveryID        = "N/A"
            Date              = "N/A"
            Time              = "N/A"
            DistinguishedName = $Computer.DistinguishedName
            OperatingSystem   = $Computer.OperatingSystem
        }
        $report.Add($ReportLine)
    }
}

# Export the list to CSV
try {
    $report | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding utf8
    Write-Host "Report successfully exported to: $OutputPath" -ForegroundColor Green
}
catch {
    Write-Host "Error exporting report to CSV: $_" -ForegroundColor Red -ErrorAction SilentlyContinue
}