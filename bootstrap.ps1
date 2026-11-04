$ErrorActionPreference = "Stop"

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
	throw "WinGet is not available. Install or update App Installer first."
}


Write-Host "Installing essential commands via WinGet..." -ForegroundColor Magenta

$packages = @(
	@{ Id = "Git.Git"; Command = "git" }
	@{ Id = "Microsoft.PowerShell"; Command = "pwsh"; Options = @("--installer-type", "wix") }
	@{ Id = "twpayne.chezmoi"; Command = "chezmoi" }
)

foreach ($package in $packages) {

	if (Get-Command $package.Command -ErrorAction SilentlyContinue) {
		Write-Host "$($package.Command) is already installed." -ForegroundColor Green
		continue
	}

	$arguments = @(
		"install", "--id", $package.Id, "--exact", "--source", "winget", "--no-upgrade",
		"--silent", "--accept-source-agreements", "--accept-package-agreements"
	)

	if ($package.Options) {
		$arguments += $package.Options
	}

	Write-Host "Installing $($package.Command)..."
	& winget @arguments

	# APPINSTALLER_CLI_ERROR_PACKAGE_ALREADY_INSTALLED = -1978335135
	if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335135) {
		throw "Failed to install $($package.Command) (exit code $LASTEXITCODE)."
	}
}

$env:PATH = @(
	[Environment]::GetEnvironmentVariable("PATH", "Machine")
	[Environment]::GetEnvironmentVariable("PATH", "User")
) -join ";"


if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
	throw "chezmoi is not on PATH. Open a new PowerShell session and try again."
}

Write-Host "Retrieving dotfiles via chezmoi..." -ForegroundColor Magenta

& chezmoi init "amano41/dotfiles"

if ($LASTEXITCODE -ne 0) {
	throw "chezmoi init failed (exit code $LASTEXITCODE)."
}

Write-Host "Bootstrap completed." -ForegroundColor Green
Write-Host "Open a new PowerShell session and run setup.ps1 to continue setup." -ForegroundColor Yellow


# そのまま setup.ps1 を実行する場合

# $setup = Join-Path $HOME ".local/share/chezmoi/scripts/windows/setup.ps1"
# & pwsh -NoProfile -File $setup
#
# if ($LASTEXITCODE -ne 0) {
# 	throw "Setup failed (exit code $LASTEXITCODE)."
# }
