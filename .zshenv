# /etc 以下の設定ファイルを無視
# /etc/zprofile, /etc/zshrc, /etc/zlogin, /etc/zlogout
unsetopt GLOBAL_RCS

export PATH
export MANPATH

# パスを重複させない
typeset -U PATH path MANPATH manpath

# /etc/zprofile からコピー
# システムレベルの設定を読み込む
if [ -x /usr/libexec/path_helper ]; then
	eval `/usr/libexec/path_helper -s`
fi

# path
path=(
	~/bin(N-/)
	~/dotfiles/bin/macos(N-/)
	~/dotfiles/bin(N-/)
	/opt/homebrew/opt/coreutils/libexec/gnubin(N-/)
	/opt/homebrew/opt/findutils/libexec/gnubin(N-/)
	/opt/homebrew/opt/gnu-sed/libexec/gnubin(N-/)
	/opt/homebrew/opt/gnu-tar/libexec/gnubin(N-/)
	/opt/homebrew/opt/grep/libexec/gnubin(N-/)
	/opt/homebrew/bin(N-/)
	/usr/local/bin(N-/)
	/usr/bin(N-/)
	/bin(N-/)
	/opt/homebrew/sbin(N-/)
	/usr/sbin(N-/)
	/sbin(N-/)
	${path}
)

manpath=(
	/opt/homebrew/opt/coreutils/libexec/gnuman(N-/)
	/opt/homebrew/opt/findutils/libexec/gnuman(N-/)
	/opt/homebrew/opt/gnu-sed/libexec/gnuman(N-/)
	/opt/homebrew/opt/gnu-tar/libexec/gnuman(N-/)
	/opt/homebrew/opt/grep/libexec/gnuman(N-/)
	${manpath}
)
