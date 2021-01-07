Write-Host "Installing Python packages..." -ForegroundColor Magenta

If (!(Get-Command -Name "pip" -ErrorAction SilentlyContinue)) {
	Write-Error "pip not found." -ErrorAction Stop
}

function install($package) {
	pip --disable-pip-version-check install --user --no-warn-script-location $package | Select-String 'Requirement already satisfied' -NotMatch
}

## atom: linter-flake8
install flake8
install flake8-import-order

## atom: atom-beautify
install autopep8
install isort

## vscode: r
install radian

## clibor
install pywin32
