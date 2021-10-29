Write-Host "Removing Pinned Tiles from Start Menu..." -ForegroundColor Magenta

. "$env:USERPROFILE\dotfiles\etc\powershell\utils.ps1"

if (!(Test-Privilege)) {
	Write-Error "This script need to run with administrator privilege." -ErrorAction Stop
}


$src = "$env:USERPROFILE\dotfiles\etc\windows"
$dest = "$env:LOCALAPPDATA\Microsoft\Windows\Shell"
$file = "LayoutModification.xml"


## レイアウトファイルを配置
Move-Item -Path "$dest\$file" -Destination "$dest\$file.bak" -Force
Copy-Item -Path "$src\$file" -Destination "$dest\$file" -Force


## タイル情報のキャッシュを削除して初期状態にリセット
$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*`$start.tilegrid`$windows.data.curatedtilecollection.tilecollection"
Remove-Item -Path $path -Recurse -Force


## エクスプローラーの再起動で反映
Write-Host "Restarting Explorer..." -ForegroundColor Yellow
Stop-Process -Name Explorer -Force
