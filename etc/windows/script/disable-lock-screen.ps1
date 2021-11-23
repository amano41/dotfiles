Write-Host "Disabling Lock Screen..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" "NoLockScreen" 1
