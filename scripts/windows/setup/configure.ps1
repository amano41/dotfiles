#Requires -Version 7.0
#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"


## ==================================================
## レジストリに書き込むヘルパー関数
## ==================================================

function Set-Registry($path, $key, $value) {
	try {
		if (!(Test-Path $path)) {
			New-Item -Path $path -Force -ErrorAction Stop | Out-Null
		}
		Set-ItemProperty -Path $path -Name $key -Value $value -ErrorAction Stop | Out-Null
	}
	catch {
		Write-Warning "Failed to set registry: $path\$key = $value ($($_.Exception.Message))"
	}
}


## ==================================================
## キーボードの設定
## ==================================================

Write-Host "Setting up Keyboard..." -ForegroundColor Magenta

# US 配列に変更
Set-Registry "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" "LayerDriver JPN" "kbd101.dll"
Set-Registry "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" "OverrideKeyboardIdentifier" "PCAT_101KEY"
Set-Registry "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" "OverrideKeyboardType" 7
Set-Registry "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" "OverrideKeyboardSubtype" 0

# RCtrl (0xE01D) ← CapsLock (0x003A)
# F13 (0x0064) ← RCtrl (0xE01D)
# リトルエンディアンで入力する必要がある
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" `
	-Name "Scancode Map" `
	-Type Binary `
	-Value (`
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, `
		0x03, 0x00, 0x00, 0x00, `
		0x1D, 0xE0, 0x3A, 0x00, `
		0x64, 0x00, 0x1D, 0xE0, `
		0x00, 0x00, 0x00, 0x00 `
)

# キーリピートを高速化
Set-Registry "HKCU:\Control Panel\Accessibility\Keyboard Response" "AutoRepeatDelay" "500"
Set-Registry "HKCU:\Control Panel\Accessibility\Keyboard Response" "AutoRepeatRate" "50"
Set-Registry "HKCU:\Control Panel\Accessibility\Keyboard Response" "BounceTime" "0"
Set-Registry "HKCU:\Control Panel\Accessibility\Keyboard Response" "DelayBeforeAcceptance" "0"
Set-Registry "HKCU:\Control Panel\Accessibility\Keyboard Response" "Flags" "3"

# 低レベルフックのタイムアウト時間を長めにする
Set-Registry "HKCU:\Control Panel\Desktop" "LowLevelHooksTimeout" 1000


## ==================================================
## マウスの設定
## ==================================================

Write-Host "Setting up Mouse..." -ForegroundColor Magenta

# ポインターのサイズ： 16 * (size + 1)
Set-Registry "HKCU:\Control Panel\Cursors" "CursorBaseSize" 80

# ポインターの色
Set-Registry "HKCU:\Control Panel\Cursors" "(Default)" "Windows Inverted"

# カーソル速度
Set-Registry "HKCU:\Control Panel\Mouse" "MouseSensitivity" "20"

# 一度にスクロールする行数
Set-Registry "HKCU:\Control Panel\Desktop" "WheelScrollLines" "9"


## ==================================================
## マシンレベルの設定
## ==================================================

Write-Host "Setting up Group Policies Options..." -ForegroundColor Magenta

# ロック画面を無効にする
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" "NoLockScreen" 1

# Web 検索を無効にする
Set-Registry "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" 1

# アクティビティ履歴を無効にする
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" 0
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "PublishUserActivities" 0
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "UploadUserActivities" 0

# クリップボード履歴を無効にする
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "AllowClipboardHistory" 0
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "AllowCrossDeviceClipboard" 0

# 診断＆フィードバックを無効にする
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "DoNotShowFeedbackNotifications" 1

# ナビゲーションウィンドウの HDD を非表示にする
if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}") {
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
}


## ==================================================
## エクスプローラーの設定
## ==================================================

Write-Host "Setting up Explorer Options..." -ForegroundColor Magenta

# 拡張子を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

# 隠しファイル・隠しフォルダ・隠しドライブを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

# チェックボックスを使用しない
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "AutoCheckSelect" 0

# タイトルバーにフルパスを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" 1

# クイックアクセスを無効化して PC を開く
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" 1

# 最近使ったファイルをクイックアクセスに表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "ShowRecent" 0

# よく使うフォルダをクイックアクセスに表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "ShowFrequent" 0


## ==================================================
## デスクトップアイコンの設定
## ==================================================

Write-Host "Setting up Desktop Icons..." -ForegroundColor Magenta

# PC を非表示にする
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" 1

# ユーザーフォルダを非表示にする
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" 1

# ネットワークを非表示にする
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" 1

