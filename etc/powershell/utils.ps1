# 管理者権限があるかチェックする関数
function Test-Privilege {
	return ([Security.Principal.WindowsPrincipal]`
	        [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
	        [Security.Principal.WindowsBuiltInRole] "Administrator")
}


# シンボリックリンクを作成する関数
function New-Symlink($src, $dest) {

	# 管理者権限の確認
	if (!(Test-Privilege)) {
		Write-Error "This command need to be run with elevated privileges." -ErrorAction Stop
	}

	if (!(Test-Path $src)) {
		Write-Error "No such file or directory: $src" -ErrorAction Stop
	}

	$src = Resolve-Path $src

	if (Test-Path $dest -PathType Container) {
		$type = Get-Item $dest | Select-Object -ExpandProperty LinkType
		if ($type -ne "SymbolicLink") {
			$name = Split-Path -Leaf $src
			$dest = Join-Path $dest $name
		}
	}

	$path = Split-Path -Parent $dest
	$name = Split-Path -Leaf $dest

	if (!($path)) {
		$path = "."
	}

	if (!(Test-Path $path)) {
		New-Item -Path $path -ItemType Directory
	}

	New-Item -ItemType SymbolicLink -Path $path -Name $name -Target $src -Force | Out-Null
}


# ショートカットを作成する関数
function New-Shortcut($src, $dest, $opts = "") {
	$wsh = New-Object -ComObject WScript.Shell
	$lnk = $wsh.CreateShortcut($dest)
	$lnk.TargetPath = $src
	$lnk.Arguments = $opts
	$lnk.Save()
}


## レジストリに書き込む関数
function Set-Registry($path, $key, $value) {
	if (!(Test-Path $path)) {
		New-Item -Path $path -Force | Out-Null
	}
	Set-ItemProperty -Path $path -Name $key -Value $value | Out-Null
}
