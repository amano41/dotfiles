Write-Host "Disabling Cortana..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" 0
