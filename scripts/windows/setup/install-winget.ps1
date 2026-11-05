#Requires -Version 7.0
#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"


## ==================================================
## WinGet パッケージのインストール
## ==================================================

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
	Write-Warning "WinGet is not available. Install or update App Installer first."
	Read-Host "Press Enter when ready"
	
	if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
		throw "WinGet is still not available. Please install or update App Installer."
	}
}

Write-Host "Installing Apps via WinGet..." -ForegroundColor Magenta

$packages = @(

	# bootstrap.ps1 でインストール済みのパッケージ
	# このスクリプトを単体で実行した場合のために残しておく
	"Git.Git",
	"Microsoft.PowerShell",
	"twpayne.chezmoi",

	"7zip.7zip",
	"Bitwarden.Bitwarden",
	"Bitwarden.CLI",
	"Google.Chrome",
	"Mozilla.Firefox",
	"Vivaldi.Vivaldi",
	"Microsoft.PowerToys",
	"Microsoft.VisualStudioCode",
	"Microsoft.WindowsTerminal",
	"DevToys-app.DevToys",
	"Zoom.Zoom",
	"Biscuit.Biscuit",
	"CubeSoft.CubePDF",
	"CubeSoft.CubePDFUtility",
	"HermannSchinagl.LinkShellExtension",
	"CodecGuide.K-LiteCodecPack.Standard",
	"Paperpile.Paperpile",
	"9PM860492SZD"  # PC Manager (msstore)
)

foreach ($package in $packages) {

	$arguments = @(
		"install", "--id", $package, "--exact", "--no-upgrade",
		"--silent", "--accept-source-agreements", "--accept-package-agreements"
	)

	Write-Host "Installing $($package)..."
	& winget @arguments

	# APPINSTALLER_CLI_ERROR_PACKAGE_ALREADY_INSTALLED = -1978335135
	if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335135) {
		Write-Warning "Failed to install $($package) (exit code $LASTEXITCODE)."
	}
}
