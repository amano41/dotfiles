Write-Host "Setting up WSL..." -ForegroundColor Magenta

Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -All -NoRestart
Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online -All -NoRestart

if (Get-Command -Name "wsl" -ErrorAction SilentlyContinue) {
	wsl --set-default-version 2
}
else {
	Write-Warning "WSL not installed."
	Write-Warning "You need to run 'wsl --set-default-version 2' after installing WSL."
}
