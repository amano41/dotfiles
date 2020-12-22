Write-Host "Setting Environment Variables..." -ForegroundColor Magenta

## HOME
[Environment]::SetEnvironmentVariable("HOME", $env:USERPROFILE, "User")

## PATH
$path = [Environment]::GetEnvironmentVariable("PATH", "User")
$path = "$env:APPDATA\Python\Python39\Scripts;" + $path
$path = "$env:USERPROFILE\OneDrive\bin;" + $path
$path = "$env:USERPROFILE\bin;" + $path
[Environment]::SetEnvironmentVariable("PATH", $path, "User")

## TEMP
$temp_user = "R:\Temp\User"
if (Test-Path $temp_user) {
	[Environment]::SetEnvironmentVariable("TEMP", $temp_user, "User")
	[Environment]::SetEnvironmentVariable("TMP", $temp_user, "User")
}

$temp_system = "R:\Temp\System"
if (Test-Path $temp_system) {
	[Environment]::SetEnvironmentVariable("TEMP", $temp_system, "Machine")
	[Environment]::SetEnvironmentVariable("TMP", $temp_system, "Machine")
}

## LANG
[Environment]::SetEnvironmentVariable("LANG", "ja_JP.UTF-8", "User")

## WSLENV
[Environment]::SetEnvironmentVariable("WSLENV", "TMP/p", "User")

## Python
[Environment]::SetEnvironmentVariable("PYTHONUTF8", "1", "User")
[Environment]::SetEnvironmentVariable("PYTHONDONTWRITEBYTECODE", "1", "User")
[Environment]::SetEnvironmentVariable("PIPENV_VENV_IN_PROJECT", "1", "User")
