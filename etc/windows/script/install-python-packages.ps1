Write-Host "Installing Python packages..." -ForegroundColor Magenta


If (Get-Command -Name "pip" -ErrorAction SilentlyContinue) {
	$pip = "pip"
}
else {
	$pip = Join-Path $env:USERPROFILE "scoop/apps/python/current/Scripts/pip.exe"
	if (!(Test-Path $pip)) {
		Write-Error "pip not found." -ErrorAction Stop
	}
}


function install($package) {
	Write-Host $package
	& $pip --disable-pip-version-check install --user --no-warn-script-location $package | Out-Null
}


install flake8
install black
install isort
install mypy
install pipenv

## vscode: r
install radian
