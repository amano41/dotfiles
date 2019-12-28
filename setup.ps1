##################################################
##  Windows 10 Setup
##################################################


## 管理者権限のチェック
if (!([Security.Principal.WindowsPrincipal]`
      [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
      [Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Warning "This script need to be run with elevated privileges."
	Read-Host "Press any key to exit..."
	exit 1
}


## レジストリに書き込む
function Set-Registry($path, $key, $value) {
	if (!(Test-Path $path)) {
		New-Item -Path $path -Force | Out-Null
	}
	Set-ItemProperty -Path $path -Name $key -Value $value
}


####################  キーボードの設定  ####################

## キーボードを US 配列に変更
$path = "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters"
Set-Registry $path "LayerDriver JPN" "kbd101.dll"
Set-Registry $path "OverrideKeyboardIdentifier" "PCAT_101KEY"
Set-Registry $path "OverrideKeyboardType" 7
Set-Registry $path "OverrideKeyboardSubtype" 0

## CapsLock を Ctrl に変更
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" `
	-Name "Scancode Map" `
	-Type Binary `
	-Value (`
		0x00,0x00,0x00,0x00,`
		0x00,0x00,0x00,0x00,`
		0x02,0x00,0x00,0x00,`
		0x1d,0x00,0x3a,0x00,`
		0x00,0x00,0x00,0x00 `
	)


####################  Windows の設定  ####################

## Cortana を無効化
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" 0

## アクティビティを無効化
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" 0
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "PublishUserActivities" 0
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "UploadUserActivities" 0

## ロック画面を使用しない
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" "NoLockScreen" 1


####################  フォルダオプション  ####################

## 拡張子を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

## 隠しファイル・隠しフォルダ・隠しドライブを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

## クイックアクセスを無効化して PC を開く
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" 1

## 最近使ったファイルをクイックアクセスに表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "ShowRecent" 0

## よく使うフォルダをクイックアクセスに表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "ShowFrequent" 0


####################  個人用設定  ####################

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


####################  設定 → システム → 通知とアクション  ####################

## ロック画面に通知を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" 0

## ロック画面にリマインダーと VolP の着信を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" 0

## Windows へようこその情報を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-310093Enabled" 0

## Windows を使用するためのヒントやおすすめの方法を取得
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SoftLandingEnabled" 0


####################  設定 → プライバシー → Windows のアクセス許可  ####################

## 広告識別子の使用をアプリに許可する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0

## Windows 追跡アプリの起動を許可する　※個人用設定 → スタート → よく使うアプリ で設定済み
## Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackProgs" 0

## 設定アプリでおすすめのコンテンツを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338393Enabled" 0
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-353694Enabled" 0
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-353696Enabled" 0

## 音声認識
Set-Registry "HKCU:\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" "HasAccepted" 0

## 手描き入力
Set-Registry "HKCU:\Software\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" 0

## 診断データ
Set-Registry "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 1

## フィードバックの間隔
Set-Registry "HKCU:\Software\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0


####################  設定 → プライバシー → アプリのアクセス許可  ####################

## 位置情報
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" "Deny"
Set-Registry "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" "SensorPermissionState" 0

## カメラ
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" "Value" "Deny"

## マイク
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}" "Value" "Deny"

## 通知
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}" "Value" "Deny"

## アカウント情報
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" "Value" "Deny"

## 連絡先
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" "Value" "Deny"

## カレンダー
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" "Value" "Deny"

## 通話履歴
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" "Value" "Deny"

## メール
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" "Value" "Deny"

## タスク
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E390DF20-07DF-446D-B962-F5C953062741}" "Value" "Deny"

## メッセージング
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" "Value" "Deny"

## 無線
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" "Value" "Deny"

## 他のデバイス（ペアリングされていないデバイスとの通信）
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" "Value" "Deny"

## バックグラウンドアプリ（アプリのバックグランド実行）
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" 1

## アプリの診断
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2297E4E2-5DBE-466D-A12B-0F8286F0D9CA}" "Value" "Deny"

## ドキュメント
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" "Value" "Deny"

## ピクチャ
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" "Value" "Deny"

## ビデオ
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" "Value" "Deny"

## ファイルシステム
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" "Value" "Deny"


####################  環境変数  ####################

## PATH
$path = [Environment]::GetEnvironmentVariable("PATH", "User")
$path = "$env:OneDrive\bin;" + $path
$path = "$env:USERPROFILE\bin;" + $path
[Environment]::SetEnvironmentVariable("PATH", $path, "User")

## WSLENV
[Environment]::SetEnvironmentVariable("WSLENV", "TMP/p", "User")


####################  ホームディレクトリ  ####################

