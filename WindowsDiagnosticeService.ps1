# --- CONFIGURATION ---
$WebhookUrl = "YOUR_WEBHOOK_HERE" 
# ---------------------

$LastTitle = ""
$Signature = @'
[DllImport("user32.dll")]
public static extern IntPtr GetForegroundWindow();
[DllImport("user32.dll")]
public static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder lpString, int nMaxCount);
'@
$User32 = Add-Type -MemberDefinition $Signature -Name "Win32Window" -Namespace Win32 -PassThru

# Signal that monitoring has started
try { Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body (@{ content = " **Sentry Online:** Monitoring session started." } | ConvertTo-Json) -ContentType "application/json" } catch {}

while ($true) {
    # 1. Capture Active Window
    $Handler = $User32::GetForegroundWindow()
    $Builder = New-Object System.Text.StringBuilder 256
    $User32::GetWindowText($Handler, $Builder, 256) | Out-Null
    $CurrentTitle = $Builder.ToString()

    if ($CurrentTitle -and $CurrentTitle -ne $LastTitle) {
        $Time = Get-Date -Format "HH:mm:ss"
        $Payload = @{ content = " **Activity:** ``$CurrentTitle`` at $Time" } | ConvertTo-Json
        try { Invoke-WebRequest -Uri $WebhookUrl -Method Post -Body $Payload -ContentType "application/json" } catch {}
        $LastTitle = $CurrentTitle
    }

    # 2. Check for Lock Screen
    if (Get-Process LogonUI -ErrorAction SilentlyContinue) {
        if ($LastTitle -ne "LOCKED") {
            try { Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body (@{ content = " **Session:** Laptop Locked/User Away." } | ConvertTo-Json) -ContentType "application/json" } catch {}
            $LastTitle = "LOCKED"
        }
    }

    Start-Sleep -Seconds 15
}