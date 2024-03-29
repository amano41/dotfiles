$dotfiles = $PSScriptRoot

## ヘルパー関数の読み込み
. "$dotfiles\etc\powershell\utils.ps1"

## 管理者権限のチェック
if (!(Test-Privilege)) {
	Write-Error "This script need to be run with elevated privileges." -ErrorAction Stop
}

Write-Host "Installing dotfiles..." -ForegroundColor Magenta


## $USERPROFILE

Get-ChildItem $dotfiles\.* -Exclude .git -Name |
Where-Object {
	$_ -notmatch "\.(linux|macos|cygwin|wsl)$"
} |
ForEach-Object {

	$src = Join-Path $dotfiles $_

	if ($_.EndsWith(".windows")) {
		$dest = Join-Path $env:USERPROFILE ($_ -Replace ".windows", ".os")
	}
	else {
		$dest = Join-Path $env:USERPROFILE $_
	}

	if (Test-Path $dest -PathType Container) {
		$type = Get-Item $dest | Select-Object -ExpandProperty LinkType
		if ($type -ne "SymbolicLink") {
			Remove-Item -Recurse -Path $dest
		}
	}

	New-Symlink $src $dest
}

## R
New-Symlink "$dotfiles\etc\r\Rconsole" "$env:USERPROFILE\Rconsole"
New-Symlink "$dotfiles\etc\r\Rdevga"   "$env:USERPROFILE\Rdevga"


## $USERPROFILE/Documents

## PowerShell Core
New-Symlink `
	"$dotfiles\etc\powershell\Microsoft.PowerShell_profile.ps1" `
	"$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"


## $APPDATA

## WSLtty
New-Symlink "$dotfiles\.minttyrc" "$env:APPDATA\wsltty\config"

## VSCode
New-Symlink "$dotfiles\.config\Code\User" "$env:APPDATA\Code\User"

## RStudio
New-Symlink "$dotfiles\.config\rstudio" "$env:APPDATA\RStudio"

## bat
New-Symlink "$dotfiles\.config\bat\config" "$env:APPDATA\bat\config"

## lsd
New-Symlink "$dotfiles\.config\lsd\config.yaml" "$env:APPDATA\lsd\config.yaml"


## $LOCALAPPDATA

## Windows Terminal
New-Symlink `
	"$dotfiles\etc\windows-terminal\settings.json" `
	"$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"

## SylphyHorn
New-Symlink `
	"$dotfiles\etc\sylphyhorn\Settings.xml" `
	"$env:LOCALAPPDATA\grabacr.net\SylphyHorn\Settings.xml"


## Scoop

$scoop = "$env:USERPROFILE\scoop\persist"

## allrename
New-Symlink "$dotfiles\etc\allrename\allrename.ini" "$scoop\allrename\allrename.ini"

## everything
New-Symlink "$dotfiles\etc\everything\Everything.ini" "$scoop\everything\Everything.ini"

## hiddex
New-Symlink "$dotfiles\etc\hiddex\hiddex.ini" "$scoop\hiddex\hiddex.ini"

## keyhac
New-Symlink "$dotfiles\etc\keyhac\config.py" "$scoop\keyhac\config.py"

## keypirinha
New-Symlink "$dotfiles\etc\keypirinha\User" "$scoop\keypirinha\portable\Profile\User"

## strokesplus.net
New-Symlink "$dotfiles\etc\strokesplus.net\StrokesPlus.net.json" "$scoop\strokesplus.net\StrokesPlus.net.json"

## trayvolume
New-Symlink "$dotfiles\etc\trayvolume\TrayVolume.ini" "$scoop\trayvolume\TrayVolume.ini"
