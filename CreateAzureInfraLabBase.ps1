#
# Deploy the Azure Infrastructure Lab Machines
# Note: Requires the most recent AzureRM commandlets
#
# This automation builds:
#
# DC - Domain Controller (contoso.com domain)
# ADMIN - Adminstrative server
# EDGE - dual-homed routing server
# SYNC - server for 
#
# All servers are members of contoso.com
# All machines other than DC contain the downloaded Lab files and scripts.
#
# Yet to do:
# ALL - Automate the unzip and proper placement of the labfiles.
# ADMIN - Automate the installation of RSAT ADUC, Azure PowerShell. (Leave GIT, GitHub Desktop, and VS Code as an exercise)
# EDGE - Automate the istallation of Routing and Remote Access.
###

###
# Login to your Azure Account

Login-AzureRmAccount

###
# Variables 

$loc = "West US" # Must remain West US for now. The parameter file defines location as West US
$rgName = "RG-AZLAB"
$deploymentName = "xxxAZLab"
$assetLocation = "https://rawgit.com/KevinRemde/AZInfraLabBase/master/"
$templateFileURI  = $assetLocation + "azuredeploy.json"
$parameterFileURI = $assetLocation + "azuredeploy.parameters.json"

###
# Create the resource group

New-AzureRMResourceGroup -Name $rgname -Location $loc

###
# Build the lab machines. 
# Note: takes approx. 30 minutes to complete.

New-AzureRMResourceGroupDeployment -Name $deploymentName -ResourceGroupName $rgName -TemplateParameterUri $parameterFileURI -TemplateUri $templateFileURI
