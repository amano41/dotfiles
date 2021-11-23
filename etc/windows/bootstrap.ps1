##################################################
##  Windows 10 Bootstrap
##################################################

Push-Location $PSScriptRoot

## ヘルパー関数の読み込み
. "..\powershell\utils.ps1"

## 管理者権限のチェック
if (!(Test-Privilege)) {
	Pop-Location
	Write-Error "This script need to be run with elevated privileges." -ErrorAction Stop
}


## dotfiles のダウンロード
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

	$unzip = Join-Path $downloads "dotfiles-master"

	if (Test-Path $unzip) {
		Remove-Item -Recurse -Path $unzip
	}

	Write-Host "Expanding $zip to $unzip" -ForegroundColor Magenta
	Expand-Archive -Path $zip -DestinationPath $downloads


	## USERPROFILE にコピー

	Write-Host "Coping $unzip to $dotfiles" -ForegroundColor Magenta
	Copy-Item -Recurse -Path $unzip -Destination $dotfiles


	## 後片付け

	Remove-Item -Recurse -Path $unzip
	Remove-Item -Path $zip
}


## Windows の初期設定
& "$dotfiles\etc\windows\setup.ps1"


## dotfiles のインストール
& "$dotfiles\install.ps1"


Pop-Location
