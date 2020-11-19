Write-Host "Configuring Keyboard Response..." -ForegroundColor Magenta

$path = "HKCU:\Control Panel\Accessibility\Keyboard Response"

Set-ItemProperty $path -Name "AutoRepeatDelay" -Type String -Value "200"
Set-ItemProperty $path -Name "AutoRepeatRate" -Type String -Value "16"
Set-ItemProperty $path -Name "BounceTime" -Type String -Value "0"
Set-ItemProperty $path -Name "DelayBeforeAcceptance" -Type String -Value "0"
Set-ItemProperty $path -Name "Flags" -Type String -Value "59"
