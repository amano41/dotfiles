Write-Host "Installing scoop..." -ForegroundColor Magenta

## scoop 本体のインストール
if (!(Get-Command -Name "scoop" -ErrorAction SilentlyContinue)) {
	Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

## scoop の動作に必要な git をインストール
if (!(scoop export | Select-String "\bgit\b")) {
	scoop install git
}

$buckets = scoop bucket list

## 公式 bucket を追加
if (!$buckets.Contains('extras')) {
	scoop bucket add extras
}

if (!$buckets.Contains('java')) {
	scoop bucket add java
}

## 個人 bucket を追加
if (!$buckets.Contains('my')) {
	scoop bucket add my https://github.com/amano41/scoop-bucket
}
