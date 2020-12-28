if (!([Security.Principal.WindowsPrincipal]`
			[Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
			[Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Error "This script need to be run with elevated privileges." -ErrorAction Stop
}

$script_dir = Join-Path $env:USERPROFILE "dotfiles\etc\windows\script"

. $script_dir\setup-jre.ps1
. $script_dir\setup-everything-service.ps1
