Write-Host "Disabling Telemetry..."

$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"

if (!(Test-Path $path)) {
	New-Item -Path $path -Force | Out-Null
}

Set-ItemProperty -Path $path -Name "AllowTelemetry" -Type DWord -Value 0
Set-ItemProperty -Path $path -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
