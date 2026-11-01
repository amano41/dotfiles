$ErrorActionPreference = "Stop"

$regFile = Join-Path $HOME ".local/share/asr/asr.reg"
$regKey = "HKCU\Software\AMA_Soft\ASR\Main001"

New-Item -ItemType Directory -Force -Path (Split-Path $regFile) | Out-Null
reg.exe export $regKey $regFile /y

chezmoi add --encrypt $regFile
