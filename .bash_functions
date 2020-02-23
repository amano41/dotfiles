##
## ~/.bash_functions
##


## cd
function cd() {
	command cd "$@"
	local s=$?
	if [[ ($s -eq 0) && (${#FUNCNAME[*]} -eq 1) ]]; then
		history -s cd $(printf "%q" $(pwd))
	fi
	return $s
}


## ls + less
function ls() {

	if [[ $# -eq 0 ]]; then
		eval command ls $LS_OPTIONS
		return
	fi

	for arg in "$@"
	do
		if [[ ($arg == -*) || (-d $arg) ]]; then
			eval command ls $LS_OPTIONS "$@"
			return
		fi
	done

	less "$@"
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

	if [[ $# -eq 0 ]]; then

		git status -sb

		echo

		local h=$(git symbolic-ref HEAD 2>/dev/null)
		local u=$(git rev-parse --symbolic-full-name @{u} 2>/dev/null)
		git log -n 10 --graph --oneline --decorate ${h:+--decorate-refs="$h"} ${u:+--decorate-refs="$u"}

		return
	fi

	git "$@"
}

if has "__git_complete"; then
	__git_complete g __git_main
fi
