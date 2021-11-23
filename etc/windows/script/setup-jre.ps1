Write-Host "Setting up JRE..." -ForegroundColor Magenta

if (!(Get-Command "Set-Registry" -ErrorAction SilentlyContinue)) {
	. (Join-Path (Split-Path (Split-Path $PSScriptRoot)) "powershell\utils.ps1")
}

$version = "1.8"
$jre = Join-Path $env:USERPROFILE 'scoop\apps\oraclejre8\current'

Set-Registry "HKLM:/SOFTWARE/JavaSoft/Java Runtime Environment" "CurrentVersion" $version
Set-Registry "HKLM:/SOFTWARE/JavaSoft/Java Runtime Environment/$version" "JavaHome" $jre
Set-Registry "HKLM:/SOFTWARE/JavaSoft/Java Runtime Environment/$version" "MicroVersion" 0
