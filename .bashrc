IGNOREEOF=10  ## Ctrl+D は 10 回まではシェルを終了しない

shopt -s cdspell  ## cd コマンド実行時のタイプミスを自動修正する


## 履歴関連のシェル変数
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth
HISTIGNORE="ls:ll:la:cd:cd -:pwd:history:exit"
HISTTIMEFORMAT="%F %T  "  ## 履歴にタイムスタンプ YYYY-MM-DD hh:mm:ss を表示する

## 履歴関連のオプション
shopt -s cmdhist     ## 複数行コマンドを同じ履歴エントリに保存する
shopt -s histappend  ## 履歴ファイルを上書きせずに追加する
shopt -s histverify  ## 履歴置換の結果を確認してから実行する
shopt -s histreedit  ## 履歴置換が失敗したら再編集する


## 補完関連のオプション
shopt -u hostcomplete             ## '@' を含む単語でホスト名を補完しない
shopt -s no_empty_cmd_completion  ## 未入力の状態では補完候補を出さない


## Git コマンドで補完が効くようにする
if [ -f /usr/share/bash-completion/completions/git ]; then
	source /usr/share/bash-completion/completions/git
fi


## コマンドの存在確認
has() {
	type "$1" >/dev/null 2>&1
}


## エイリアスの設定
[ -f ~/.bash_alias ] && source ~/.bash_alias

## プロンプトの設定
[ -f ~/.bash_prompt ] && source ~/.bash_prompt

## OS ごとの設定
[ -f ~/.bashrc.os ] && source ~/.bashrc.os

## ローカル環境に固有の設定
[ -f ~/.bashrc.local ] && source ~/.bashrc.local


unset has
