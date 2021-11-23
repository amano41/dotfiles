Write-Host "Setting up Explorer..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

## 拡張子を表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0

## 隠しファイル・隠しフォルダ・隠しドライブを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1

## チェックボックスを使用しない
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "AutoCheckSelect" 0

## タイトルバーにフルパスを表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" "FullPath" 1

## クイックアクセスを無効化して PC を開く
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" 1

## 最近使ったファイルをクイックアクセスに表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "ShowRecent" 0

## よく使うフォルダをクイックアクセスに表示する
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "ShowFrequent" 0
