param()

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$prismMinecraft = Join-Path $env:APPDATA "PrismLauncher/instances/aaa-otl Desarrollo/minecraft"

Push-Location $repoRoot
try {
    Write-Host "Refreshing pack metadata..." -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File (Join-Path $repoRoot "scripts/packwiz-refresh.ps1")

    Write-Host "Regenerating mod-list inventory..." -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File (Join-Path $repoRoot "scripts/update-mod-list.ps1")

    Write-Host "Running workflow link checks..." -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File (Join-Path $repoRoot "scripts/check-workflow.ps1")

    Write-Host "Checking Prism instance links..." -ForegroundColor Cyan
    foreach ($dir in @("config", "kubejs")) {
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

    $modsPath = Join-Path $prismMinecraft "mods"
    if (-not (Test-Path $modsPath)) {
        throw "Missing Prism mods runtime folder: $modsPath"
    }
    $modsItem = Get-Item $modsPath
    if ($modsItem.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        throw "Prism mods folder must be a real runtime directory, not a symlink: $modsPath"
    }
    Write-Host "OK runtime directory: $modsPath" -ForegroundColor Green

    $instanceCfg = Join-Path $prismMinecraft "..\instance.cfg"
    if (-not (Test-Path $instanceCfg)) {
        throw "Missing Prism instance.cfg: $instanceCfg"
    }
    $cfg = Get-Content $instanceCfg -Raw
    if ($cfg -notmatch 'OverrideCommands=True' -or $cfg -notmatch 'prism-packwiz-bootstrap\.ps1') {
        throw "Prism prelaunch bootstrap is not configured in instance.cfg"
    }
    Write-Host "OK prelaunch bootstrap configured" -ForegroundColor Green

    Write-Host "Prism manual check preflight completed." -ForegroundColor Green
}
finally {
    Pop-Location
}
