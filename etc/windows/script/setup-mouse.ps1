Write-Host "Setting up Mouse..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

# ポインターのサイズ： 16 * (size + 1)
Set-Registry "HKCU:\Control Panel\Cursors" "CursorBaseSize" 80

# ポインターの色
Set-Registry "HKCU:\Control Panel\Cursors" "(Default)" "Windows Inverted"

# カーソル速度
Set-Registry "HKCU:\Control Panel\Mouse" "MouseSensitivity" "20"

# 一度にスクロールする行数
Set-Registry "HKCU:\Control Panel\Desktop" "WheelScrollLines" "9"
