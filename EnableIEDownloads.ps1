#
# This function enables file downloads in the Internet Zone on Internet Exporer in Windows Server.

function Enable-IEDownloads {
    $UserKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"
    Set-ItemProperty -Path $UserKey -Name "1803" -Value 0
    # Write-Host "IE downloads have been enabled." -ForegroundColor Green
}
Enable-IEDownloads