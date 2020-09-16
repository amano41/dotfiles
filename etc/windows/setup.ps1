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


## レジストリ操作用のヘルパー関数を読み込む
. "./script/registry-helper.ps1"


####################  システムレベルの設定  ####################


## キーボードの設定
. "./script/setup-keyboard.ps1"


## ロック画面を無効化
. "./script/disable-lock-screen.ps1"


## Cortana を無効化
. "./script/disable-cortana.ps1"


## アクティビティ履歴を無効化
. "./script/disable-activity-history.ps1"


## クリップボード履歴を無効化
. "./script/disable-clipboard-history.ps1"


## 診断＆フィードバックを無効化
. "./script/disable-telemetry.ps1"


## WSL を有効化
. "./script/setup-wsl.ps1"


####################  ユーザーレベルの設定  ####################


## フォルダオプションの設定
. "./script/setup-explorer.ps1"


## 設定 → 個人用設定
. "./script/configure-personalization-settings.ps1"


## 設定 → システム → 通知とアクション
. "./script/configure-notifications-settings.ps1"


## 設定 → プライバシー
. "./script/configure-privacy-settings.ps1"


## 環境変数の設定
. "./script/set-environment-variables.ps1"


## scoop のセットアップ
. "./script/setup-scoop.ps1"


## ストアアプリの削除
. "./script/remove-store-apps.ps1"


## 終了
Write-Host "Setup Completed."
Pause
