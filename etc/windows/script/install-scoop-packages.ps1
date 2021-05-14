Write-Host "Installing scoop packages..." -ForegroundColor Magenta

if (!(Get-Command -Name "scoop" -ErrorAction SilentlyContinue)) {
	Write-Error "scoop not found." -ErrorAction Stop
}


scoop update


## インストール済みのパッケージ
$installed = @()
foreach ($pkg in (scoop export)) {
	$installed += ($pkg -split " ")[0]
}


## main
Write-Host "'main' bucket..." -ForegroundColor Yellow

$packages = @(
	"git",
	"7zip",
	"dark",
	"innounp",
	"lessmsi",
	"ln",
	"pandoc",
	"pwsh",
	"python",
	"r",
	"starship",
	"sudo",
	"which"
)

foreach ($pkg in $packages) {
	if (!($installed -contains $pkg)) {
		scoop install $pkg
	}
}


## extras
Write-Host "'extras' bucket..." -ForegroundColor Yellow

$packages = @(
	"bitwarden",
	"ccleaner",
	"everything",
	"fastcopy",
	"gitkraken",
	"greenshot",
	"imageglass",
	"keypirinha",
	"mpc-be",
	"obsidian",
	"quicklook",
	"rapidee",
	"rstudio",
	"shiba",
	"sumatrapdf",
	"winscp",
	"wsltty"
)

foreach ($pkg in $packages) {
	if (!($installed -contains $pkg)) {
		scoop install $pkg
	}
}


## java
Write-Host "'java' bucket..." -ForegroundColor Yellow

$packages = @(
	"oraclejre8",  ## インストールは JRE を先にすること
	"openjdk"      ## 後からインストールした方が %JAVA_HOME% を上書きするため
)

foreach ($pkg in $packages) {
	if (!($installed -contains $pkg)) {
		scoop install $pkg
	}
}


## my
Write-Host "'my' bucket..." -ForegroundColor Yellow

$packages = @(
	"bunbackup",
	"cassava",
	"clibor",
	"hiddex",
	"keyhac",
	"massigra",
	"mery",
	"pause",
	"rapture",
	"registry-finder",
	"sizer",
	"strokesplus.net",
	"sylphyhorn-ex",
	"tomighty",
	"trayvolume",
	"tresgrep",
	"win32yank",
	"winmerge-jp",
	"xdoc2txt"
)

foreach ($pkg in $packages) {
	if (!($installed -contains $pkg)) {
		scoop install $pkg
	}
}
