param(
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'Path')][string]$Path,
    [Parameter(Mandatory, ParameterSetName = 'Parts')][string]$Library,
    [Parameter(Mandatory, ParameterSetName = 'Parts')][string]$SourceFile,
    [Parameter(Mandatory, ParameterSetName = 'Parts')][string]$Member,
    [string]$Type = ''
)

# Opens an IBM i source member in the current VS Code window via Code for IBM i.
# Accepts LIB/SRCF/MBR[.TYPE] as one argument, or -Library/-SourceFile/-Member.
if ($PSCmdlet.ParameterSetName -eq 'Path') {
    $parts = $Path.Trim('/').Split('/')
    if ($parts.Count -ne 3) { Write-Host "Expected LIB/SRCF/MBR[.TYPE], got: $Path"; exit 1 }
    $Library, $SourceFile, $Member = $parts
    if ($Member.Contains('.')) {
        $Member, $ext = $Member.Split('.', 2)
        if (-not $Type) { $Type = $ext }
    }
}

$uriPath = "/$Library/$SourceFile/$Member".ToUpper()
if ($Type) { $uriPath += ".$($Type.ToUpper())" }

code --reuse-window --file-uri "member:$uriPath"

$expectedTitle = "$($Member.ToUpper()).$($Type.ToUpper())"
$deadline = (Get-Date).AddSeconds(30)
$p = $null

while ((Get-Date) -lt $deadline) {
    $p = Get-Process Code -ErrorAction SilentlyContinue |
        Where-Object { $_.MainWindowTitle -like "*$expectedTitle*" } |
        Select-Object -First 1

    if ($p) {
        Write-Host "Window title: $($p.MainWindowTitle)"
        exit 0
    }

    Start-Sleep -Milliseconds 250
}

throw "Timed out waiting for the IBM i member editor: $expectedTitle"
