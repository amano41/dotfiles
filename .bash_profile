export LANG=ja_JP.UTF-8
export TZ=JST-9
export LESSCHARSET=utf-8

platform=
case "$OSTYPE" in
	linux*)
		platform="linux"
		;;
	darwin*)
		platform="macos"
		;;
	cygwin | msys)
		platform="windows"
		;;
	*)
		;;
esac

PATH=$HOME/.dotfiles/bin:$PATH
PATH=$HOME/.dotfiles/bin/$platform:$PATH
PATH=$HOME/bin:$PATH
export PATH

[ -f ~/.bashrc ] && source ~/.bashrc
