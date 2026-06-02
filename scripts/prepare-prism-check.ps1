param()

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$prismMinecraft = Join-Path $env:APPDATA "PrismLauncher/instances/aaa-otl Desarrollo/minecraft"

Push-Location $repoRoot
try {
    Write-Host "Refreshing pack metadata..." -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File (Join-Path $repoRoot "scripts/packwiz-refresh.ps1")

    Write-Host "Running workflow link checks..." -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File (Join-Path $repoRoot "scripts/check-workflow.ps1")

    Write-Host "Checking Prism instance links..." -ForegroundColor Cyan
    foreach ($dir in @("mods", "config", "kubejs")) {
        $path = Join-Path $prismMinecraft $dir
        if (-not (Test-Path $path)) {
            throw "Missing Prism path: $path"
        }
        $item = Get-Item $path
        if (-not ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
            throw "Prism path is not a symlink/junction: $path"
        }
        Write-Host "OK link: $path -> $($item.Target)" -ForegroundColor Green
    }

    Write-Host "Prism manual check preflight completed." -ForegroundColor Green
}
finally {
    Pop-Location
}
