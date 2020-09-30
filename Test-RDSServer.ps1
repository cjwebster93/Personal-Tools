#Get RWS address
$RawAddr = Read-Host -Prompt 'Enter RWS Address'

#Break it  up into IP and port
$addrPart = $RawAddr.Split(":")
$Len      = $addrPart.Count
$Result   = $null

#We process the given address, if the port is unspecified, we assume we're testing the default RWS port
If ($addrPart.Count -gt 1) 
{
    $Result = Test-NetConnection $addrPart[0] -Port $addrPart[1] -ErrorAction SilentlyContinue | Select-Object -Property TcpTestSucceeded
}
else 
{
    $Result = Test-NetConnection $addrPart[0] -CommonTCPPort RDP -ErrorAction SilentlyContinue | Select-Object -Property TcpTestSucceeded
}

#Inform the user whether or not the TCP test was a success
If ($Result -eq $true) 
{
    Write-Host "Connection Successful!"
}
else 
{
    Write-Host "Connection failed!"
}