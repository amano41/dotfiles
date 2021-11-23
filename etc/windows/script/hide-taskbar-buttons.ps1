Write-Host "Hiding Taskbar Buttons..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

## 検索ボックス
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" 0

## ニュースと関心事
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" "ShellFeedsTaskbarViewMode" 2
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" "EnableFeeds" 0

## タスクビューボタン
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowTaskViewButton" 0

## People
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" "PeopleBand" 0
Set-Registry "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" "HidePeopleBar" 1

## Windows Ink ワークスペースボタン
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace" "PenWorkspaceButtonDesiredVisibility" 0
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" "AllowWindowsInkWorkspace" 0

## タッチキーボードボタン
Set-Registry "HKCU:\SOFTWARE\Microsoft\TabletTip\1.7" "TipbandDesiredVisibility" 0
