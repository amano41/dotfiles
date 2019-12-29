## パーミッション
umask 022


## ロケールとタイムゾーン
export LANG=ja_JP.UTF-8
export TZ=JST-9
export LESSCHARSET=utf-8


## 実行環境の判別
platform=
case "$OSTYPE" in
	linux*)
		if [[ $(uname -a) =~ Microsoft ]]; then
			platform="wsl"
		else
			platform="linux"
		fi
		;;
	darwin*)
		platform="macos"
		;;
	cygwin | msys)
		platform="cygwin"
		;;
	*)
		;;
esac


## パス
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/dotfiles/bin:$PATH"
PATH="$HOME/dotfiles/bin/$platform:$PATH"
PATH="$HOME/bin:$PATH"
export PATH


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


[ -f ~/.bashrc ] && source ~/.bashrc
