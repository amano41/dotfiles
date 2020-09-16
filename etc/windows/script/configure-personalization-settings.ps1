Write-Host "Configuring Personalization Settings..."


try {
	Get-Command -Name "Set-Registry" -ErrorAction Stop | Out-Null
}
catch {
	. (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "registry-helper.ps1")
}


## ロック画面：ロック画面にトリビアやヒントなどの情報を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "RotatingLockScreenOverlayEnabled" 0

## スタート：よく使うアプリを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackProgs" 0

## スタート：ときどきスタートメニューにおすすめのアプリを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" 0

## スタート：スタートメニューまたはタスクバーのジャンプリストに最近開いた項目を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackDocs" 0

## タスクバー：タスクバーをすべてのディスプレイに表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "MMTaskbarEnabled" 0
