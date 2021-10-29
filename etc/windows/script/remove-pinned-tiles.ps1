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

## グループポリシー「スタート画面のレイアウト」のレジストリを設定
## 一時的にユーザーがカスタマイズできないようにする
$reg = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
if (!(Test-Path $reg)) {
	New-Item -Path $reg -Force | Out-Null
}
Set-ItemProperty -Path $reg -Name "LockedStartLayout" -Type DWord -Value 1
Set-ItemProperty -Path $reg -Name "StartLayoutFile" -Type String -Value "$src\$file"

Write-Host "Restarting Explorer..." -ForegroundColor Yellow
Stop-Process -Name Explorer -Force

Write-Host "Waiting 10s for Explorer to Complete Restarting..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

## グループポリシーを削除
Remove-ItemProperty -Path $reg -Name "LockedStartLayout" -Force
Remove-ItemProperty -Path $reg -Name "StartLayoutFile" -Force

Write-Host "Restarting Explorer..." -ForegroundColor Yellow
Stop-Process -Name Explorer -Force
