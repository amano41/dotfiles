Write-Host "Disabling Web Search..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

Set-Registry "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" 1
