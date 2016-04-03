# 
# Set group policy for Internet Explorer on member servers.
# NOTE: This is not recommended for production servers, and only being done to allow servers in the lab
# environment to be able to easily download files.
#
# The settings being enabled:
# - Allow file downloads in the Internet Zone

Import-Module grouppolicy

# Get the GPO
$gpo = Get-GPO -Name "Default Domain Policy" -Domain "contoso.com" 

# Add the policy to allow downloads
$key = 'HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3'
$params = @{
    Key = $key;
    ValueName = '1803';
    Value = 0;
    Type = 'Dword';
}
$gpo | Set-GPRegistryValue @params

