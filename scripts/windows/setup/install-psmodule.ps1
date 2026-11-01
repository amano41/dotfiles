#Requires -Version 7.0

$ErrorActionPreference = "Stop"


## ==================================================
## PowerShell モジュールのインストール
## ==================================================

Write-Host "Installing Powershell Modules..." -ForegroundColor Magenta

Install-PSResource -Name PSFzf -Repository PSGallery -Scope CurrentUser -TrustRepository
