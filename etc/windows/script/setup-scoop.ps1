Write-Host "Setting up scoop..."


## scoop 本体のインストール
try {
	Get-Command -Name "scoop" -ErrorAction Stop | Out-Null
}
catch {
	Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}


## scoop の動作に必要な 7zip と git をインストール
scoop install 7zip
scoop install git

## 公式 bucket を追加
scoop bucket add extras
scoop bucket add java

## 個人 bucket を追加
scoop bucket add my https://github.com/amano41/scoop-bucket

## bucket をアップデート
scoop update

## パッケージのインストール

## main
scoop install ffmpeg
scoop install ln
scoop install pwsh
scoop install python
scoop install r
scoop install sudo
scoop install which

## extras
scoop install ccleaner
scoop install everything
scoop install fastcopy
scoop install foxit-reader
scoop install gitkraken
scoop install greenshot
scoop install imageglass
scoop install keypirinha
scoop install mpc-be
scoop install netbeans
scoop install quicklook
scoop install rapidee
scoop install rstudio
scoop install shiba
scoop install sumatrapdf
scoop install winscp
scoop install wsltty

## java
scoop install oraclejre8  ## インストールは JRE を先にすること
scoop install openjdk     ## 後からインストールした方が %JAVA_HOME% を上書きするため

## my
scoop install bunbackup
scoop install cassava
scoop install clibor
scoop install hiddex
scoop install keyhac
scoop install massigra
scoop install mery
scoop install pause
scoop install rapture
scoop install sizer
scoop install sylphyhorn
scoop install tomighty
scoop install trayvolume
scoop install tresgrep
scoop install win32yank
scoop install winmerge-jp
scoop install xdoc2txt
