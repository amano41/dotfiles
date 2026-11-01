$ErrorActionPreference = "Stop"

$barDir = Join-Path $env:LOCALAPPDATA "Asr/Bar"
$archive = Join-Path $HOME ".local/share/asr/Bar.zip"

# アイコンキャッシュを削除しておく
Get-ChildItem -LiteralPath $barDir -File |
	Where-Object { $_.Extension -in '.iconidx', '.iconimg' } |
	Remove-Item

New-Item -ItemType Directory -Force -Path (Split-Path $archive) | Out-Null
Compress-Archive -Path (Join-Path $barDir '*') -DestinationPath $archive -Force

chezmoi add --encrypt $archive
