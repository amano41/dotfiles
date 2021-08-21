##################################################
##  Windows 10 Setup
##################################################


## 管理者権限のチェック
if (!([Security.Principal.WindowsPrincipal]`
      [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
      [Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Error "This script need to be run with elevated privileges." -ErrorAction Stop
}


## カレントディレクトリを変更
Push-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)


## レジストリ操作用のヘルパー関数を読み込む
. "./script/registry-helper.ps1"


####################  システムレベルの設定  ####################


## キーボードの設定
. "./script/setup-keyboard.ps1"


## ロック画面を無効化
. "./script/disable-lock-screen.ps1"


## Cortana を無効化・削除
. "./script/disable-cortana.ps1"
. "./script/remove-cortana.ps1"


## アクティビティ履歴を無効化
. "./script/disable-activity-history.ps1"


## クリップボード履歴を無効化
. "./script/disable-clipboard-history.ps1"


## 診断＆フィードバックを無効化
. "./script/disable-telemetry.ps1"


## ストアアプリの削除
. "./script/remove-store-apps.ps1"


## WSL を有効化
. "./script/setup-wsl.ps1"


## 3D Objects を非表示
. "./script/hide-3d-objects.ps1"


## ナビゲーションウィンドウの HDD を非表示
. "./script/hide-removable-drives.ps1"


####################  ユーザーレベルの設定  ####################


## フォルダオプションの設定
. "./script/setup-explorer.ps1"


## デスクトップのアイコンを非表示
. "./script/hide-desktop-icons.ps1"


## 設定 → 個人用設定
. "./script/configure-personalization-settings.ps1"


## 設定 → システム → 通知とアクション
. "./script/configure-notifications-settings.ps1"


## 設定 → プライバシー
. "./script/configure-privacy-settings.ps1"


## キーリピートを高速化
. "./script/configure-keyboard-response.ps1"


## 環境変数の設定
. "./script/set-environment-variables.ps1"


## PowerShell モジュールのインストール
. "./script/install-powershell-modules.ps1"


## scoop のセットアップ
. "./script/install-scoop.ps1"
. "./script/install-scoop-packages.ps1"
. "./script/setup-jre.ps1"
. "./script/setup-everything-service.ps1"


## Python パッケージのインストール
. "./script/install-python-packages.ps1"


####################  終了  ####################


Pop-Location
Write-Host "Setup Completed." -ForegroundColor Magenta
