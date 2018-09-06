## PATH

alias path='echo -e ${PATH//:/\\n}'


## ls

alias ls='ls --show-control-chars --color -FH --time-style="+%Y-%m-%d %H:%M:%S" --group-directories-first'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -lA'
alias lt='ls -lt'
alias lta='ls -ltA'


## grep

alias grep='grep --color'


## Git のエイリアスからシェルのエイリアスを定義し，補完も効くようにする
## あらかじめ git-completion.bash を読み込んでおく必要がある

if [ -f /usr/share/bash-completion/completions/git ]; then
	source /usr/share/bash-completion/completions/git
fi

if has "__git_complete"; then

	for a in $(git --list-cmds=alias);
	do

		## 長いエイリアスはスキップ
		if [ ${#a} -gt 3 ]; then
			continue
		fi

		cmd="g$a"

		## 定義済みの場合はスキップ
		if has "$cmd"; then
			continue
		fi

		## シェルのエイリアスを定義
		alias "$cmd"="git $a"

		## シェルのエイリアスでも補完が効くようにする
		func="_git_$(__git_aliased_command $a | tr '-' '_')"
		if has "$func"; then
			__git_complete "$cmd" "$func"
		fi
	done

fi
