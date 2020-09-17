Write-Host "Installing dotfiles..." -ForegroundColor Magenta


## dotfiles ディレクトリのパス（＝スクリプトの実行パス）を取得
$dotfiles_dir = Split-Path -Parent $MyInvocation.MyCommand.Path


## シンボリックリンクを作成する関数
function Symlink($src, $dest) {

	$path = Split-Path -Parent $dest
	$name = Split-Path -Leaf $dest

	if (!(Test-Path $path)) {
		New-Item $path -ItemType Directory
	}

	New-Item -ItemType SymbolicLink -Path $path -Name $name -Target $src -Force
}


## dotfiles
## $USERPROFILE にシンボリックリンクを作成

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


## $APPDATA にシンボリックリンクを作成

## WSLtty
Symlink "$dotfiles_dir\.minttyrc" "$env:APPDATA\wsltty\config"

## VSCode
Symlink "$dotfiles_dir\.config\Code\User" "$env:APPDATA\Code\User"


## $LOCALAPPDATA にシンボリックリンクを作成

## Windows Terminal
Symlink "$dotfiles_dir\etc\windows-terminal\settings.json" `
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
