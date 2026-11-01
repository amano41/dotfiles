#Requires -Version 7.0
#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"


## ==================================================
## ストアアプリの削除
## ==================================================

Write-Host "Removing Default Store Apps..." -ForegroundColor Magenta

Import-Module -Name Appx -UseWindowsPowerShell -WarningAction SilentlyContinue

$OldProgressPreference = $ProgressPreference
$ProgressPreference = "SilentlyContinue"

$packages = @(
	"Microsoft.3DBuilder",
	"Microsoft.BingFinance",
	"Microsoft.BingNews",
	"Microsoft.BingSports",
	"Microsoft.BingTranslator",
	"Microsoft.BingWeather",
	"Microsoft.CommsPhone",
	"Microsoft.FreshPaint",
	"Microsoft.GetHelp",
	"Microsoft.Getstarted",
	"Microsoft.Messaging",
	"Microsoft.Microsoft3DViewer",
	"Microsoft.MicrosoftOfficeHub",
	"Microsoft.MicrosoftSolitaireCollection",
	"Microsoft.MicrosoftStickyNotes",
	"Microsoft.MinecraftUWP",
	"Microsoft.MixedReality.Portal",
	"Microsoft.NetworkSpeedTest",
	"Microsoft.Office.OneNote",
	"Microsoft.Office.Sway",
	"Microsoft.OneConnect",
	"Microsoft.People",
	"Microsoft.Print3D",
	"Microsoft.ScreenSketch",
	"Microsoft.SkypeApp",
	"Microsoft.Wallet",
	"Microsoft.Windows.Photos",
	"Microsoft.WindowsAlarms",
	"Microsoft.WindowsCalculator",
	"Microsoft.WindowsCamera",
	"microsoft.windowscommunicationsapps",
	"Microsoft.WindowsFeedbackHub",
	"Microsoft.WindowsMaps",
	"Microsoft.WindowsPhone",
	"Microsoft.WindowsSoundRecorder",
	"Microsoft.Xbox.TCUI",
	"Microsoft.XboxApp",
	"Microsoft.XboxGameOverlay",
	"Microsoft.XboxGamingOverlay",
	"Microsoft.XboxIdentityProvider",
	"Microsoft.XboxSpeechToTextOverlay",
	"Microsoft.YourPhone",
	"Microsoft.ZuneMusic",
	"Microsoft.ZuneVideo",
	"Microsoft.5220175982889",
	"king.com.BubbleWitch3Saga",
	"king.com.CandyCrushSodaSaga",
	"king.com.*",
	"*bing*",
	"*Autodesk*",
	"*Dell*",
	"*Facebook*",
	"*Keeper*",
	"*MarchofEmpires*",
	"*Netflix*",
	"*Plex*",
	"*Twitter*",
	"ActiproSoftwareLLC.562882FEEB491",
	"46928bounde.EclipseManager",
	"PandoraMediaInc.29680B314EFC2",
	"D5EA27B7.Duolingo-LearnLanguagesforFree",
	"828B5831.HiddenCityMysteryofShadows",
	"NAVER.LINE*",
	"DolbyLaboratories.DolbyAccess",
	"7EE7776C.LinkedInforWindows",
	"flaregamesGmbH.RoyalRevolt2",
	"SpotifyAB.SpotifyMusic"
)

foreach($package in $packages) {
	Get-AppxPackage -Name $package | ForEach-Object {
		try {
			Write-Host "Removing $($_.PackageFullName)..."
			Remove-AppxPackage -Package $_.PackageFullName -ErrorAction Stop
		} catch {
			Write-Warning "Failed to remove ($_.PackageFullName): $($_.Exception.Message)"
		}
	}
}

$ProgressPreference = $OldProgressPreference
