Write-Host "Hiding Removable Drives From Navigation Pane..." -ForegroundColor Magenta

$path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"

if (Test-Path $path) {
	Remove-Item -Path $path
}
