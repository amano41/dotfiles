Write-Host "Setting up Keyboard..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

## US 配列に変更
Set-Registry "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" "LayerDriver JPN" "kbd101.dll"
Set-Registry "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" "OverrideKeyboardIdentifier" "PCAT_101KEY"
Set-Registry "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" "OverrideKeyboardType" 7
Set-Registry "HKLM:\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters" "OverrideKeyboardSubtype" 0

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
