Write-Host "Installing scoop packages..." -ForegroundColor Magenta

if (!(Get-Command -Name "scoop" -ErrorAction SilentlyContinue)) {
	Write-Error "scoop not found." -ErrorAction Stop
}


scoop update 6>&1 | Out-Null


## インストール済みのパッケージ
$installed = @()
foreach ($pkg in (scoop export)) {
	$installed += ($pkg -split " ")[0]
}


## main
Write-Host "'main' bucket..." -ForegroundColor Yellow

$packages = @(
	"7zip",
	"bat",
	"dark",
	"delta",
	"fd",
	"fzf",
	"git",
	"gow",
	"gsudo",
	"innounp",
	"lessmsi",
	"lsd",
	"pandoc",
	"pwsh",
	"python",
	"r",
	"ripgrep",
	"sd",
	"starship",
	"tldr",
	"uutils-coreutils",
	"zoxide"
)

foreach ($pkg in $packages) {
	if (!($installed -contains $pkg)) {
		Write-Host $pkg
		scoop install $pkg 6>&1 | Out-Null
	}
}


## extras
Write-Host "'extras' bucket..." -ForegroundColor Yellow

$packages = @(
	"bitwarden",
	"ccleaner",
	"everything",
	"fastcopy",
	"fork",
	"gitkraken",
	"greenshot",
	"imageglass",
	"keypirinha",
	"mpc-be",
	"obs-studio",
	"obsidian",
	"posh-git",
	"quicklook",
	"rapidee",
	"rstudio",
	"shiba",
	"sumatrapdf",
	"windows-terminal",
	"winscp",
	"wsltty"
)

foreach ($pkg in $packages) {
	if (!($installed -contains $pkg)) {
		Write-Host $pkg
		scoop install $pkg 6>&1 | Out-Null
	}
}


## java
Write-Host "'java' bucket..." -ForegroundColor Yellow

$packages = @(
	"oraclejre8", ## インストールは JRE を先にすること
	"openjdk"      ## 後からインストールした方が %JAVA_HOME% を上書きするため
)

foreach ($pkg in $packages) {
	if (!($installed -contains $pkg)) {
		Write-Host $pkg
		scoop install $pkg 6>&1 | Out-Null
	}
}


## my
Write-Host "'my' bucket..." -ForegroundColor Yellow

$packages = @(
	"allrename",
	"bunbackup",
	"cassava",
	"clipboard-history",
	"hiddex",
	"jikagaki-desktop",
	"keyhac",
	"massigra",
	"mery",
	"pause",
	"rapture",
	"registry-finder",
	"sizer",
	"strokesplus.net",
	"sylphyhorn-ex",
	"trayvolume",
	"tresgrep",
	"win32yank",
	"winmerge-jp",
	"xdoc2txt"
)

foreach ($pkg in $packages) {
	if (!($installed -contains $pkg)) {
		Write-Host $pkg
		scoop install $pkg 6>&1 | Out-Null
	}
}
