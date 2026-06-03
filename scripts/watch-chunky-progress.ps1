param(
    [string]$ServerDir = "../tools/server",
    [string]$OutDir = "reports",
    [int]$IntervalMinutes = 5,
    [int]$Samples = 12
)

$ErrorActionPreference = "Stop"

if ($IntervalMinutes -lt 1) {
    throw "IntervalMinutes must be >= 1"
}

if ($Samples -lt 1) {
    throw "Samples must be >= 1"
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$serverRoot = (Resolve-Path (Join-Path $repoRoot $ServerDir) -ErrorAction Stop).Path
$logPath = Join-Path $serverRoot "logs/latest.log"
$outRoot = Join-Path $repoRoot $OutDir

if (-not (Test-Path $outRoot)) {
    New-Item -ItemType Directory -Path $outRoot | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$reportPath = Join-Path $outRoot ("chunky-progress-{0}.md" -f $timestamp)

function Get-LatestChunkyStatus {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return "log missing"
    }

    $chunkyLines = Get-Content -Path $Path -Tail 800 -ErrorAction SilentlyContinue | Where-Object { $_ -match "\[Chunky\]" }
    if (-not $chunkyLines -or $chunkyLines.Count -eq 0) {
        return "no Chunky lines yet"
    }

    $latest = $chunkyLines[-1]
    return $latest
}

$header = @(
    "# Chunky Progress Report",
    "",
    ("Generated: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss")),
    ("Server log: {0}" -f $logPath),
    ("Interval: {0} minute(s)" -f $IntervalMinutes),
    ("Samples: {0}" -f $Samples),
    "",
    "## Polls"
)

Set-Content -Path $reportPath -Value $header

for ($i = 1; $i -le $Samples; $i++) {
    $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $status = Get-LatestChunkyStatus -Path $logPath
    $line = "- [$now] $status"
    Add-Content -Path $reportPath -Value $line
    Write-Host $line

    if ($i -lt $Samples) {
        Start-Sleep -Seconds ($IntervalMinutes * 60)
    }
}

Write-Host ("Chunky progress report generated: {0}" -f $reportPath) -ForegroundColor Green