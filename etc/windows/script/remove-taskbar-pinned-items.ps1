Write-Host "Removing Pinned Items from Taskbar..." -ForegroundColor Magenta

## ショートカットを削除
Remove-Item "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.lnk"

## レジストリを初期化
$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband"
Set-ItemProperty -Path "$path" -Name "Favorites" -Type Binary -Value ([byte[]](255))
Remove-ItemProperty -Path "$path" -Name "FavoritesResolve"

## エクスプローラーの再起動で反映
Write-Host "Restarting Explorer..." -ForegroundColor Yellow
Stop-Process -Name Explorer -Force
