HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:ls *:ll:ll *:la:la *:cd:cd -:pwd:history:exit"
HISTTIMEFORMAT="%F %T  "  ## Display Timestamp (YYYY-MM-DD hh:mm:ss)

if [ -e "${HOME}/.bash_alias" ]; then
	source "${HOME}/.bash_alias"
fi
