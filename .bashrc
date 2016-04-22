HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:ls *:ll:ll *:la:la *:cd:cd -:pwd:history:exit"
HISTTIMEFORMAT="%F %T  "  ## Display Timestamp (YYYY-MM-DD hh:mm:ss)

## 履歴関連のオプション
shopt -s cmdhist     ## 複数行コマンドを同じ履歴エントリに保存する
shopt -s histappend  ## 履歴ファイルを上書きせずに追加する
shopt -s histverify  ## 履歴置換の結果を確認してから実行する
shopt -s histreedit  ## 履歴置換が失敗したら再編集する

if [ -e "${HOME}/.bash_alias" ]; then
	source "${HOME}/.bash_alias"
fi
