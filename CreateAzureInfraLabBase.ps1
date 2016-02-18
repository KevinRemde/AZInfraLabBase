<#
 Deploy the Azure Infrastructure Lab Machines
 Note: Requires the most recent AzureRM commandlets.  If you haven't recently installed the latest, you'd better do it now.

 This automation builds:

 DC - Domain Controller (contoso.com domain)
 ADMIN - Adminstrative server
 EDGE - dual-homed routing server
 SYNC - server for 

 All servers are members of contoso.com
 All machines other than DC contain the downloaded Lab files and scripts.

 Yet to do:
 ALL - Automate the unzip and proper placement of the labfiles.
ADMIN - Automate the installation of RSAT ADUC, Azure PowerShell. (Leave GIT, GitHub Desktop, and VS Code as an exercise)
EDGE - Automate the istallation of Routing and Remote Access.

.SYNOPSIS 
   This script is used to create a starting point for the Azure ITPRO Camp lab exercises. 
   After logging in to your subscription, The script creates globally unique DNS names for the 4 lab machines on which
   you will perform you lab exercises.  Then the script launches the creation of the 4 lab machines.
   NOTE: The lab machines will take 30-45 minutes to be fully provisioned.
.DESCRIPTION | USAGE
   IMPORTANT: Before running this script, please note that you will be prompted to provide your intitials.
   These intials are used to determine a unique name for the machine dns names. For these names,
   you must use all lower case letters or numbers. No hyphens or other characters are allowed.
      
#> 

# Sign into Azure

Login-AzureRmAccount
Get-AzureRmSubscription | Select-AzureRmSubscription 


# collect initials for generating unique names

$init = Read-Host -Prompt "Please type your initials in lower case, and then press ENTER."


# Prompt for the Azure region in which to build the lab machines

Write-Host ""
Write-Host "Where in the world do you want to put these lab VMs?"
Write-Host "Carefully enter 'East US' or 'West US'"
$loc = Read-Host -Prompt "and then press ENTER."


# Variables 

$rgName = "RG-AZLAB" + $init
# $deploymentName = $init + "AZLab"  # Not required
$assetLocation = "https://rawgit.com/KevinRemde/AZInfraLabBase/master/"
$templateFileURI  = $assetLocation + "azuredeploy.json"
$parameterFileURI = $assetLocation + "azuredeploy.parameters.json" # Use only if you want to use Kevin's defaults (not recommended)


# Use Test-AzureRmDnsAvailability to create and verify unique DNS names.	
#
# Based on the initials entered, find unique DNS names for the four virtual machines.
# NOTE: You may be wondering why I'm not also looking for unique storage account names.  
# Those names are created by the template using randomly generated complex names, based on 
# the resource group ID.

$machine = "dc"
$uniquename = $false
$counter = 0
while ($uniqueName -eq $false) {
    $counter ++
    $dnsPrefix = "$machine" + "dns" + "$init" + "$counter" 
    if (Test-AzureRmDnsAvailability -DomainNameLabel $dnsPrefix -Location $loc) {
        $uniquename = $true
        $dcDNSVMName = $dnsPrefix
    }
} 
	
$machine = "admin"
$uniquename = $false
$counter = 0
while ($uniqueName -eq $false) {
    $counter ++
    $dnsPrefix = "$machine" + "dns" + "$init" + "$counter" 
    if (Test-AzureRmDnsAvailability -DomainNameLabel $dnsPrefix -Location $loc) {
        $uniquename = $true
        $adminDNSVMName = $dnsPrefix
    }
} 

$machine = "edge"
$uniquename = $false
$counter = 0
while ($uniqueName -eq $false) {
    $counter ++
    $dnsPrefix = "$machine" + "dns" + "$init" + "$counter" 
    if (Test-AzureRmDnsAvailability -DomainNameLabel $dnsPrefix -Location $loc) {
        $uniquename = $true
        $edgeDNSVMName = $dnsPrefix
    }
} 

$machine = "sync"
$uniquename = $false
$counter = 0
while ($uniqueName -eq $false) {
    $counter ++
    $dnsPrefix = "$machine" + "dns" + "$init" + "$counter" 
    if (Test-AzureRmDnsAvailability -DomainNameLabel $dnsPrefix -Location $loc) {
        $uniquename = $true
        $syncDNSVMName = $dnsPrefix
    }
} 

# Populate the parameter object with parameter values for the azuredeploy.json template to use.

$parameterObject = @{
    "location" = "$loc"
    "dcDNSVMName" = $dcDNSVMName 
    "dcVMSize" = "Standard_D1"
    "adminDNSVMName" = $adminDNSVMName 
    "adminVMSize" = "Standard_D1"
    "edgeDNSVMName" = $edgeDNSVMName 
    "edgeVMSize" = "Standard_D2"
    "syncDNSVMName" = $syncDNSVMName 
    "syncVMSize" = "Standard_D1"
    "domainName" = "contoso.com"
    "domainUserName" = "labAdmin"
    "domainPassword" = "Passw0rd!"
    "vmUserName" = "labAdmin"
    "vmPassword" = "Passw0rd!"
    "assetLocation" = $assetLocation
}



# Create the resource group

New-AzureRMResourceGroup -Name $rgname -Location $loc

# Build the lab machines. 
# Note: takes approx. 30 minutes to complete.

Write-Host ""
Write-Host "Deploying the VMs.  This will take 30-45 minutes to complete."
Write-Host "Started at" (Get-Date -format T)
Write-Host ""

Measure-Command -expression {New-AzureRMResourceGroupDeployment -ResourceGroupName $rgName -TemplateUri $templateFileURI -TemplateParameterObject $parameterObject}

Write-Host ""
Write-Host "Completed at" (Get-Date -format T)


# use only if you want to use Kevin's default parameters (not recommended)
# New-AzureRMResourceGroupDeployment -ResourceGroupName $rgName -TemplateUri $templateFileURI -TemplateParameterUri $parameterFileURI


# Shut down all lab VMs in the Resource Group when you're not using them.
# Get-AzureRmVM -ResourceGroupName $rgName | Stop-AzureRmVM -Force

# Restart them when you're continuing the lab.
# Get-AzureRmVM -ResourceGroupName $rgName | Start-AzureRmVM 


# Delete the entire resource group (and all of its VMs and other objects).
# Remove-AzureRmResourceGroup -Name $rgName -Force


