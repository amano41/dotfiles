##
## ~/.bashrc.wsl
##


export TMPDIR=${TMP:-$(winenv -p TMP)}


## クリップボード
alias clip='clip.exe'
alias pbcopy='win32yank.exe -i'
alias pbpaste='win32yank.exe -o'


## 「開く」コマンド
function open() {

	local target="${1:-.}"

	## ディレクトリは As/R で開く
	if [[ -d $target ]]; then

		## local が終了ステータスを上書きするため宣言と代入を分ける
		local dir
		dir=$(wslpath -aw "$(realpath "$target")" 2>/dev/null)

		if [[ $? -ne 0 ]]; then
			echo "error: can not open directory on VolFs: $(realpath "$target")" 1>&2
			return 1
		fi

		local asr="$(winenv USERPROFILE)\bin\Asr\AsrLoad.exe"
		wslstart "$asr" "/x" "/n" "$dir"

	## それ以外はシェルの関連付けで開く
	else
		wslstart "$target"
	fi
}
