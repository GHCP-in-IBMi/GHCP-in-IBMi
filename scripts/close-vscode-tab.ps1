param(
    [Parameter(Mandatory)][string]$Match
)

# Closes the VS Code tab whose name contains $Match. If it is not the active tab, activates it via Quick Open first.
# Ctrl+W is sent only after the window title confirms the matching tab is active.
Add-Type -AssemblyName System.Windows.Forms
Add-Type @'
using System;
using System.Runtime.InteropServices;
public class Win {
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int cmd);
}
'@

$codeWindows = @(Get-Process Code -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like '*Visual Studio Code*' })
$p = $codeWindows | Where-Object { $_.MainWindowTitle -like "*$Match*" } | Select-Object -First 1
$needActivate = $false
if (-not $p) {
    # Tab is not active: fall back to the first VS Code window and activate the tab via Quick Open
    $p = $codeWindows | Select-Object -First 1
    if (-not $p) { Write-Host "No VS Code window found - nothing sent."; exit 1 }
    $needActivate = $true
}

$title = $p.MainWindowTitle
$h = $p.MainWindowHandle

# A tap of Alt lets SetForegroundWindow succeed past the foreground lock
[System.Windows.Forms.SendKeys]::SendWait('%')
[Win]::ShowWindow($h, 9) | Out-Null
$ok = [Win]::SetForegroundWindow($h)
Start-Sleep -Milliseconds 400
if (-not $ok -or [Win]::GetForegroundWindow() -ne $h) { Write-Host "FAILED: could not bring VS Code to the foreground - nothing sent."; exit 2 }

if ($needActivate) {
    # Quick Open lists open editors first; escape SendKeys special characters in the match text
    $typed = [regex]::Replace($Match, '[+^%~(){}\[\]]', '{$0}')
    [System.Windows.Forms.SendKeys]::SendWait('^p')
    Start-Sleep -Milliseconds 500
    [System.Windows.Forms.SendKeys]::SendWait($typed)
    Start-Sleep -Milliseconds 700
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    $activated = $false
    for ($i = 0; $i -lt 10; $i++) {
        Start-Sleep -Milliseconds 300
        $p.Refresh()
        if ($p.MainWindowTitle -like "*$Match*") { $activated = $true; break }
    }
    if (-not $activated) { Write-Host "FAILED: could not activate a tab matching '$Match' (title: $($p.MainWindowTitle)) - nothing closed."; exit 4 }
    $title = $p.MainWindowTitle
}

# Ctrl+1 moves keyboard focus from chat/terminal to the editor before closing
[System.Windows.Forms.SendKeys]::SendWait('^1')
Start-Sleep -Milliseconds 400
$p.Refresh()
if ($p.MainWindowTitle -notlike "*$Match*") { Write-Host "FAILED: active tab changed to '$($p.MainWindowTitle)' after focusing the editor - nothing closed."; exit 5 }
[System.Windows.Forms.SendKeys]::SendWait('^w')

for ($i = 0; $i -lt 10; $i++) {
    Start-Sleep -Milliseconds 300
    $p.Refresh()
    if ($p.MainWindowTitle -ne $title) {
        Write-Host "Closed. Window title now: $($p.MainWindowTitle)"
        exit 0
    }
}
Write-Host "FAILED: tab did not close (title still: $($p.MainWindowTitle)). It may have a save prompt."
exit 3
