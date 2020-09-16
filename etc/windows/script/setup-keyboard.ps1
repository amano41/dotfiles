Write-Host "Setting up Keyboard..." -ForegroundColor Magenta

## US 配列に変更
$path = "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters"
Set-ItemProperty $path -Name "LayerDriver JPN" -Type String -Value "kbd101.dll"
Set-ItemProperty $path -Name "OverrideKeyboardIdentifier" -Type String -Value "PCAT_101KEY"
Set-ItemProperty $path -Name "OverrideKeyboardType" -Type DWord -Value 7
Set-ItemProperty $path -Name "OverrideKeyboardSubtype" -Type DWord -Value 0

## CapsLock (0x3a) ⇒ RCtrl (0x1de0)
## RCtrl (0x1de0) ⇒ LCtrl (0x1d)
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" `
	-Name "Scancode Map" `
	-Type Binary `
	-Value (`
		0x00,0x00,0x00,0x00,`
		0x00,0x00,0x00,0x00,`
		0x03,0x00,0x00,0x00,`
		0x1d,0xe0,0x3a,0x00,`
		0x1d,0x00,0x1d,0xe0,`
		0x00,0x00,0x00,0x00 `
	)
