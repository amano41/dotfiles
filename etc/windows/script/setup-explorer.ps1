Write-Host "Setting up Explorer..."

$explorer = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
$advanced = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

if (!(Test-Path $advanced)) {
	New-Item -Path $advanced -Force | Out-Null
}

## 拡張子を表示する
Set-ItemProperty -Path $advanced -Name "HideFileExt" -Type DWord -Value 0

## 隠しファイル・隠しフォルダ・隠しドライブを表示する
Set-ItemProperty -Path $advanced -Name "Hidden" -Type DWord -Value 1

## クイックアクセスを無効化して PC を開く
Set-ItemProperty -Path $advanced -Name "LaunchTo" -Type DWord -Value 1

## 最近使ったファイルをクイックアクセスに表示する
Set-ItemProperty -Path $explorer -Name "ShowRecent" -Type DWord -Value 0

## よく使うフォルダをクイックアクセスに表示する
Set-ItemProperty -Path $explorer -Name "ShowFrequent" -Type DWord -Value 0
