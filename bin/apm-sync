#!/usr/bin/env bash

set -e
set -u


function get_installed_packages() {
	apm list -i -b | sed -e 's/@.\+$//g' | sed -e '/^\s*$/d' | sort
}


function get_starred_packages() {
	apm starred --color false | sed -e '1d' | head -n -3 | awk '{ print $2 }' | sed -e '/^\s*$/d' | sort
}


function print_package_names() {
	for p in "$@"
	do
		echo "  $p"
	done
	echo
}


function install() {

	## packages starred but not installed
	target_packages=( $(join -v 1 <(get_starred_packages) <(get_installed_packages)) )

	echo "packages to be installed (${#target_packages[@]}):"
	print_package_names "${target_packages[@]}"

	apm install "${target_packages[@]}"
}


function uninstall() {

	## packages installed but not starred
	target_packages=( $(join -v 2 <(get_starred_packages) <(get_installed_packages)) )

	echo "packages to be uninstalled (${#target_packages[@]}):"
	print_package_names "${target_packages[@]}"

	apm uninstall "${target_packages[@]}"
}


function star() {

	## packages installed but not starred
	target_packages=( $(join -v 2 <(get_starred_packages) <(get_installed_packages)) )

	echo "packages to be starred (${#target_packages[@]}):"
	print_package_names "${target_packages[@]}"

	apm star "${target_packages[@]}"
}


function unstar() {

	## packages starred but not installed
	target_packages=( $(join -v 1 <(get_starred_packages) <(get_installed_packages)) )

	echo "packages to be unstarred (${#target_packages[@]}):"
	print_package_names "${target_packages[@]}"

	apm unstar "${target_packages[@]}"
}


function pull() {

	starred_packages=$(get_starred_packages)
	installed_packages=$(get_installed_packages)

	## packages starred but not installed
	target_install=( $(join -v 1 <(echo "$starred_packages") <(echo "$installed_packages")) )

	## packages not starred but installed
	target_uninstall=( $(join -v 2 <(echo "$starred_packages") <(echo "$installed_packages")) )

	echo "packages to be installed (${#target_install[@]}):"
	print_package_names "${target_install[@]}"

	echo "packages to be uninstalled (${#target_uninstall[@]}):"
	print_package_names "${target_uninstall[@]}"

	apm install "${target_install[@]}"
	apm uninstall "${target_uninstall[@]}"
}


function push() {

	starred_packages=$(get_starred_packages)
	installed_packages=$(get_installed_packages)

	## packages installed but not starred
	target_star=( $(join -v 2 <(echo "$starred_packages") <(echo "$installed_packages")) )

	## packages not installed but starred
	target_unstar=( $(join -v 1 <(echo "$starred_packages") <(echo "$installed_packages")) )

	echo "packages to be starred (${#target_star[@]}):"
	print_package_names "${target_star[@]}"

	echo "packages to be unstarred (${#target_unstar[@]}):"
	print_package_names "${target_unstar[@]}"

	apm star "${target_star[@]}"
	apm unstar "${target_unstar[@]}"
}


function status() {

	starred_packages=$(get_starred_packages)
	installed_packages=$(get_installed_packages)

	synced=( $(join <(echo "$starred_packages") <(echo "$installed_packages")) )
	only_starred=( $(join -v 1 <(echo "$starred_packages") <(echo "$installed_packages")) )
	only_installed=( $(join -v 2 <(echo "$starred_packages") <(echo "$installed_packages")) )

	echo "starred and installed (${#synced[@]}):"
	print_package_names "${synced[@]}"

	echo "starred but not installed (${#only_starred[@]}):"
	print_package_names "${only_starred[@]}"

	echo "installed but not starred (${#only_installed[@]}):"
	print_package_names "${only_installed[@]}"
}


function usage() {
	cat <<EOF
Usage: $(basename "$0") <command>

Commands:
	install
	uninstall
	star
	unstar
	pull
	push
	status
	usage
	help
EOF
}


function error() {
	usage 1>&2
}


if [ $# -gt 1 ]; then
	error
	exit 1
fi

if [ $# -eq 0 ]; then
	status
	exit 0
fi

case "$1" in
	"install")   install ;;
	"uninstall") uninstall ;;
	"star")      star ;;
	"unstar")    unstar ;;
	"pull")      pull ;;
	"push")      push ;;
	"status")    status ;;
	"usage")     usage ;;
	"help")      usage ;;
	*)
		error
		exit 1
		;;
esac
