Write-Host "Disabling Lock Screen..."

$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"

if (!(Test-Path $path)) {
	New-Item -Path $path -Force | Out-Null
}

Set-ItemProperty -Path $path -Name "NoLockScreen" -Type DWord -Value 1
