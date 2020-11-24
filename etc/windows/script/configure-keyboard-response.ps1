Write-Host "Configuring Keyboard Response..." -ForegroundColor Magenta

$path = "HKCU:\Control Panel\Accessibility\Keyboard Response"

Set-ItemProperty $path -Name "AutoRepeatDelay" -Type String -Value "300"
Set-ItemProperty $path -Name "AutoRepeatRate" -Type String -Value "50"
Set-ItemProperty $path -Name "BounceTime" -Type String -Value "0"
Set-ItemProperty $path -Name "DelayBeforeAcceptance" -Type String -Value "0"
Set-ItemProperty $path -Name "Flags" -Type String -Value "59"
