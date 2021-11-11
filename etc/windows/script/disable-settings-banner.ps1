Write-Host "Disabling Settings Header Banner..." -ForegroundColor Magenta

$path = "HKLM:\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4\4095660171"

if (!(Test-Path $path)) {
	New-Item -Path $path -Force | Out-Null
}

Set-ItemProperty -Path $path -Name "EnabledState" -Type DWord -Value 1
Set-ItemProperty -Path $path -Name "EnabledStateOptions" -Type DWord -Value 1
