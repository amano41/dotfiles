Write-Host "Setting up JRE..." -ForegroundColor Magenta


$path = "HKLM:/SOFTWARE/JavaSoft/Java Runtime Environment"
$version = "1.8"

if (!(Test-Path $path)) {
	New-Item -Path $path -Force | Out-Null
}

Set-ItemProperty -Path $path -Name "CurrentVersion" -Value $version


$path = $path + '/' + $version
$jre = $env:USERPROFILE + '/scoop/apps/oraclejre8/current'

if (!(Test-Path $path)) {
	New-Item -Path $path -Force | Out-Null
}

Set-ItemProperty -Path $path -Name "JavaHome" -Value $jre
Set-ItemProperty -Path $path -Name "MicroVersion" -Value 0
