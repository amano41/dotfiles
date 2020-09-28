Write-Host "Installing Python packages..." -ForegroundColor Magenta

If (!(Get-Command -Name "pip" -ErrorAction SilentlyContinue)) {
	Write-Error "pip not found." -ErrorAction Stop
}

## atom: linter-flake8
pip install --user flake8
pip install --user flake8-import-order

## atom: atom-beautify
pip install --user autopep8
pip install --user isort

## clibor
pip install --user pywin32
