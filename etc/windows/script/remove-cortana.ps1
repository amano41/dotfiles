Write-Host "Removing Cortana..." -ForegroundColor Magenta

Get-AppxPackage -Name Microsoft.549981C3F5F10 -AllUsers | Remove-AppxPackage
