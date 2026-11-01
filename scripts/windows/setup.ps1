#Requires -Version 7.0

param(
	[switch]$SystemSetup
)

$ErrorActionPreference = "Stop"
$setupDir = Join-Path $PSScriptRoot "setup"

# 管理者権限が必要なシステム初期設定
# SystemSetup フラグが指定されている場合に実行する
if ($SystemSetup) {
	$principal = [Security.Principal.WindowsPrincipal]::new(
		[Security.Principal.WindowsIdentity]::GetCurrent()
	)
	if (-not $principal.IsInRole(
			[Security.Principal.WindowsBuiltInRole]::Administrator
		)) {
		throw "Administrator privileges are required."
	}

	& "$setupDir/configure.ps1"
	& "$setupDir/remove-store-apps.ps1"
	& "$setupDir/install-winget.ps1"

	exit 0
}


# ユーザー権限で実行しているかチェック
if (([Security.Principal.WindowsPrincipal]`
			[Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
			[Security.Principal.WindowsBuiltInRole] "Administrator")) {
	throw "This script should be run as a normal user, not as an administrator."
}


# システム初期設定のために管理者権限で自分を再実行する
Write-Host "Running system setup as administrator..." -ForegroundColor Magenta
& sudo (Join-Path $PSHOME "pwsh.exe") -NoProfile -File "$PSCommandPath" -SystemSetup

if ($LASTEXITCODE -ne 0) {
	throw "System setup failed (exit code $LASTEXITCODE)."
}


# Scoop のインストール
& "$setupDir/install-scoop.ps1"

# PS Module のインストール
& "$setupDir/install-psmodule.ps1"

# 環境変数の設定
& "$setupDir/set-environment.ps1"

# chezmoi で使用する age 秘密鍵
$key = Join-Path $HOME ".config/chezmoi/key.txt"

if (-not (Test-Path $key -PathType Leaf)) {
	Write-Host "Place the age identity at: $key" -ForegroundColor Yellow
	Read-Host "Press Enter when ready"

	if (-not (Test-Path $key -PathType Leaf)) {
		throw "Age identity not found: $key"
	}
}

# dotfiles を反映
Write-Host "Applying dotfiles via chezmoi..." -ForegroundColor Magenta
& chezmoi apply

if ($LASTEXITCODE -ne 0) {
	throw "chezmoi apply failed (exit code $LASTEXITCODE)."
}

Write-Host "Setup completed." -ForegroundColor Green
