if (!([Security.Principal.WindowsPrincipal]`
			[Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
			[Security.Principal.WindowsBuiltInRole] "Administrator")) {
	Write-Error "This script need to be run with elevated privileges." -ErrorAction Stop
}


Write-Host "Setting up everything service..." -ForegroundColor Magenta


$version = scoop info everything | Select-String "Version" | % { $_.Line.Replace("Version: ", "") }
$app = $env:USERPROFILE + '/scoop/apps/everything/' + $version + '/Everything.exe'


Stop-Service -Name "Everything"
Stop-Process -Name "Everything" -Force 2> $null
Start-Process $app -ArgumentList "-install-service" -Wait
Start-Process $app -ArgumentList "-start-service" -Wait
