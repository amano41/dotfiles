Write-Host "Disabling Settings Header Banner..." -ForegroundColor Magenta

$base = "HKLM:\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\4"
$keys = @("4095660171", "2674077835")

$keys | ForEach-Object {

	$path = Join-Path $base $_

	if (!(Test-Path $path)) {
		New-Item -Path $path -Force | Out-Null
	}

	Set-ItemProperty -Path $path -Name "EnabledState" -Type DWord -Value 1
	Set-ItemProperty -Path $path -Name "EnabledStateOptions" -Type DWord -Value 1
}
