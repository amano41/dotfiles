Write-Host "Disabling Cortana..."

$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"

if (!(Test-Path $path)) {
	New-Item -Path $path -Force | Out-Null
}

Set-ItemProperty -Path $path -Name "AllowCortana" -Type DWord -Value 0
