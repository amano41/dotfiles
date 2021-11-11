Write-Host "Disabling Cortana..." -ForegroundColor Magenta

$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
$name = "AllowCortana"

if (!(Test-Path $path)) {
	New-Item -Path $path -Force | Out-Null
}

Set-ItemProperty -Path $path -Name $name -Type DWord -Value 0
