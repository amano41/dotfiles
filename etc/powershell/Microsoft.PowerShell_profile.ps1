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
# WslInterop
##################################################

# コマンドの読み込み
Import-WslCommand "apt", "awk", "find", "grep", "man", "sed", "ssh", "sudo"

# コマンドのデフォルト引数
$WslDefaultParameterValues = @{}
$WslDefaultParameterValues["grep"] = "--color"
$WslDefaultParameterValues["less"] = $env:LESS
$WslDefaultParameterValues["ls"] = $env:LS_OPTIONS

# 環境変数
$WslEnvironmentVariables = @{}
$WslEnvironmentVariables["LS_COLORS"] = "rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=01;30;40:ow=01;34;40:st=37;44:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"


##################################################
# コマンドの置き換え
##################################################

Set-Alias -Name cat -Value bat -Force

function ls() { lsd $args }
function la() { lsd -A $args }
function ll() { lsd -l $args }
function lla() { lsd -lA $args }

function tree() { lsd --tree $args }

@( "ls", "la", "ll", "lla", "tree" ) | ForEach-Object {
	$cmd = $_
	If (Test-Path -Path Alias:$cmd) {
		Remove-Item -Path Alias:$cmd
	}
}


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
