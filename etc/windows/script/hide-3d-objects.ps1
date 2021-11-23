Write-Host "Hiding 3D Objects from Explorer..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" "ThisPCPolicy" "Hide"
