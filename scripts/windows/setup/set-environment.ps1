#Requires -Version 7.0

$ErrorActionPreference = "Stop"


## ==================================================
## 環境変数の設定
## ==================================================

Write-Host "Setting up Environment Variables..." -ForegroundColor Magenta

# HOME
[Environment]::SetEnvironmentVariable("HOME", $env:USERPROFILE, "User")

# PATH
$path = @()
$path += "$env:USERPROFILE\.local\bin"
$path += "$env:USERPROFILE\bin"
$path += "$env:USERPROFILE\OneDrive\bin"

$path_user = [Environment]::GetEnvironmentVariable("PATH", "User")
$path_user -split ';' | ForEach-Object {
	$p = $_.trim()
	if ($p -and $path -notcontains $p) {
		$path += $p
	}
}

$path = $path -join ";"
[Environment]::SetEnvironmentVariable("PATH", $path, "User")

$env:PATH = @(
	[Environment]::GetEnvironmentVariable("PATH", "Machine")
	[Environment]::GetEnvironmentVariable("PATH", "User")
) -join ";"

# LANG
[Environment]::SetEnvironmentVariable("LANG", "ja_JP.UTF-8", "User")

# Python
[Environment]::SetEnvironmentVariable("PYTHONUTF8", "1", "User")
[Environment]::SetEnvironmentVariable("PYTHONDONTWRITEBYTECODE", "1", "User")
