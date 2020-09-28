Write-Host "Setting up scoop..." -ForegroundColor Magenta


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
