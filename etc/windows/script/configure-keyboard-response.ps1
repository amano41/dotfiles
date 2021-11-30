Write-Host "Configuring Keyboard Response..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

Set-Registry "HKCU:\Control Panel\Accessibility\Keyboard Response" "AutoRepeatDelay" "500"
Set-Registry "HKCU:\Control Panel\Accessibility\Keyboard Response" "AutoRepeatRate" "50"
Set-Registry "HKCU:\Control Panel\Accessibility\Keyboard Response" "BounceTime" "0"
Set-Registry "HKCU:\Control Panel\Accessibility\Keyboard Response" "DelayBeforeAcceptance" "0"
Set-Registry "HKCU:\Control Panel\Accessibility\Keyboard Response" "Flags" "3"
