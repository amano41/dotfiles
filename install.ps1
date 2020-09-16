Write-Host "Installing dotfiles..." -ForegroundColor Magenta


## dotfiles ディレクトリのパス（＝スクリプトの実行パス）を取得
$dotfiles_dir = Split-Path -Parent $MyInvocation.MyCommand.Path


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
	New-Item -ItemType SymbolicLink -Path $env:USERPROFILE -Name $name -Target $dotfiles_dir\$name -Force
}

New-Item -ItemType SymbolicLink -Path $env:USERPROFILE -Name .gitconfig.os -Target $dotfiles_dir\.gitconfig.windows -Force


## WSLtty の設定
## $APPDATA/wsltty に config という名前で .minttyrc のシンボリックリンクを作成

$wsltty_dir = "$env:APPDATA\wsltty"

if (!(Test-Path $wsltty_dir)) {
	New-Item $wsltty_dir -ItemType Directory
}

New-Item -ItemType SymbolicLink -Path $wsltty_dir -Name config -Target $dotfiles_dir\.minttyrc -Force


## VSCode の設定
## $APPDATA/Code に User という名前で .config/Code/User のシンボリックリンクを作成

$vscode_dir = "$env:APPDATA\Code"

if (!(Test-Path $vscode_dir)) {
	New-Item $vscode_dir -ItemType Directory
}

New-Item -ItemType SymbolicLink -Path $vscode_dir -Name User -Target $dotfiles_dir\.config\Code\User -Force


## Windows Terminal の設定
## $LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState に .settings.json のシンボリックリンクを作成

$windows_terminal_dir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"

if (!(Test-Path $windows_terminal_dir)) {
	New-Item $windows_terminal_dir -ItemType Directory
}

New-Item -ItemType SymbolicLink -Path $windows_terminal_dir -Name settings.json -Target $dotfiles_dir\etc\windows-terminal\settings.json -Force
