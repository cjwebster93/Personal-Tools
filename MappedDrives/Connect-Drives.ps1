# Powershell script to quickly connect default school drives on a non-domain machine
# Initial commit by Craig Webster

param(
    [Parameter(Position=0)]
    [string]$ServerIP=$env:LOGONSERVER
)

#Config
$Drives=@(("teares$","Teachers Resources","T"),("officeres$","Office Resources","O"))
$regpath="HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2"
Write-Host("Server IP is : $ServerIP")

# Attach drives
Foreach ($drive in $Drives) {
    Write-Host("Set Drive Name: " + $drive[1])
    
    $regname = ("##$ServerIP#" + $drive[0])
    New-Item -Path $regpath -Name $regname -Force
    New-ItemProperty -Path "$regpath\$regname" -Name "_LabelFromReg" -PropertyType "String" -Value $drive[1] -Force
    Write-Host('Connect Drive: ' + $drive[2])
    $remotePath=$ServerIP + '\' + $drive[0]
    #New-PSDrive -Name $drive[2] -Root $remotePath -PSProvider FileSystem -Persist
    cmd "net use $drive[2] \\$ServerIP\$drive[0]"
}

