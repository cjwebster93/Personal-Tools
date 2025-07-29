#Created by Craig Webster

$client = Read-Host -Prompt "Enter the remote computer name"
$test = New-PSSession -ComputerName $client
If (-not $test) {
    $cred = Get-Credential
}
Write-Host("Opening PSSession...")
$sess = New-PSSession -ComputerName $client -Credential $cred
Enter-PSSession $sess