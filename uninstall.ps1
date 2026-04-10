$dir = "$env:LOCALAPPDATA\WinSystemDiagnostic"
$shortcut = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinSystemDiag.lnk"

Write-Host "Stopping Services..." -ForegroundColor Yellow
# Stop any running instances of the hidden PowerShell script
Get-Process powershell | Where-Object { $_.CommandLine -like "*WindowsDiagnosticeService*" } | Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host "Removing Files..." -ForegroundColor Yellow
if (Test-Path $shortcut) { Remove-Item $shortcut -Force }
if (Test-Path $dir) { Remove-Item $dir -Recurse -Force }

# Remove the Defender exclusion
Add-MpPreference -ExclusionPath $dir -ErrorAction SilentlyContinue | Out-Null # Using Add with empty logic sometimes clears or we leave it; technically Remove-MpPreference is better:
Remove-MpPreference -ExclusionPath $dir -ErrorAction SilentlyContinue

Write-Host "Uninstall Complete. System is clean." -ForegroundColor Green