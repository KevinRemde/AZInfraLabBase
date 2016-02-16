function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    Stop-Process -Name Explorer
    # Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}

function Enable-IEDownloads {
    $UserKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"
    Set-ItemProperty -Path $UserKey -Name "1803" -Value 0
    # Write-Host "IE downloads have been enabled." -ForegroundColor Green
}
Enable-IEDownloads

Import-Module ServerManager

# Install AD Administration Tools locally
Add-WindowsFeature RSAT-AD-PowerShell,RSAT-AD-AdminCenter

# Install RRAS role on EDGE
# Install-WindowsFeature RemoteAccess -IncludeManagementTools
# Add-WindowsFeature -name Routing -IncludeManagementTools

#invoke-command -computername EDGE {Install-WindowsFeature RemoteAccess -IncludeManagementTools}
#invoke-command -computername EDGE {Add-WindowsFeature -name Routing -IncludeManagementTools}

# Run the functions to disable IE Enhanced Security and enable IE downloads
Disable-InternetExplorerESC

