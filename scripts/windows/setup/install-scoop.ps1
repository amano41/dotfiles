#Requires -Version 7.0

$ErrorActionPreference = "Stop"


# ユーザー権限で実行しているかチェック
if (([Security.Principal.WindowsPrincipal]`
			[Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
			[Security.Principal.WindowsBuiltInRole] "Administrator")) {
	throw "This script should be run as a normal user, not as an administrator."
}


## ==================================================
## scoop
## ==================================================


# scoop の動作に必要な git があるかチェック
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
	Write-Warning "Git is not available. Install Git via WinGet first."
	Read-Host "Press Enter when ready"

	if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
		throw "Git is still not available. Please install Git via WinGet."
	}
}

# scoop 本体のインストール
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
	Write-Host "Installing Scoop..." -ForegroundColor Magenta
	Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

	$env:PATH = @(
		[Environment]::GetEnvironmentVariable("PATH", "Machine")
		[Environment]::GetEnvironmentVariable("PATH", "User")
	) -join ";"
}


# scoop buckets の更新
Write-Host "Adding Buckets..." -ForegroundColor Magenta

$buckets = @(scoop bucket list | Select-Object -ExpandProperty Name)

# 公式 bucket を追加
if ($buckets -notcontains "extras") {
	scoop bucket add extras
}

# 個人 bucket を追加
if ($buckets -notcontains "my") {
	scoop bucket add my https://github.com/amano41/scoop-bucket
}

# scoop 本体を更新
Write-Host "Updating Scoop..." -ForegroundColor Magenta
& {
	# 途中エラーで中断されてしまうのを防ぐため
	$ErrorActionPreference = "Continue"
	scoop update
}


Write-Host "Installing Apps via scoop..." -ForegroundColor Magenta

# インストール済みのパッケージ
$installed = @(scoop list 6>$null | Select-Object -ExpandProperty Name)

# main
$packages = @(
	"bat",
	"dark",
	"delta",
	"fd",
	"ffmpeg",
	"fzf",
	"gh",
	"gow",
	"grex",
	"gsudo",
	"imagemagick",
	"innounp",
	"jq",
	"lessmsi",
	"lsd",
	"nodejs",
	"pandoc",
	"pipx",
	"poetry",
	"python",
	"r",
	"ripgrep",
	"sd",
	"starship",
	"uutils-coreutils",
	"zoxide"
)

foreach ($pkg in $packages) {
	if ($installed -notcontains $pkg) {
		& {
			$ErrorActionPreference = "Continue"
			Write-Host "Installing $pkg..."
			scoop install $pkg
		}
		if ($LASTEXITCODE -ne 0) {
			Write-Warning "Failed to install $pkg (exit code $LASTEXITCODE)."
			continue
		}
		$installed += ($pkg)
	}
}

# extras
$packages = @(
	"audacity",
	"bitwarden",
	"ccleaner",
	"crystaldiskinfo",
	"crystaldiskmark",
	"eartrumpet",
	"everything",
	"fastcopy",
	"greenshot",
	"keypirinha",
	"mpc-be",
	"obs-studio",
	"obsidian",
	"posh-git",
	"putty",
	"quicklook",
	"rapidee",
	"rstudio",
	"shiba",
	"sumatrapdf",
	"winscp"
)

foreach ($pkg in $packages) {
	if ($installed -notcontains $pkg) {
		& {
			$ErrorActionPreference = "Continue"
			Write-Host "Installing $pkg..."
			scoop install $pkg
		}
		if ($LASTEXITCODE -ne 0) {
			Write-Warning "Failed to install $pkg (exit code $LASTEXITCODE)."
			continue
		}
		$installed += ($pkg)
	}
}

# my
$packages = @(
	"allrename",
	"bunbackup",
	"cassava",
	"clipboard-history",
	"hiddex",
	"keyhac",
	"massigra",
	"mery",
	"rapture",
	"registry-finder",
	"sizer",
	"sylphyhorn-plus",
	"trayvolume",
	"tresgrep",
	"win32yank",
	"winmerge-jp",
	"xdoc2txt"
)

foreach ($pkg in $packages) {
	if ($installed -notcontains $pkg) {
		& {
			$ErrorActionPreference = "Continue"
			Write-Host "Installing $pkg..."
			scoop install $pkg
		}
		if ($LASTEXITCODE -ne 0) {
			Write-Warning "Failed to install $pkg (exit code $LASTEXITCODE)."
			continue
		}
		$installed += ($pkg)
	}
}
