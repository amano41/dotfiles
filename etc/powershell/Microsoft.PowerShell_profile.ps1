# コンソールの出力を UTF-8 にする
[Console]::OutputEncoding = [Text.Encoding]::UTF8


##################################################
# 環境変数
##################################################

$env:PAGER = "less"
$env:LESS = "-iMR -z-4 -#4 -x4"

$env:LS_OPTIONS = "-FH --color=auto --group-directories-first --show-control-chars --time-style=`"+%Y-%m-%d %H:%M:%S`""


##################################################
# PSReadLine
##################################################

# Emacs モード
Set-PSReadLineOption -EditMode Emacs

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

# 管理者権限があるかチェックする関数
function Test-Privilege {
	return ([Security.Principal.WindowsPrincipal]`
	        [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
	        [Security.Principal.WindowsBuiltInRole] "Administrator")
}

# シンボリックリンクを作成する関数
function Symlink($src, $dest) {

	if (Test-Path $dest -PathType Container) {
		$type = Get-Item $dest | Select-Object -ExpandProperty LinkType
		if ($type -ne "SymbolicLink") {
			Write-Warning "'$dest' already exists."
			$backup = "$dest" + "." + (Get-Date -UFormat "%Y%m%d%H%M%S")
			Move-Item $dest $backup
		}
	}
	Write-Host "----"

	$path = Split-Path -Parent $dest
	$name = Split-Path -Leaf $dest

	if (!(Test-Path $path)) {
		New-Item $path -ItemType Directory
	}

	New-Item -ItemType SymbolicLink -Path $path -Name $name -Target $src -Force
}

# 上書きせずにコピーする関数
function SafeCopy($src, $dest) {

	if (Test-Path $dest) {
		Write-Warning "'$dest' already exists."
		$backup = "$dest" + "." + (Get-Date -UFormat "%Y%m%d%H%M%S")
		Move-Item $dest $backup
	}

	$path = Split-Path -Parent $dest

	if (!(Test-Path $path)) {
		New-Item $path -ItemType Directory
	}

	Copy-Item $src $dest
}

# ショートカットを作成する関数
function Create-Shortcut($src, $dest, $opts="") {
	$wsh = New-Object -ComObject WScript.Shell
	$lnk = $wsh.CreateShortcut($dest)
	$lnk.TargetPath = $src
	$lnk.Arguments = $opts
	$lnk.Save()
}


##################################################
# エイリアス
##################################################

Set-Alias -Name pbcopy -Value Set-Clipboard
Set-Alias -Name pbpaste -Value Get-Clipboard


##################################################
# uutils/coreutils
##################################################

@(
	"cat", "cp", "cut", "date", "echo", "head", "mkdir", "mktemp", "mv", "printenv",
	"pwd", "rm", "rmdir", "seq", "tac",	"tail", "touch", "tr", "uniq", "wc"
) | ForEach-Object {
	$cmd = $_
	if (Test-Path -Path Alias:$cmd) {
		Remove-Item -Path Alias:$cmd
	}
	Invoke-Expression "function global:$cmd() { `$input | uutils $cmd `$args }"
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

Remove-Alias ls
function global:ls() { lsd $args }
function global:la() { lsd -A $args }
function global:ll() { lsd -l $args }
function global:lla() { lsd -lA $args }

function global:tree() { lsd --tree $args }


##################################################
# fzf / PSFzf
##################################################

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t'
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'


##################################################
# zoxide
##################################################

Invoke-Expression (& {
	$hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
	(zoxide init --hook $hook powershell) -join "`n"
})


##################################################
# Starship
##################################################

Invoke-Expression (&starship init powershell)
