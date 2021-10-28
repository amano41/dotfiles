Write-Host "Setting up Mouse..." -ForegroundColor Magenta

# ポインターのサイズ： 16 * (size + 1)
Set-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "CursorBaseSize" -Type DWord -Value 80

# ポインターの色
Set-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "(Default)" -Type String -Value "Windows Inverted"

# カーソル速度
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSensitivity" -Type String -Value "20"

# 一度にスクロールする行数
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WheelScrollLines" -Type String -Value "9"
