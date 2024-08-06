# .zhenv で無効にした /etc/zshrc を読み込む
if [ -r /etc/zshrc ]; then
	. /etc/zshrc
fi

# autopushd
setopt AUTO_PUSHD
setopt PUSHD_SILENT
setopt PUSHD_IGNORE_DUPS
DIRSTACKSIZE=20

# 履歴
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY
HISTSIZE=10000
SAVEHIST=10000

# タイプミスの訂正
setopt CORRECT

# zsh-completions
if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

	autoload -Uz compinit
	compinit
fi

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# エイリアス
alias "l"="ls"
alias "la"="ls -A"
alias "ll"="ls -lh"
alias "lla"="ls -lhA"
alias "lt"="ls -lhtr"
alias "lta"="ls -lhtrA"

## grep
alias "grep"="grep --color"

## python
alias "python"="python3"
alias "pip"="python3 -m pip"

## git
alias "g"="git"

eval "$(starship init zsh)"
