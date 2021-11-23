Write-Host "Setting up everything service..." -ForegroundColor Magenta


$version = scoop info everything | Select-String "Version" | ForEach-Object { $_.Line.Replace("Version: ", "") -Replace "\(Update to .+", "" }
$app = $env:USERPROFILE + '/scoop/apps/everything/' + $version + '/Everything.exe'


Stop-Service -Name "Everything"
Stop-Process -Name "Everything" -Force 2> $null
Start-Process $app -ArgumentList "-install-service" -Wait
Start-Process $app -ArgumentList "-start-service" -Wait
