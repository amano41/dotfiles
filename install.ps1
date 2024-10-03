$dotfiles = $PSScriptRoot


## ==================================================
## 管理者権限のチェック
## ==================================================

if (!([Security.Principal.WindowsPrincipal]`
		[Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
		[Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Error "This script need to be run with elevated privileges." -ErrorAction Stop
}


## ==================================================
## シンボリックリンクを作成する関数
## ==================================================

function New-Symlink($src, $dest) {

	if (!(Test-Path $src)) {
		Write-Error "No such file or directory: $src" -ErrorAction Stop
	}

	$src = Resolve-Path $src

	if (Test-Path $dest -PathType Container) {
		$type = Get-Item $dest | Select-Object -ExpandProperty LinkType
		if ($type -ne "SymbolicLink") {
			$name = Split-Path -Leaf $src
			$dest = Join-Path $dest $name
		}
	}

	$path = Split-Path -Parent $dest
	$name = Split-Path -Leaf $dest

	if (!($path)) {
		$path = "."
	}

	if (!(Test-Path $path)) {
		New-Item -Path $path -ItemType Directory | Out-Null
	}

	New-Item -ItemType SymbolicLink -Path $path -Name $name -Target $src -Force | Out-Null
	Write-Host "$src`t===>`t$path\$name"
}


## ==================================================
## home
## ==================================================

Get-ChildItem $dotfiles\home |
ForEach-Object {

	$src = $_.FullName
	$dest = Join-Path $env:USERPROFILE $_.Name

	if (Test-Path $dest -PathType Container) {
		$type = Get-Item $dest | Select-Object -ExpandProperty LinkType
		if ($type -ne "SymbolicLink") {
			Remove-Item -Recurse -Path $dest
		}
	}

	New-Symlink $src $dest
}


## ==================================================
## win
## ==================================================

Get-ChildItem $dotfiles\win -File |
ForEach-Object {

	$src = $_.FullName
	$dest = Join-Path $env:USERPROFILE $_.Name

	New-Symlink $src $dest
}


## ==================================================
## AppData/Local
## ==================================================

## Windows Terminal
New-Symlink `
	"$dotfiles\win\AppData\Local\windows-terminal\settings.json" `
	"$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

## SylphyHorn
New-Symlink `
	"$dotfiles\win\AppData\Local\sylphyhorn\Settings.xml" `
	"$env:LOCALAPPDATA\hwtnb.net\SylphyHornPlus\Settings.xml"


## ==================================================
## AppData/Roaming
## ==================================================

## WSLtty
New-Symlink `
	"$dotfiles\home\.minttyrc" `
	"$env:APPDATA\wsltty\config"

## RStudio
New-Symlink `
	"$dotfiles\home\.config\rstudio" `
	"$env:APPDATA\RStudio"

## bat
New-Symlink `
	"$dotfiles\home\.config\bat\config" `
	"$env:APPDATA\bat\config"

## lsd
New-Symlink `
	"$dotfiles\home\.config\lsd\config.yaml" `
	"$env:APPDATA\lsd\config.yaml"


## ==================================================
## Documents
## ==================================================

## PowerShell Core
New-Symlink `
	"$dotfiles\win\Documents\powershell\Microsoft.PowerShell_profile.ps1" `
	"$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"


## ==================================================
## Scoop
## ==================================================

## keyhac
New-Symlink `
	"$dotfiles\win\scoop\keyhac\config.py" `
	"$env:USERPROFILE\scoop\persist\keyhac\config.py"

## keypirinha
New-Symlink `
	"$dotfiles\win\scoop\keypirinha\User" `
	"$env:USERPROFILE\scoop\persist\keypirinha\portable\Profile\User"
