Write-Host "Configuring Personalization Settings..." -ForegroundColor Magenta


try {
	Get-Command -Name "Set-Registry" -ErrorAction Stop | Out-Null
}
catch {
	. "$env:USERPROFILE\dotfiles\etc\powershell\utils.ps1"
}


## ロック画面：ロック画面にトリビアやヒントなどの情報を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "RotatingLockScreenOverlayEnabled" 0

## スタート：よく使うアプリを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackProgs" 0

## スタート：ときどきスタートメニューにおすすめのアプリを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" 0

## スタート：スタートメニューまたはタスクバーのジャンプリストに最近開いた項目を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackDocs" 0

## タスクバー：タスクバーをロックする
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarSizeMove" 0

## タスクバー：デスクトップをプレビューする
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "DisablePreviewDesktop" 1

## タスクバー：画面上のタスクバーの位置　⇒　左
$path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3"
$name = "Settings"
$value = (Get-ItemProperty -Path $path -Name $name).Settings
$value[12] = 0
Set-ItemProperty -Path $path -Name $name -Value $value

Write-Host "Restarting Explorer..." -ForegroundColor Yellow
Stop-Process -Name Explorer -Force

## タスクバー：タスクバーボタンを結合する
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarGlomLevel" 2

## タスクバー：タスクバーをすべてのディスプレイに表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "MMTaskbarEnabled" 0
