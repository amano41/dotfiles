Write-Host "Installing scoop packages..." -ForegroundColor Magenta

if (!(Get-Command -Name "scoop" -ErrorAction SilentlyContinue)) {
	Write-Error "scoop not found." -ErrorAction Stop
}


scoop update


## main
Write-Host "'main' bucket..." -ForegroundColor Yellow

$packages = @(
	"git",
	"7zip",
	"ffmpeg",
	"ln",
	"pwsh",
	"python",
	"r",
	"sudo",
	"which"
)

scoop install $packages


## extras
Write-Host "'extras' bucket..." -ForegroundColor Yellow

$packages = @(
	"ccleaner",
	"everything",
	"fastcopy",
	"foxit-reader",
	"gitkraken",
	"greenshot",
	"imageglass",
	"keypirinha",
	"mpc-be",
	"netbeans",
	"quicklook",
	"rapidee",
	"rstudio",
	"shiba",
	"sumatrapdf",
	"winscp",
	"wsltty"
)

scoop install $packages


## java
Write-Host "'java' bucket..." -ForegroundColor Yellow

$packages = @(
	"oraclejre8",  ## インストールは JRE を先にすること
	"openjdk"      ## 後からインストールした方が %JAVA_HOME% を上書きするため
)

scoop install $packages


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
	"sizer",
	"sylphyhorn",
	"tomighty",
	"trayvolume",
	"tresgrep",
	"win32yank",
	"winmerge-jp",
	"xdoc2txt"
)

scoop install $packages