# ごみ箱を非表示にする
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{645FF040-5081-101B-9F08-00AA002F954E}" 1

# コントロールパネルを非表示にする
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" 1

# ライブラリを非表示にする
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{031E4825-7B94-4dc3-B131-E946B44C8DD5}" 1

# OneDrive を非表示にする
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{018D5C66-4533-4307-9B53-224DE2ED1FE6}" 1


## ==================================================
## タスクバーボタンの設定
## ==================================================

Write-Host "Setting up Taskbar Buttons..." -ForegroundColor Magenta

# 検索ボックスを非表示にする
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" 0

# タスクビューボタンを非表示にする
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowTaskViewButton" 0

# Windows Ink ワークスペースボタンを非表示にする
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace" "PenWorkspaceButtonDesiredVisibility" 0
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" "AllowWindowsInkWorkspace" 0

# タッチキーボードボタンを非表示にする
Set-Registry "HKCU:\SOFTWARE\Microsoft\TabletTip\1.7" "TipbandDesiredVisibility" 0


## ==================================================
## 設定 → 個人用設定
## ==================================================

Write-Host "Setting up Personalization..." -ForegroundColor Magenta

# ロック画面：ロック画面にトリビアやヒントなどの情報を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "RotatingLockScreenOverlayEnabled" 0

# スタート：よく使うアプリを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackProgs" 0

# スタート：ときどきスタートメニューにおすすめのアプリを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" 0

# スタート：スタートメニューまたはタスクバーのジャンプリストに最近開いた項目を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackDocs" 0

# タスクバー：デスクトップをプレビューする
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "DisablePreviewDesktop" 1

# エクスプローラーの再起動で反映
Write-Host "Restarting Explorer..."
Stop-Process -Name Explorer -Force

# タスクバー：タスクバーボタンを結合する
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarGlomLevel" 0

# タスクバー：タスクバーをすべてのディスプレイに表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "MMTaskbarEnabled" 0


## ==================================================
## 設定 → システム → 通知とアクション
## ==================================================

Write-Host "Setting up Notifications..." -ForegroundColor Magenta

# ロック画面に通知を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" 0

# ロック画面にリマインダーと VolP の着信を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" 0

# Windows へようこその情報を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-310093Enabled" 0

# Windows を使用するためのヒントやおすすめの方法を取得
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SoftLandingEnabled" 0


## ==================================================
## 設定 → プライバシー → Windows のアクセス許可
## ==================================================

Write-Host "Setting up Privacy..." -ForegroundColor Magenta

# 広告識別子の使用をアプリに許可する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0

# Windows 追跡アプリの起動を許可する　※個人用設定 → スタート → よく使うアプリ　と同じレジストリエントリ
# Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackProgs" 0

# 設定アプリでおすすめのコンテンツを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" 0
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-353694Enabled" 0
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-353696Enabled" 0

# 音声認識
Set-Registry "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" "HasAccepted" 0

# 手描き入力
Set-Registry "HKCU:\Software\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" 0

# フィードバックの間隔
Set-Registry "HKCU:\Software\Microsoft\Siuf\Rules" "PeriodInNanoSeconds" 0
Set-Registry "HKCU:\Software\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0

## ==================================================
## 設定 → プライバシー → アプリのアクセス許可
## ==================================================

Write-Host "Setting up Permissions..." -ForegroundColor Magenta

# 位置情報
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" "Deny"

# カメラ
# Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" "Value" "Deny"
# Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" "Value" "Deny"

# マイク
# Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" "Value" "Deny"
# Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" "Value" "Deny"

# 音声によるアクティブ化
Set-Registry "HKCU:\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" "AgentActivationEnabled" 0

# 通知
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" "Value" "Deny"

# アカウント情報
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" "Value" "Deny"

# 連絡先
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" "Value" "Deny"

# カレンダー
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointment" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointment" "Value" "Deny"

# 電話をかける
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" "Value" "Deny"

# 通話履歴
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" "Value" "Deny"

# メール
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" "Value" "Deny"

# タスク
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" "Value" "Deny"

# メッセージング
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" "Value" "Deny"

# 無線
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" "Value" "Deny"

# 他のデバイス（ペアリングされていないデバイスとの通信）
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" "Value" "Deny"

# バックグラウンドアプリ（アプリのバックグランド実行）
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" 1

# アプリの診断
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" "Value" "Deny"

# ドキュメント
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" "Value" "Deny"

# ピクチャ
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" "Value" "Deny"

# ビデオ
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" "Value" "Deny"

# ファイルシステム
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" "Value" "Deny"
