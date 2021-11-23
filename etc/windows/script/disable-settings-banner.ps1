Write-Host "Disabling Settings Header Banner..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

Set-Registry "HKLM:\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4\4095660171" "EnabledState" 1
Set-Registry "HKLM:\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4\4095660171" "EnabledStateOptions" 1

Set-Registry "HKLM:\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4\2674077835" "EnabledState" 1
Set-Registry "HKLM:\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4\2674077835" "EnabledStateOptions" 1
