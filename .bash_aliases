##
## ~/.bash_aliases
##


## PATH
alias path='echo -e ${PATH//:/\\n}'


## ls
alias ls='ls --show-control-chars --color -FH --time-style="+%Y-%m-%d %H:%M:%S" --group-directories-first'
alias la='ls -A'
alias ll='ls -lh'
alias lla='ls -lhA'
alias lt='ls -lhtr'
alias lta='ls -lhtrA'


## grep
alias grep='grep --color'


## python
alias python='python3'


## Git のエイリアスからシェルのエイリアスを定義し，補完も効くようにする
## あらかじめ git-completion.bash を読み込んでおく必要がある

if [ -f /usr/share/bash-completion/completions/git ]; then
	source /usr/share/bash-completion/completions/git
fi

if has "__git_complete"; then

	function add_completion() {

		local c="$1"
		local a="$2"
		local f="_git_$(__git_aliased_command $a | tr '-' '_')"

		if has "$f"; then
			__git_complete "$c" "$f"
		fi
	}

else

	function add_completion() {
		:
	}

fi

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
	add_completion "$cmd" "$a"

done

unset add_completion