## $USERPROFILE を H: ドライブとしてマウント
Set-Registry "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices" "H:" "\??\$env:USERPROFILE"


####################  dotfiles  ####################

## dotfiles ディレクトリのパス（＝スクリプトの実行パス）を取得
$dotfiles_dir = Split-Path -Parent $MyInvocation.MyCommand.Path

## dotfiles
## $USERPROFILE にシンボリックリンクを作成

$dotfiles = @(
	".atom",
	".config",
	".editorconfig",
	".gitconfig",
	".Renviron",
	".Rprofile",
	"Rconsole",
	"Rdevga"
)

foreach ($name in $dotfiles) {
	New-Item -ItemType SymbolicLink -Path $env:USERPROFILE -Name $name -Target $dotfiles_dir\$name -Force
}


## WSLtty の設定
## $APPDATA/wsltty に config という名前で .minttyrc のシンボリックリンクを作成

$wsltty_dir = "$env:APPDATA\wsltty"

if (!(Test-Path $wsltty_dir)) {
	New-Item $wsltty_dir -ItemType Directory
}

New-Item -ItemType SymbolicLink -Path $wsltty_dir -Name config -Target $dotfiles_dir\.minttyrc -Force


## VSCode の設定
## $APPDATA/Code に User という名前で .config/Code/User のシンボリックリンクを作成

$vscode_dir = "$env:APPDATA\Code"

if (!(Test-Path $vscode_dir)) {
	New-Item $vscode_dir -ItemType Directory
}

New-Item -ItemType SymbolicLink -Path $vscode_dir -Name User -Target $dotfiles_dir\.config\Code\User -Force


####################  WSL  ####################

## WSL 有効化
Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -NoRestart


####################  Chocolatey  ####################

## Chocolatey のインストール
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

## Chocolatey パッケージのインストール
cinst -y git --params "/GitOnlyOnPath /NoAutoCrlf /NoShellIntegration"
cinst -y 7zip
cinst -y linkshellextension
cinst -y rapidee
cinst -y sysinternals
cinst -y wsltty
cinst -y zazu
cinst -y adobereader
cinst -y ccleaner
cinst -y cubepdf
cinst -y cubepdfutility
cinst -y gitkraken
cinst -y mpc-be
cinst -y python3
cinst -y R.Project
cinst -y R.Studio
cinst -y winmerge
cinst -y winscp


####################  ストアアプリの削除  ####################

$store_apps = @(
	"Microsoft.3DBuilder",
	"Microsoft.BingFinance",
	"Microsoft.BingNews"
	"Microsoft.BingSports",
	"Microsoft.BingWeather",
	"Microsoft.CommsPhone",
	"Microsoft.FreshPaint",
	"Microsoft.GetHelp",
	"Microsoft.Getstarted",
	"Microsoft.Messaging",
	"Microsoft.MicrosoftOfficeHub",
	"Microsoft.MicrosoftSolitaireCollection",
	"Microsoft.MicrosoftStickyNotes",
	"Microsoft.MinecraftUWP",
	"Microsoft.NetworkSpeedTest",
	"Microsoft.Office.OneNote",
	"Microsoft.Office.Sway",
	"Microsoft.OneConnect",
	"Microsoft.People",
	"Microsoft.Print3D",
	"Microsoft.SkypeApp",
	"Microsoft.Windows.Photos",
	"Microsoft.WindowsAlarms",
	"Microsoft.WindowsCalculator",
	"Microsoft.WindowsCamera",
	"Microsoft.WindowsFeedbackHub",
	"Microsoft.WindowsMaps",
	"Microsoft.WindowsPhone",
	"Microsoft.WindowsSoundRecorder",
	"Microsoft.Xbox.TCUI",
	"Microsoft.XboxApp",
	"Microsoft.XboxGamingOverlay",
	"Microsoft.XboxIdentityProvider",
	"Microsoft.YourPhone",
	"Microsoft.ZuneMusic",
	"Microsoft.ZuneVideo",
	"microsoft.windowscommunicationsapps",
	"king.com.BubbleWitch3Saga",
	"king.com.CandyCrushSodaSaga",
	"king.com.*",
	"*Autodesk*",
	"*Dell*",
	"*Facebook*",
	"*Keeper*",
	"*MarchofEmpires*",
	"*Netflix*",
	"*Plex*",
	"*Twitter*",
	"ActiproSoftwareLLC.562882FEEB491",
	"46928bounde.EclipseManager",
	"PandoraMediaInc.29680B314EFC2",
	"D5EA27B7.Duolingo-LearnLanguagesforFree"
)

foreach ($app in $store_apps) {
	Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage
}


####################  END  ####################

Write-Host "Setup Completed."
Pause