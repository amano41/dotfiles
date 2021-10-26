Write-Host "Installing PowerShell modules..." -ForegroundColor Magenta

# PowerShellGet で NuGet ベースのリポジトリを操作するために必要
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

# PSGallery を信頼するリポジトリに追加
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Install-Module WslInterop
Install-Module PSFzf

# PSGallery を信頼するリポジトリから削除
Set-PSRepository -Name PSGallery -InstallationPolicy Untrusted
