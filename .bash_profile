export LANG=ja_JP.UTF-8
export TZ=JST-9
export LESSCHARSET=utf-8

export PATH=$HOME/bin:$PATH

## Display current branch on bash prompt
if [ -e /etc/bash_completion.d/git-prompt.sh ]; then
	source /etc/bash_completion.d/git-prompt.sh
	export GIT_PS1_SHOWDIRTYSTATE=true
	export GIT_PS1_SHOWSTASHSTATE=true
	export GIT_PS1_SHOWUNTRACKEDFILES=true
	export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[36m\]$(__git_ps1)\[\e[0m\]\n\$ '
else
	export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
fi

if [ -e "${HOME}/.bashrc" ]; then
	source "${HOME}/.bashrc"
fi
