Write-Host "Removing Cortana..." -ForegroundColor Magenta

if ($PSVersionTable.PSVersion.Major -ge 7) {
	Import-Module -Name Appx -UseWindowsPowerShell
}

Get-AppxPackage -Name Microsoft.549981C3F5F10 -AllUsers | Remove-AppxPackage
