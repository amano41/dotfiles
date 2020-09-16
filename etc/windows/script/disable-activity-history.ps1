Write-Host "Disabling Activity History..." -ForegroundColor Magenta

$path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"

if (!(Test-Path $path)) {
	New-Item -Path $path -Force | Out-Null
}

Set-ItemProperty -Path $path -Name "EnableActivityFeed" -Type DWord -Value 0
Set-ItemProperty -Path $path -Name "PublishUserActivities" -Type DWord -Value 0
Set-ItemProperty -Path $path -Name "UploadUserActivities" -Type DWord -Value 0
