if (!([Security.Principal.WindowsPrincipal]`
      [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
      [Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Error "This script need to be run with elevated privileges." -ErrorAction Stop
}


$url = "https://github.com/amano41/dotfiles/archive/refs/heads/master.zip"
$downloads = Join-Path $env:USERPROFILE "Downloads"
$zip = Join-Path $downloads "dotfiles.zip"

Write-Host "Downloading $url to $zip"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $url -OutFile $zip


$unzip = Join-Path $downloads "dotfiles"

if (Test-Path $unzip) {
	Remove-Item -Recurse -Path $unzip
}

Write-Host "Expanding $zip"
Expand-Archive -Path $zip


$src = Join-Path $unzip "dotfiles-master"
$dest = Join-Path $env:USERPROFILE "dotfiles"

Write-Host "Coping $src to $dest"
Copy-Item -Recurse -Path $src -Destination $dest


Push-Location $dest
. ".\etc\windows\setup.ps1"
. ".\install.ps1"
Pop-Location
