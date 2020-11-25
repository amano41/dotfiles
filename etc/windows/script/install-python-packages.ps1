Write-Host "Installing Python packages..." -ForegroundColor Magenta

If (!(Get-Command -Name "pip" -ErrorAction SilentlyContinue)) {
	Write-Error "pip not found." -ErrorAction Stop
}

## atom: linter-flake8
pip install --user --no-warn-script-location flake8
pip install --user --no-warn-script-location flake8-import-order

## atom: atom-beautify
pip install --user --no-warn-script-location autopep8
pip install --user --no-warn-script-location isort

## vscode: r
pip install --user --no-warn-script-location radian

## clibor
pip install --user --no-warn-script-location pywin32
