

#LanSchool top-level share
$LSCShare="\\PRS-LSCS\LanSchool\"
#LSC folders
$LSCDirectories=@('Classes','Custom')

#LSC File Paths
$LSCPaths=@()
#Get LSC file list across all folders
Foreach ($folder in $LSCDirectories) {
    $paths=Get-ChildItem -Path $LSCShare$folder -Filter *.lsc | Select-Object Name
    foreach ($file in $paths) {
        $fullPath=$LSCShare+$folder+'\'+$file.Name
        $LSCPaths+=$fullPath
    }
    

}

#Add list the reg key
$key='HKCU:\Software\LanSchool'
$name='RecentClassLists'
New-ItemProperty $key -Name $name -Value $LSCPaths -PropertyType MultiString -Force



$LSCPaths