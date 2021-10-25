##################################################
##  Windows 10 Bootstrap
##################################################


## 管理者権限のチェック
if (!([Security.Principal.WindowsPrincipal]`
      [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
      [Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Error "This script need to be run with elevated privileges." -ErrorAction Stop
}


$dotfiles = Join-Path $env:USERPROFILE "dotfiles"

if (Test-Path $dotfiles) {
	Remove-Item -Recurse -Path $dotfiles
}


if (Get-Command -Name "git" -ErrorAction SilentlyContinue) {

	$url = "https://github.com/amano41/dotfiles.git"
	git clone -c core.autocrlf=false $url $dotfiles

}
else {

	$downloads = Join-Path $env:USERPROFILE "Downloads"


	## ダウンロード

	$url = "https://github.com/amano41/dotfiles/archive/refs/heads/master.zip"
	$zip = Join-Path $downloads "dotfiles.zip"

	Write-Host "Downloading $url to $zip" -ForegroundColor Magenta
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Invoke-WebRequest -Uri $url -OutFile $zip


	## 展開

	$unzip = Join-Path $downloads "dotfiles"

	if (Test-Path $unzip) {
		Remove-Item -Recurse -Path $unzip
	}

	Write-Host "Expanding $zip" -ForegroundColor Magenta
	Expand-Archive -Path $zip


	## USERPROFILE にコピー

	$src = Join-Path $unzip "dotfiles-master"

	Write-Host "Coping $src to $dotfiles" -ForegroundColor Magenta
	Copy-Item -Recurse -Path $src -Destination $dotfiles


	## 後片付け

	Remove-Item -Recurse -Path $unzip
	Remove-Item -Path $zip
}


& "$dotfiles\etc\windows\setup.ps1"

& "$dotfiles\install.ps1"
