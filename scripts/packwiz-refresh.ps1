param(
    [switch]$ListMods
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot
try {
    if (-not (Get-Command packwiz -ErrorAction SilentlyContinue)) {
        throw "packwiz not found in PATH"
    }

    Write-Host "Running: packwiz refresh" -ForegroundColor Cyan
    & packwiz refresh

    if ($ListMods) {
        Write-Host "Running: packwiz list" -ForegroundColor Cyan
        & packwiz list
    }

    Write-Host "packwiz refresh complete." -ForegroundColor Green
}
finally {
    Pop-Location
}
