$store_apps = @(
    "Microsoft.3DBuilder",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCalculator",
    "microsoft.windowscommunicationsapps",
    "Microsoft.WindowsCamera",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.SkypeApp",
    "Microsoft.Getstarted",
    "Microsoft.WindowsMaps",
    "Microsoft.BingFinance",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.BingNews"
    "Microsoft.Office.OneNote",
    "Microsoft.People",
    "Microsoft.WindowsPhone",
    "Microsoft.Windows.Photos",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.BingSports",
#    "Microsoft.WindowsStore",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.BingWeather",
    "Microsoft.XboxApp",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.Messaging",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.WindowsFeedbackHub"
)

foreach ($app in $store_apps) {
    Get-AppxPackage $app | Select-Object -Property Name, InstallLocation
    Get-AppxPackage $app | Remove-AppxPackage
}
