Write-Host "Disabling Activity History..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" 0
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "PublishUserActivities" 0
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "UploadUserActivities" 0
