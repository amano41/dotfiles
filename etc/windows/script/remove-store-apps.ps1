Write-Host "Removing Store Apps..." -ForegroundColor Magenta

if ($PSVersionTable.PSVersion.Major -ge 7) {
	Import-Module -Name Appx -UseWindowsPowerShell -WarningAction SilentlyContinue
}

$OldProgressPreference = $ProgressPreference
$ProgressPreference = "SilentlyContinue"

@(
	"Microsoft.3DBuilder",
	"Microsoft.BingFinance",
	"Microsoft.BingNews"
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
	"king.com.BubbleWitch3Saga",
	"king.com.CandyCrushSodaSaga",
	"king.com.*",
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
	"D5EA27B7.Duolingo-LearnLanguagesforFree"
) | ForEach-Object {
	Get-AppxPackage -Name $_ -AllUsers | Remove-AppxPackage | Out-Null
}

Clear-Host
$ProgressPreference = $OldProgressPreference
