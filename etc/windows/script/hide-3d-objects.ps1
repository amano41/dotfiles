Write-Host "Hiding 3D Objects from Explorer..." -ForegroundColor Magenta

$path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"

if (!(Test-Path $path)) {
	New-Item -Path $path -Force | Out-Null
}

Set-ItemProperty -Path $path -Name "ThisPCPolicy" -Type String -Value "Hide"
