
# Define folders to revert
$folders = @("Desktop", "Documents", "Pictures", "Music", "Videos", "Downloads")

# Get current user
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$userProfile = [Environment]::GetFolderPath("UserProfile")

foreach ($folder in $folders) {
    try {
        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
        $currentPath = (Get-ItemProperty -Path $regPath -Name $folder -ErrorAction SilentlyContinue).$folder

        if ($currentPath -and $currentPath -ne "%USERPROFILE%\$folder") {
            Write-Host "Reverting $folder from $currentPath to %USERPROFILE%\$folder"

            # Update registry to point back to local profile
            Set-ItemProperty -Path $regPath -Name $folder -Value "%USERPROFILE%\$folder"

            # Move files back if needed
            $source = [Environment]::ExpandEnvironmentVariables($currentPath)
            $destination = Join-Path $userProfile $folder

            if (Test-Path $source) {
                Write-Host "Moving files from $source to $destination"
                Move-Item -Path "$source\*" -Destination $destination -Force -ErrorAction SilentlyContinue
            }
        } else {
            Write-Host "$folder is already local or not redirected."
        }
    } catch {
        Write-Warning "Error processing $folder: $_"
    }
}

# Refresh Explorer to apply changes
Stop-Process -Name explorer -Force
