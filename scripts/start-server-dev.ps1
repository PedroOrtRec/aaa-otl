param(
    [switch]$SkipWorldReset,
    [switch]$SkipModSync,
    [switch]$NoLaunch
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$serverScript = Resolve-Path (Join-Path $repoRoot "../tools/server/run-pregen.ps1") -ErrorAction Stop

$params = @()
if ($SkipWorldReset) { $params += "-SkipWorldReset" }
if ($SkipModSync) { $params += "-SkipModSync" }
if ($NoLaunch) { $params += "-NoLaunch" }

Write-Host "Calling $serverScript $($params -join ' ')" -ForegroundColor Cyan
& $serverScript @params
