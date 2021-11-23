Write-Host "Configuring Notifications Settings..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

## ロック画面に通知を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" 0

## ロック画面にリマインダーと VolP の着信を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" 0

## Windows へようこその情報を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-310093Enabled" 0

## Windows を使用するためのヒントやおすすめの方法を取得
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SoftLandingEnabled" 0
