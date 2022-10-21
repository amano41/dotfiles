# コンソールの出力を UTF-8 にする
[Console]::OutputEncoding = [Text.Encoding]::UTF8


##################################################
# 環境変数
##################################################

$env:PAGER = "less"
$env:LESS = "-iMR -z-4 -#4 -x4"

$env:LS_OPTIONS = "-FH --color=auto --group-directories-first --show-control-chars --time-style=`"+%Y-%m-%d %H:%M:%S`""

$env:PYTHONUTF8 = 1
$env:PYTHONDONTWRITEBYTECODE = 1
$env:PIPENV_VENV_IN_PROJECT = 1


##################################################
# PSReadLine
##################################################

# Emacs モード
Set-PSReadLineOption -EditMode Emacs

# ベル音を鳴らさない
Set-PSReadLineOption -BellStyle Visual

# 履歴を重複させない
Set-PSReadlineOption -HistoryNoDuplicates

# 履歴に残さないコマンドを指定
Set-PSReadlineOption -AddToHistoryHandler {
	param ([string]$command)

	# 3 文字未満のコマンドは履歴に残さない
	if ($command.length -lt 3) {
		return $False
	}

	# 再利用しないコマンドは履歴に残さない
	$disabled = "exit|help|history|cd|ls|dir"
	return ($command -notmatch "^($disabled)$")
}

# 履歴からサジェストを表示
Set-PSReadLineOption -PredictionSource History

# 履歴からコマンドを選んだら末尾にカーソルを移動
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# 単語境界を日本語に対応させる
Set-PSReadLineOption -WordDelimiters ";:,.[]{}()/\|^&*-=+'`" !?@#$%&_<>「」（）『』『』［］、，。：；／"


##################################################
# ヘルパー関数
##################################################

. "$env:USERPROFILE\dotfiles\etc\powershell\utils.ps1"


##################################################
# クッップボード
##################################################

Set-Alias -Name pbcopy -Value Set-Clipboard
Set-Alias -Name pbpaste -Value Get-Clipboard


##################################################
# uutils/coreutils
##################################################

@(
	"cat", "cp", "cut", "date", "echo", "head", "join", "mkdir", "mktemp", "mv",
	"paste", "printenv", "pwd", "rm", "rmdir", "seq", "tac", "tail", "touch", "tr",
	"uniq", "wc"
) | ForEach-Object {
	$cmd = $_
	if (Test-Path -Path Alias:$cmd) {
		Remove-Item -Path Alias:$cmd
	}
	Invoke-Expression "function $cmd() { `$input | uutils $cmd `$args }"
}


##################################################
# コマンドの置き換え
##################################################

Set-Alias -Name cat -Value bat -Force

function ls() { lsd $args }
function la() { lsd -A $args }
function ll() { lsd -l $args }
function lla() { lsd -lA $args }

function tree() { lsd --tree $args }

@( "history", "h", "ls", "la", "ll", "lla", "tree" ) | ForEach-Object {
	$cmd = $_
	If (Test-Path -Path Alias:$cmd) {
		Remove-Item -Path Alias:$cmd
	}
}


##################################################
# open
##################################################

function open() {

	Param(
		[String]$Path = "."
	)

	If (!(Test-Path -Path $Path)) {
		Write-Error "No such file or directory: $Path" -ErrorAction Stop
	}

	$Path = Resolve-Path -Path $Path

	# ディレクトリの場合は As/R で開く
	If (Test-Path -Path $Path -PathType Container) {
		$Asr = Join-Path $env:USERPROFILE "bin/asr/AsrLoad.exe"
		Start-Process -FilePath $Asr -ArgumentList "/x", "/n", $Path
	}

	# ファイルの場合は関連づけで開く
	Else {
		Start-Process -FilePath $Path
	}

}


##################################################
# history
##################################################

function history() {

	Param(
		[String] $Keyword = "",
		[Int] $Count = 30
	)

	$Path = (Get-PSReadLineOption).HistorySavePath
	$Data = Get-Content -Path $Path -Tail 1000 | ForEach-Object { "$($_.ReadCount)`t$_" }

	if ([string]::IsNullOrEmpty($Keyword)) {
		if ($Count -gt 0) {
			$Data[($Data.Length - $Count)..$Data.Length]
		}
		else {
			$Data
		}
	}
	else {
		$Data[$Data.Length..0] | `
			ConvertFrom-String -Delimiter "`t" -PropertyNames "Number", "Command" | `
			Sort-Object -Property "Command" -Unique | `
			Where-Object -Property "Command" -Match $Keyword | `
			Sort-Object -Property "Number" | `
			Select-Object "Number", "Command" | `
			rg $Keyword
	}
}

Set-Alias -Name h -Value history -Force


##################################################
# git
##################################################

function _git() {
	if ($Args.Length -eq 0) {
		git status -sb
		Write-Host
		git log -n 15 --oneline --graph --decorate
	}
	else {
		git $Args
	}
}

Set-Alias -Name g -Value _git -Force


##################################################
# fzf / PSFzf
##################################################

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t'
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'

$env:FZF_DEFAULT_COMMAND = "fd --type f"
$env:FZF_DEFAULT_OPTS = "--height 80% --reverse --border --ansi --no-sort --cycle --sync " + `
                        "--bind=ctrl-/:toggle-preview,shift-left:preview-page-up,shift-right:preview-page-down"

$env:FZF_CTRL_T_COMMAND = "fd --type f --hidden --follow --exclude .git"
$env:FZF_CTRL_T_OPTS = "--preview `"bat --color=always --style=numbers --line-range=:100 {}`""

$env:FZF_ALT_C_COMMAND = "fd --type d"
$env:FZF_ALT_C_OPTS = "--preview `"lsd -A --icon=never --color=always --group-dirs=first {}`""


##################################################
# zoxide
##################################################

Invoke-Expression (& {
	$hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
	(zoxide init --hook $hook powershell --cmd j) -join "`n"
})


##################################################
# posh-git
##################################################

Import-Module posh-git


##################################################
# Starship
##################################################

Invoke-Expression (&starship init powershell)
