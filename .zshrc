# .zhenv で無効にした /etc/zshrc を読み込む
if [ -r /etc/zshrc ]; then
	. /etc/zshrc
fi

# zsh-completions
if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

	autoload -Uz compinit
	compinit
fi

eval "$(starship init zsh)"
