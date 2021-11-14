# .zhenv で無効にした /etc/zshrc を読み込む
if [ -r /etc/zshrc ]; then
	. /etc/zshrc
fi

eval "$(starship init zsh)"
