Write-Host "Disabling Clipboard History..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "AllowClipboardHistory" 0
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "AllowCrossDeviceClipboard" 0
