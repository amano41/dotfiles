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

if [ -e "${HOME}/.bash_alias" ]; then
	source "${HOME}/.bash_alias"
fi
