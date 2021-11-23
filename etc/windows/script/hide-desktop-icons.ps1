Write-Host "Hiding Desktop Icons..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join(Split(Split$PSScriptRoot)) "powershell\utils.ps1")
}

## PC
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" 1

## ユーザーフォルダ
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" 1

## ネットワーク
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" 1

## ごみ箱
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{645FF040-5081-101B-9F08-00AA002F954E}" 1

## コントロールパネル
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" 1

## ライブラリ
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{031E4825-7B94-4dc3-B131-E946B44C8DD5}" 1

## OneDrive
Set-Registry "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" "{018D5C66-4533-4307-9B53-224DE2ED1FE6}" 1
