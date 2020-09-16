Write-Host "Setting up WSL..." -ForegroundColor Magenta

Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -NoRestart
