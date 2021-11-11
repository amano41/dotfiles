Write-Host "Disabling Web Search..." -ForegroundColor Magenta

$path = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
$name = "DisableSearchBoxSuggestions"

if (!(Test-Path $path)) {
	New-Item -Path $path -Force | Out-Null
}

Set-ItemProperty -Path $path -Name $name -Type DWord -Value 1
