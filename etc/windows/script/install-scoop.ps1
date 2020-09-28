Write-Host "Installing scoop..." -ForegroundColor Magenta

## scoop 本体のインストール
if (!(Get-Command -Name "scoop" -ErrorAction SilentlyContinue)) {
	Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

## scoop の動作に必要な git をインストール
scoop install git

## 公式 bucket を追加
scoop bucket add extras
scoop bucket add java

## 個人 bucket を追加
scoop bucket add my https://github.com/amano41/scoop-bucket
