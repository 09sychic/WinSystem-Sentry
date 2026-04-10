# --- CONFIGURATION ---
$WebhookUrl = "YOUR_WEBHOOK_HERE" 
# ---------------------

$LastTitle = ""

# Setup Windows API
$Signature = @'
[DllImport("user32.dll")]
public static extern IntPtr GetForegroundWindow();
[DllImport("user32.dll")]
public static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder lpString, int nMaxCount);
'@
$User32 = Add-Type -MemberDefinition $Signature -Name "Win32Window" -Namespace Win32 -PassThru

# Start Signal
try { Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body (@{ content = "🟢 **Sentry Online:** Tracking Active." } | ConvertTo-Json) -ContentType "application/json" } catch {}

while($true) {
    try {
        $Handler = $User32::GetForegroundWindow()
        $Builder = New-Object System.Text.StringBuilder 256
        $null = $User32::GetWindowText($Handler, $Builder, 256)
        $CurrentTitle = $Builder.ToString().Trim()

        # Only send if title is not empty and has actually changed
        if ($CurrentTitle -and $CurrentTitle -ne $LastTitle) {
            $Payload = @{ content = "💻 **Activity:** ``$CurrentTitle``" } | ConvertTo-Json
            Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body $Payload -ContentType "application/json"
            $LastTitle = $CurrentTitle
        }

        # Check for Lock Screen
        if (Get-Process LogonUI -ErrorAction SilentlyContinue) {
            if ($LastTitle -ne "LOCKED") {
                Invoke-RestMethod -Uri $WebhookUrl -Method Post -Body (@{ content = "🔒 **Session:** Locked" } | ConvertTo-Json) -ContentType "application/json"
                $LastTitle = "LOCKED"
            }
        }
    } catch {
        # Silent restart of the loop if an error occurs
    }
    
    Start-Sleep -Seconds 10
}
