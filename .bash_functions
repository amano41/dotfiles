## cd

function cd() {
	command cd "$@"
	local s=$?
	if [[ ($s -eq 0) && (${#FUNCNAME[*]} -eq 1) ]]; then
		history -s cd $(printf "%q" $(pwd))
	fi
	return $s
}


## history

function h() {
	case $# in
		0) history | tac | sort -k 4 -u | sort | tail -30 ;;
		*) history | tac | sort -k 4 -u | sort | grep "$@" ;;
	esac
}


## git

function g() {
	case $# in
		0) git status -sb && echo && git log -n 10 --graph --oneline --no-decorate ;;
		*) git "$@" ;;
	esac
}

if has "__git_complete"; then
	__git_complete g __git_main
fi
