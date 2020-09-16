Write-Host "Hiding Desktop Icons..." -ForegroundColor Magenta

$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"

if (!(Test-Path $path)) {
	New-Item -Path $path -Force | Out-Null
}

## PC
Set-ItemProperty -Path $path -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Type DWord -Value 1

## ユーザーフォルダ
Set-ItemProperty -Path $path -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Type DWord -Value 1

## ネットワーク
Set-ItemProperty -Path $path -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Type DWord -Value 1

## ごみ箱
Set-ItemProperty -Path $path -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Type DWord -Value 1

## コントロールパネル
Set-ItemProperty -Path $path -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Type DWord -Value 1

## ライブラリ
Set-ItemProperty -Path $path -Name "{031E4825-7B94-4dc3-B131-E946B44C8DD5}" -Type DWord -Value 1

## OneDrive
Set-ItemProperty -Path $path -Name "{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Type DWord -Value 1
