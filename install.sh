#!/usr/bin/env bash

set -e
set -u


INCLUDES=( ".??*" )
EXCLUDES=( ".git" )


DOTFILES_ROOT=$(cd $(dirname "$0"); pwd)


SYMLINK_CMD="ln -snf"
case "$OSTYPE" in
	cygwin) [[ "$CYGWIN" =~ winsymlinks:native ]] || SYMLINK_CMD="mklink" ;;
	msys)   [[ "$MSYS"   =~ winsymlinks:native ]] || SYMLINK_CMD="mklink" ;;
	*)      ;;
esac


function symlink() {
	echo "$2 -> $1"
	eval "$SYMLINK_CMD" "$1" "$2"
}


function mklink() {

	local src=$(cygpath -aw "$1")
	local dest=$(cygpath -aw "$2")
	local opt=

	if [ -d "$1" ]; then
		opt="/D"
	fi

	## シンボリックリンクか通常ファイルなら上書き
	if [ -L "$2" ] || [ -f "$2" ]; then
		rm "$2"
	fi

	cmd /c mklink $opt "$dest" "$src" 2>&1 >/dev/null | iconv -f sjis -t utf8
}


function find_files() {

	local dir=${1:-$DOTFILES_ROOT}
	local ext=${2:-}

	## EXCLUDES
	local prune=()
	if [ ${#EXCLUDES[*]} -gt 0 ]; then
		prune+=("(")
		for i in ${!EXCLUDES[*]}
		do
			if [ $i -ne 0 ]; then
				prune+=("-o")
			fi
			prune+=("-name" "${EXCLUDES[$i]}")
		done
		prune+=(")" "-prune" "-o")
	fi

	## INCLUDES
	local match=()
	if [ ${#INCLUDES[*]} -gt 0 ]; then
		match+=("(")
		for i in ${!INCLUDES[*]}
		do
			if [ $i -ne 0 ]; then
				match+=("-o")
			fi
			match+=("-name" "${INCLUDES[$i]}")
		done
		match+=(")")
	fi

	## 指定されたディレクトリ直下のファイルをリストアップ
	find -H "$dir" -mindepth 1 -maxdepth 1 "${prune[@]}" "${match[@]}" -print
}


function install() {

	## OS 判別
	local platform=
	case "$OSTYPE" in
		linux*)
			if [[ $(uname -a) =~ [Mm]icrosoft ]]; then
				platform="wsl"
			else
				platform="linux"
			fi
			;;
		darwin*)
			platform="macos"
			;;
		cygwin | msys)
			platform="cygwin"
			;;
		*)
			echo "Unknown \$OSTYPE: '$OSTYPE'" 1>&2
			;;
	esac

	## この OS 向けの設定ファイルについている拡張子
	local ext=${platform:+.$platform}

	## $DOTFILES_ROOT/.* から $HOME/.* にリンク作成
	local src=
	for src in $(find_files "$DOTFILES_ROOT")
	do

		local suffix=
		case "$(basename "$src")" in
			## Git 管理ディレクトリは除外
			.git)
				continue
				;;
			## OS ごとの設定ファイルは該当するものの拡張子を *.os に変更してリンク
			*.wsl | *.linux | *.macos | *.cygwin)
				if [[ $src == *.$platform ]]; then
					suffix=".os"
				else
					continue
				fi
				;;
			*)
				;;
		esac

		local dest="$HOME/$(basename "$src" "$ext")$suffix"
		symlink "$src" "$dest"

	done

	## Cygwin 環境での追加処理
	## - 名前がドットではじまらない設定ファイル
	## - %USERPROFILE% に配置しなくてはならない設定ファイル
	if [ "$platform" == "cygwin" ]; then

		## R GUI で必要なファイルのシンボリックリンクを作成
		for file in Rconsole Rdevga;
		do
			if [ -f "$DOTFILES_ROOT/$file" ]; then
				symlink "$DOTFILES_ROOT/$file" "$HOME/$file"
			fi
		done

	fi

}


install
