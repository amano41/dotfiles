Write-Host "Installing Python packages..." -ForegroundColor Magenta


If (Get-Command -Name "pip" -ErrorAction SilentlyContinue) {
	$pip = "pip"
}
else {
	$pip = Join-Path $env:USERPROFILE "scoop/apps/python/current/Scripts/pip"
	if (!(Test-Path $pip)) {
		Write-Error "pip not found." -ErrorAction Stop
	}
}


function install($package) {
	& $pip --disable-pip-version-check install --user --no-warn-script-location $package | Select-String 'Requirement already satisfied' -NotMatch
}


install flake8
install black
install isort
install mypy

## vscode: r
install radian
