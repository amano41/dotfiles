Invoke-Expression (&starship init powershell)

# 管理者権限があるかチェックする関数
function Test-Privilege {
	return ([Security.Principal.WindowsPrincipal]`
	        [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
	        [Security.Principal.WindowsBuiltInRole] "Administrator")
}

# シンボリックリンクを作成する関数
function Symlink($src, $dest) {

	if (Test-Path $dest -PathType Container) {
		$type = Get-Item $dest | Select-Object -ExpandProperty LinkType
		if ($type -ne "SymbolicLink") {
			Write-Warning "'$dest' already exists."
			$backup = "$dest" + "." + (Get-Date -UFormat "%Y%m%d%H%M%S")
			Move-Item $dest $backup
		}
	}
	Write-Host "----"

	$path = Split-Path -Parent $dest
	$name = Split-Path -Leaf $dest

	if (!(Test-Path $path)) {
		New-Item $path -ItemType Directory
	}

	New-Item -ItemType SymbolicLink -Path $path -Name $name -Target $src -Force
}

# 上書きせずにコピーする関数
function SafeCopy($src, $dest) {

	if (Test-Path $dest) {
		Write-Warning "'$dest' already exists."
		$backup = "$dest" + "." + (Get-Date -UFormat "%Y%m%d%H%M%S")
		Move-Item $dest $backup
	}

	$path = Split-Path -Parent $dest

	if (!(Test-Path $path)) {
		New-Item $path -ItemType Directory
	}

	Copy-Item $src $dest
}

# ショートカットを作成する関数
function Create-Shortcut($src, $dest, $opts="") {
	$wsh = New-Object -ComObject WScript.Shell
	$lnk = $wsh.CreateShortcut($dest)
	$lnk.TargetPath = $src
	$lnk.Arguments = $opts
	$lnk.Save()
}
