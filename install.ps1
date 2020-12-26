## 管理者権限のチェック
if (!([Security.Principal.WindowsPrincipal]`
      [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
      [Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Error "This script need to be run with elevated privileges." -ErrorAction Stop
}


Write-Host "Installing dotfiles..." -ForegroundColor Magenta


## dotfiles ディレクトリのパス（＝スクリプトの実行パス）を取得
$dotfiles_dir = Split-Path -Parent $MyInvocation.MyCommand.Path


## シンボリックリンクを作成する関数
function Symlink($src, $dest) {

	## ディレクトリが存在する場合はバックアップを作成
	## ただし，シンボリックリンクの場合は除く
	if (Test-Path $dest -PathType Container) {
		$type = Get-Item $dest | Select-Object -ExpandProperty LinkType
		if ($type -ne "SymbolicLink") {
			Write-Warning "'$dest' already exists."
			$backup = "$dest" + "." + (Get-Date -UFormat "%Y%m%d%H%M%S")
			Move-Item $dest $backup
		}
	}

	$path = Split-Path -Parent $dest
	$name = Split-Path -Leaf $dest

	if (!(Test-Path $path)) {
		New-Item $path -ItemType Directory
	}

	New-Item -ItemType SymbolicLink -Path $path -Name $name -Target $src -Force
}


## dotfiles

$dotfiles = @(
	".atom",
	".config",
	".editorconfig",
	".gitconfig",
	".Renviron",
	".Rprofile",
	"Rconsole",
	"Rdevga"
)

foreach ($name in $dotfiles) {
	Symlink "$dotfiles_dir\$name" "$env:USERPROFILE\$name"
}

Symlink "$dotfiles_dir\.gitconfig.windows" "$env:USERPROFILE\.gitconfig.os"


## $USERPROFILE にシンボリックリンクを作成

## PowerShell Core
Symlink "$dotfiles_dir\etc\powershell\Microsoft.PowerShell_profile.ps1" `
        "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

## Windows PowerShell
Symlink "$dotfiles_dir\etc\powershell\Microsoft.PowerShell_profile.ps1" `
        "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

## Crevice4
Symlink "$dotfiles_dir\etc\crevice\default.csx" "$env:USERPROFILE\Crevice4\default.csx"


## $APPDATA にシンボリックリンクを作成

## WSLtty
Symlink "$dotfiles_dir\.minttyrc" "$env:APPDATA\wsltty\config"

## VSCode
Symlink "$dotfiles_dir\.config\Code\User" "$env:APPDATA\Code\User"


## $LOCALAPPDATA にシンボリックリンクを作成

## Windows Terminal
Symlink "$dotfiles_dir\etc\windows-terminal\settings.json" `
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

## SylphyHorn
Symlink "$dotfiles_dir\etc\sylphyhorn\Settings.xml" `
        "$env:LOCALAPPDATA\grabacr.net\SylphyHorn\Settings.xml"


## ~/scoop/persist にシンボリックリンクを作成

$scoop_dir = "$env:USERPROFILE\scoop\persist"

## keyhac
Symlink "$dotfiles_dir\etc\keyhac\config.py" "$scoop_dir\keyhac\config.py"

## keypirinha
Symlink "$dotfiles_dir\etc\keypirinha\User" "$scoop_dir\keypirinha\portable\Profile\User"
