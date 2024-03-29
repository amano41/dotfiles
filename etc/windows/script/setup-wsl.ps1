Write-Host "Setting up WSL..." -ForegroundColor Magenta

$OldProgressPreference = $ProgressPreference
$ProgressPreference = "SilentlyContinue"

Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -All -NoRestart | Out-Null
Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform -Online -All -NoRestart | Out-Null

$ProgressPreference = $OldProgressPreference

if (Get-Command -Name "wsl" -ErrorAction SilentlyContinue) {
	wsl --set-default-version 2 | Out-Null
}
else {
	Write-Warning "WSL not installed."
	Write-Warning "You need to run 'wsl --set-default-version 2' after installing WSL."
}
