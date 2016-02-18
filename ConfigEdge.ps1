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
function Unzip-File {

<#
.SYNOPSIS
   Unzip-File is a function which extracts the contents of a zip file.

.DESCRIPTION
   Unzip-File is a function which extracts the contents of a zip file specified via the -File parameter to the
location specified via the -Destination parameter. This function first checks to see if the .NET Framework 4.5
is installed and uses it for the unzipping process, otherwise COM is used.

.PARAMETER File
    The complete path and name of the zip file in this format: C:\zipfiles\myzipfile.zip 
 
.PARAMETER Destination
    The destination folder to extract the contents of the zip file to. If a path is no specified, the current path
is used.

.PARAMETER ForceCOM
    Switch parameter to force the use of COM for the extraction even if the .NET Framework 4.5 is present.

.EXAMPLE
   Unzip-File -File C:\zipfiles\AdventureWorks2012_Database.zip -Destination C:\databases\

.EXAMPLE
   Unzip-File -File C:\zipfiles\AdventureWorks2012_Database.zip -Destination C:\databases\ -ForceCOM

.EXAMPLE
   'C:\zipfiles\AdventureWorks2012_Database.zip' | Unzip-File

.EXAMPLE
    Get-ChildItem -Path C:\zipfiles | ForEach-Object {$_.fullname | Unzip-File -Destination C:\databases}

.INPUTS
   String

.OUTPUTS
   None

.NOTES
   Author:  Mike F Robbins
   Website: http://mikefrobbins.com
   Twitter: @mikefrobbins

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, 
                   ValueFromPipeline=$true)]
        [ValidateScript({
            If ((Test-Path -Path $_ -PathType Leaf) -and ($_ -like "*.zip")) {
                $true
            }
            else {
                Throw "$_ is not a valid zip file. Enter in 'c:\folder\file.zip' format"
            }
        })]
        [string]$File,

        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            If (Test-Path -Path $_ -PathType Container) {
                $true
            }
            else {
                Throw "$_ is not a valid destination folder. Enter in 'c:\destination' format"
            }
        })]
        [string]$Destination = (Get-Location).Path,

        [switch]$ForceCOM
    )


    If (-not $ForceCOM -and ($PSVersionTable.PSVersion.Major -ge 3) -and
       ((Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Full" -ErrorAction SilentlyContinue).Version -like "4.5*" -or
       (Get-ItemProperty -Path "HKLM:\Software\Microsoft\NET Framework Setup\NDP\v4\Client" -ErrorAction SilentlyContinue).Version -like "4.5*")) {

        Write-Verbose -Message "Attempting to Unzip $File to location $Destination using .NET 4.5"

        try {
            [System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
            [System.IO.Compression.ZipFile]::ExtractToDirectory("$File", "$Destination")
        }
        catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }


    }
    else {

        Write-Verbose -Message "Attempting to Unzip $File to location $Destination using COM"

        try {
            $shell = New-Object -ComObject Shell.Application
            $shell.Namespace($destination).copyhere(($shell.NameSpace($file)).items())
        }
        catch {
            Write-Warning -Message "Unexpected Error. Error details: $_.Exception.Message"
        }

    }

}
Unzip-File -File C:\labfiles\labfiles.zip -Destination C:\labfiles\
Import-Module ServerManager

# Install AD Administration Tools locally
# Add-WindowsFeature RSAT-AD-PowerShell,RSAT-AD-AdminCenter

# Install RRAS role on EDGE
Install-WindowsFeature RemoteAccess -IncludeManagementTools
Add-WindowsFeature -name Routing -IncludeManagementTools

#invoke-command -computername EDGE {Install-WindowsFeature RemoteAccess -IncludeManagementTools}
#invoke-command -computername EDGE {Add-WindowsFeature -name Routing -IncludeManagementTools}

# Run the functions to disable IE Enhanced Security and enable IE downloads
Disable-InternetExplorerESC
