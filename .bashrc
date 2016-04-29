IGNOREEOF=10  ## Ctrl+D は 10 回まではシェルを終了しない

## 履歴関連のシェル変数
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:ls *:ll:ll *:la:la *:cd:cd -:pwd:history:exit"
HISTTIMEFORMAT="%F %T  "  ## 履歴にタイムスタンプ YYYY-MM-DD hh:mm:ss を表示する

shopt -s cdspell

## 履歴関連のオプション
shopt -s cmdhist     ## 複数行コマンドを同じ履歴エントリに保存する
shopt -s histappend  ## 履歴ファイルを上書きせずに追加する
shopt -s histverify  ## 履歴置換の結果を確認してから実行する
shopt -s histreedit  ## 履歴置換が失敗したら再編集する

## 補完関連のオプション
shopt -u hostcomplete             ## '@' を含む単語でホスト名を補完しない
shopt -s no_empty_cmd_completion  ## 未入力の状態では補完候補を出さない

## プロンプトに Git ブランチの情報を表示する
if [ -e /etc/profile.d/git-prompt.sh ]; then
	source /etc/profile.d/git-prompt.sh
	export GIT_PS1_SHOWDIRTYSTATE=true
	export GIT_PS1_SHOWSTASHSTATE=true
	export GIT_PS1_SHOWUNTRACKEDFILES=true
	export GIT_PS1_SHOWUPSTREAM=auto
	export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[36m\]$(__git_ps1)\[\e[0m\]\n\$ '
else
	export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n\$ '
fi

## エイリアスの設定
[ -f ~/.bash_alias ] && source ~/.bash_alias

## ローカル環境に固有の設定
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
