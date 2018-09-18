umask 022


export LANG=ja_JP.UTF-8
export TZ=JST-9
export LESSCHARSET=utf-8


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

PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/dotfiles/bin:$PATH"
PATH="$HOME/dotfiles/bin/$platform:$PATH"
PATH="$HOME/bin:$PATH"
export PATH


## less でシンタックスハイライト
export LESS='-R'
export LESSOPEN='| src-hilite-lesspipe.sh %s'


[ -f ~/.bashrc ] && source ~/.bashrc
