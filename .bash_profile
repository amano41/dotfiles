##
## ~/.bash_profile
##


## パーミッション
umask 022


## ロケールとタイムゾーン
export LANG=ja_JP.UTF-8
export TZ=JST-9
export LESSCHARSET=utf-8


## 実行環境の判別
PLATFORM=
case "$OSTYPE" in
	linux*)
		if [[ $(uname -a) =~ [Mm]icrosoft ]]; then
			PLATFORM="wsl"
		else
			PLATFORM="linux"
		fi
		;;
	darwin*)
		PLATFORM="mac"
		;;
	cygwin | msys)
		PLATFORM="cygwin"
		;;
	*)
		;;
esac


## パス
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/dotfiles/bin:$PATH"
PATH="$HOME/dotfiles/bin/$PLATFORM:$PATH"
PATH="$HOME/bin:$PATH"
export PATH


## エディタとページャー
export EDITOR=vim
export PAGER=less


## ls の表示オプション
export LS_OPTIONS='-FH --color --group-directories-first --show-control-chars --time-style="+%Y-%m-%d %H:%M:%S"'


## ls のカラー設定 $LS_COLORS
if [[ -f ~/.dircolors ]]; then
	eval "$(dircolors -b ~/.dircolors)"
fi


## less でシンタックスハイライト
export LESS='-iJMRW -z-4 -#4 -x4'
export LESSOPEN='| src-hilite-lesspipe.sh %s'


## man をカラー表示
export LESS_TERMCAP_mb=$'\e[1;31m'  # enter blinking mode
export LESS_TERMCAP_md=$'\e[1;33m'  # enter double-bright (bold) mode
export LESS_TERMCAP_me=$'\e[0m'     # turn off all appearance modes
export LESS_TERMCAP_so=$'\e[7m'     # enter standout (reverse video) mode
export LESS_TERMCAP_se=$'\e[0m'     # leave standout (reverse video) mode
export LESS_TERMCAP_us=$'\e[4;36m'  # enter underline mode
export LESS_TERMCAP_ue=$'\e[0m'     # leave underline mode


## Pipenv でプロジェクトディレクトリに仮想環境を作成
export PIPENV_VENV_IN_PROJECT=true


if [[ -f ~/.bashrc ]]; then
	source ~/.bashrc
fi
