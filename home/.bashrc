##
## ~/.bashrc
##


## シェル変数
IGNOREEOF=10  ## Ctrl+D は 10 回まではシェルを終了しない


## シェルオプション
shopt -s cdspell  ## cd コマンド実行時のタイプミスを自動修正する


## 履歴関連のシェル変数
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth
HISTIGNORE="ls:la:ll:lla:lt:lta:cd:cd -:cd ..:g:pwd:printenv:history:h:fg:bg:exit"
HISTTIMEFORMAT="%F %T  "  ## 履歴にタイムスタンプ YYYY-MM-DD hh:mm:ss を表示する


## 履歴関連のシェルオプション
shopt -s cmdhist     ## 複数行コマンドを同じ履歴エントリに保存する
shopt -u histappend  ## 履歴ファイルは同期するので追記モードは不要
shopt -s histverify  ## 履歴置換の結果を確認してから実行する
shopt -s histreedit  ## 履歴置換が失敗したら再編集する


## 補完関連のシェルオプション
shopt -u hostcomplete             ## '@' を含む単語でホスト名を補完しない
shopt -s no_empty_cmd_completion  ## 未入力の状態では補完候補を出さない


## コマンドの存在確認
has() {
	type "$1" >/dev/null 2>&1
}


## プロンプトの設定
if [[ -f ~/.bash_prompt ]]; then
	source ~/.bash_prompt
fi


## エイリアスの定義
if [[ -f ~/.bash_aliases ]]; then
	source ~/.bash_aliases
fi


## シェル関数の定義
if [[ -f ~/.bash_functions ]]; then
	source ~/.bash_functions
fi


## OS ごとの設定
if [[ -f ~/.bashrc.os ]]; then
	source ~/.bashrc.os
fi


## ローカル環境に固有の設定
if [[ -f ~/.bashrc.local ]]; then
	source ~/.bashrc.local
fi


unset has
