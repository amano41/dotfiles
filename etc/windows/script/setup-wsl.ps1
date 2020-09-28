Write-Host "Setting up WSL..." -ForegroundColor Magenta

Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -All -NoRestart
Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online -All -NoRestart

wsl --set-default-version 2
