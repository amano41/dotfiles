Push-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)

Get-Content "extensions.txt" | ForEach-Object { code --install-extension $_ }

Pop-Location
