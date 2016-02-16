function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    Stop-Process -Name Explorer
    # Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}

# Install the Azure Resource Manager modules from the PowerShell Gallery 
# NOTE: requires a NuGet .exe, and asks to download and install it first.  Handy, but doesn't work in silent mode, 
# and no way to force it.
<#
Install-Module AzureRM
Install-AzureRM

# Install the Azure Service Management module from the PowerShell Gallery
Install-Module Azure

# Import AzureRM modules for the given version manifest in the AzureRM module
Import-AzureRM

# Import Azure Service Management module
Import-Module Azure
#>

Import-Module ServerManager

# Install AD Administration Tools locally
Add-WindowsFeature RSAT-AD-PowerShell,RSAT-AD-AdminCenter

# Install RRAS role on EDGE
# Install-WindowsFeature RemoteAccess -IncludeManagementTools
# Add-WindowsFeature -name Routing -IncludeManagementTools

invoke-command -computername EDGE {Install-WindowsFeature RemoteAccess -IncludeManagementTools}
invoke-command -computername EDGE {Add-WindowsFeature -name Routing -IncludeManagementTools}

# Run the function to disable IE Enhanced Security
Disable-InternetExplorerESC

