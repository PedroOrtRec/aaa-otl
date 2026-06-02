param()

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$serverScript = Resolve-Path (Join-Path $repoRoot "../tools/server/run-pregen.ps1") -ErrorAction Stop

Write-Host "Syncing server mods only (no world reset, no launch)..." -ForegroundColor Cyan
& $serverScript -SkipWorldReset -NoLaunch
