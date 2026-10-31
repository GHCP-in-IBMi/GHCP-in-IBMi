[CmdletBinding(SupportsShouldProcess = $true)]
param()

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

if (-not $env:USERPROFILE) {
    throw 'USERPROFILE is not set; cannot determine the installation destination.'
}

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$installations = @(
    @{
        Source = Join-Path $repositoryRoot '.copilot'
        Destination = Join-Path $env:USERPROFILE '.copilot'
    },
    @{
        Source = Join-Path $repositoryRoot 'scripts'
        Destination = Join-Path $env:USERPROFILE 'scripts'
    }
)

foreach ($installation in $installations) {
    if (-not (Test-Path -LiteralPath $installation.Source -PathType Container)) {
        throw "Source directory does not exist: $($installation.Source)"
    }

    if ($PSCmdlet.ShouldProcess($installation.Destination, 'Create destination directory')) {
        $null = New-Item -ItemType Directory -Path $installation.Destination -Force
    }

    $sourceRoot = (Resolve-Path -LiteralPath $installation.Source).Path
    foreach ($directory in Get-ChildItem -LiteralPath $sourceRoot -Force -Recurse |
            Where-Object { $_.PSIsContainer }) {
        $relativePath = $directory.FullName.Substring($sourceRoot.Length).TrimStart('\', '/')
        $destination = Join-Path $installation.Destination $relativePath
        if ($PSCmdlet.ShouldProcess($destination, 'Create destination directory')) {
            $null = New-Item -ItemType Directory -Path $destination -Force
        }
    }

    foreach ($file in Get-ChildItem -LiteralPath $sourceRoot -Force -Recurse |
            Where-Object { -not $_.PSIsContainer -and $_.FullName -ne $PSCommandPath }) {
        $relativePath = $file.FullName.Substring($sourceRoot.Length).TrimStart('\', '/')
        $destination = Join-Path $installation.Destination $relativePath
        if ($PSCmdlet.ShouldProcess($destination, 'Install repository file')) {
            Copy-Item -LiteralPath $file.FullName -Destination $destination -Force
            (Get-Item -LiteralPath $destination -Force).LastWriteTime = Get-Date
            Write-Host "Installed: $destination"
        }
    }
}

Write-Host "Installed .copilot and scripts under $env:USERPROFILE"
