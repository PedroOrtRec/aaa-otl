param(
    [int]$Radius = 4000,
    [switch]$SkipPackSync,
    [switch]$SkipWorldReset
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$serverDir = (Resolve-Path (Join-Path $repoRoot "../tools/server") -ErrorAction Stop).Path
$serverRunBat = Join-Path $serverDir "run.bat"
$pregenScript = Join-Path $serverDir "run-pregen.ps1"
$packSyncScript = Join-Path $repoRoot "scripts/push-packwiz-to-pregen.ps1"

if (-not (Test-Path $serverRunBat)) {
    throw "run.bat not found at $serverRunBat"
}

if (-not (Test-Path $pregenScript)) {
    throw "run-pregen.ps1 not found at $pregenScript"
}

function Stop-UnneededProcesses {
    # Target likely heavy client-side Java processes but avoid killing this repository server.
    $candidates = Get-CimInstance Win32_Process | Where-Object {
        $_.Name -in @("java.exe", "javaw.exe", "PrismLauncher.exe")
    }

    $stopped = 0
    foreach ($process in $candidates) {
        $cmdLine = if ($process.CommandLine) { $process.CommandLine.ToLowerInvariant() } else { "" }
        $isThisServer = $cmdLine.Contains($serverDir.ToLowerInvariant())
        $looksLikeClient = $cmdLine.Contains("prismlauncher") -or $cmdLine.Contains("minecraft") -or $process.Name -ieq "PrismLauncher.exe"

        if ($isThisServer -or -not $looksLikeClient) {
            continue
        }

        try {
            Stop-Process -Id $process.ProcessId -Force -ErrorAction Stop
            $stopped++
        }
        catch {
            Write-Host "Could not stop PID $($process.ProcessId): $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }

    Get-Process -Name "packwiz" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "Stopped candidate processes: $stopped" -ForegroundColor Green
}

function Wait-ServerReady {
    param([string]$LogPath)

    for ($i = 0; $i -lt 240; $i++) {
        if (Test-Path $LogPath) {
            $tail = Get-Content -Path $LogPath -Tail 80 -ErrorAction SilentlyContinue
            if ($tail -match "Done \(" -or $tail -match "For help, type \"help\"") {
                return $true
            }
        }
        Start-Sleep -Seconds 1
    }

    return $false
}

Write-Host "=== PREGEN 4K WORKFLOW ===" -ForegroundColor Cyan
Stop-UnneededProcesses

if (-not $SkipPackSync) {
    if (-not (Test-Path $packSyncScript)) {
        throw "Missing script: $packSyncScript"
    }
    & $packSyncScript
}

$pregenParams = @("-SkipModSync", "-NoLaunch")
if ($SkipWorldReset) {
    $pregenParams += "-SkipWorldReset"
}

Write-Host "Preparing server world/mod state..." -ForegroundColor Cyan
& $pregenScript @pregenParams

Write-Host "Launching server..." -ForegroundColor Cyan
$serverProcess = Start-Process -FilePath "cmd.exe" -ArgumentList @("/c", "run.bat", "nogui") -WorkingDirectory $serverDir -PassThru

$logFile = Join-Path $serverDir "logs/latest.log"
if (-not (Wait-ServerReady -LogPath $logFile)) {
    Write-Host "Server did not report ready state in time. Commands were not sent." -ForegroundColor Yellow
    Write-Host "Run these commands manually in server console:" -ForegroundColor Yellow
    Write-Host "chunky radius $Radius"
    Write-Host "chunky start"
    exit 0
}

Write-Host "Server started (PID $($serverProcess.Id))." -ForegroundColor Green
Write-Host "Chunky commands to run now in server console:" -ForegroundColor Cyan
Write-Host "chunky radius $Radius"
Write-Host "chunky start"
Write-Host "Use this command from repo root to send them automatically in this terminal session:" -ForegroundColor DarkCyan
Write-Host "  .\scripts\send-chunky-4k.ps1 -Radius $Radius"