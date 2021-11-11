Write-Host "Hiding Taskbar Buttons..." -ForegroundColor Magenta


try {
	Get-Command -Name "Set-Registry" -ErrorAction Stop | Out-Null
}
catch {
	. "$env:USERPROFILE\dotfiles\etc\powershell\utils.ps1"
}


## 検索ボックス
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" "SearchboxTaskbarMode" 0

## タスクビューボタン
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowTaskViewButton" 0

## People
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" "PeopleBand" 0

## Windows Ink ワークスペースボタン
Set-Registry "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace" "PenWorkspaceButtonDesiredVisibility" 0

## Windows Ink ワークスペースの無効化
Set-Registry "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" "AllowWindowsInkWorkspace" 0

## タッチキーボードボタン
Set-Registry "HKCU:\SOFTWARE\Microsoft\TabletTip\1.7" "TipbandDesiredVisibility" 0
