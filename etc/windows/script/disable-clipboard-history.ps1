Write-Host "Disabling Clipboard History..." -ForegroundColor Magenta

$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"

if (!(Test-Path $path)) {
	New-Item -Path $path -Force | Out-Null
}

Set-ItemProperty -Path $path -Name "AllowClipboardHistory" -Type DWord -Value 0
Set-ItemProperty -Path $path -Name "AllowCrossDeviceClipboard" -Type DWord -Value 0
