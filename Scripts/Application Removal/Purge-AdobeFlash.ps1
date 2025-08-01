$SearchString = "*Adobe Flash Player*"

$app = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like $SearchString}

if ($app -ne $null) {
  $app.Uninstall()
  Write-Output ("$app.Name has been uninstalled")
} else {
  Write-Output "Application not found."
}