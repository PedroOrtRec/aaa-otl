param(
    [ValidateSet("prism", "server", "both")]
    [string]$Source = "both",
    [string]$PrismInstanceName = "aaa-otl Desarrollo",
    [string]$ServerDir = "../tools/server",
    [int]$TailLines = 500,
    [string]$OutDir = "reports"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$outDirPath = Join-Path $repoRoot $OutDir
if (-not (Test-Path $outDirPath)) {
    New-Item -ItemType Directory -Path $outDirPath | Out-Null
}

$paths = @()
if ($Source -eq "prism" -or $Source -eq "both") {
    $prismLog = Join-Path $env:APPDATA ("PrismLauncher/instances/{0}/minecraft/logs/latest.log" -f $PrismInstanceName)
    $paths += [PSCustomObject]@{ Name = "prism"; Path = $prismLog }
}
if ($Source -eq "server" -or $Source -eq "both") {
    $serverLog = Join-Path (Resolve-Path (Join-Path $repoRoot $ServerDir)).Path "logs/latest.log"
    $paths += [PSCustomObject]@{ Name = "server"; Path = $serverLog }
}

function Analyze-Log {
    param(
        [string]$Name,
        [string]$Path,
        [int]$Tail
    )

    if (-not (Test-Path $Path)) {
        return [PSCustomObject]@{
            Name = $Name
            Path = $Path
            Exists = $false
            LineCount = 0
            WarningCount = 0
            ErrorCount = 0
            TpsMentions = 0
            MsptMentions = 0
            SparkMentions = 0
            AvgMspt = "n/a"
            MinMspt = "n/a"
            MaxMspt = "n/a"
            AvgTps = "n/a"
            MinTps = "n/a"
            MaxTps = "n/a"
            Evidence = @()
        }
    }

    $lines = Get-Content -Path $Path -Tail $Tail -ErrorAction SilentlyContinue
    $warningCount = ($lines | Where-Object { $_ -match "\\bWARN\\b|\\bWARNING\\b" }).Count
    $errorCount = ($lines | Where-Object { $_ -match "\\bERROR\\b|Exception|\\bFATAL\\b" }).Count
    $sparkMentions = ($lines | Where-Object { $_ -match "spark|\\[spark\\]" }).Count
    $tpsMentions = ($lines | Where-Object { $_ -match "\\btps\\b|\\bTPS\\b" }).Count
    $msptMentions = ($lines | Where-Object { $_ -match "\\bmspt\\b|\\bMSPT\\b" }).Count

    $msptValues = @()
    $tpsValues = @()
    foreach ($line in $lines) {
        $msptMatch = [regex]::Match($line, "([0-9]+(?:\\.[0-9]+)?)\\s*mspt", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($msptMatch.Success) {
            $msptValues += [double]$msptMatch.Groups[1].Value
        }

        $tpsMatch = [regex]::Match($line, "([0-9]+(?:\\.[0-9]+)?)\\s*tps", [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($tpsMatch.Success) {
            $tpsValues += [double]$tpsMatch.Groups[1].Value
        }
    }

    $evidence = $lines | Where-Object { $_ -match "spark|\\btps\\b|\\bmspt\\b|\\bWARN\\b|\\bERROR\\b|Exception" } | Select-Object -Last 25

    return [PSCustomObject]@{
        Name = $Name
        Path = $Path
        Exists = $true
        LineCount = $lines.Count
        WarningCount = $warningCount
        ErrorCount = $errorCount
        TpsMentions = $tpsMentions
        MsptMentions = $msptMentions
        SparkMentions = $sparkMentions
        AvgMspt = if ($msptValues.Count -gt 0) { [math]::Round(($msptValues | Measure-Object -Average).Average, 2) } else { "n/a" }
        MinMspt = if ($msptValues.Count -gt 0) { [math]::Round(($msptValues | Measure-Object -Minimum).Minimum, 2) } else { "n/a" }
        MaxMspt = if ($msptValues.Count -gt 0) { [math]::Round(($msptValues | Measure-Object -Maximum).Maximum, 2) } else { "n/a" }
        AvgTps = if ($tpsValues.Count -gt 0) { [math]::Round(($tpsValues | Measure-Object -Average).Average, 2) } else { "n/a" }
        MinTps = if ($tpsValues.Count -gt 0) { [math]::Round(($tpsValues | Measure-Object -Minimum).Minimum, 2) } else { "n/a" }
        MaxTps = if ($tpsValues.Count -gt 0) { [math]::Round(($tpsValues | Measure-Object -Maximum).Maximum, 2) } else { "n/a" }
        Evidence = $evidence
    }
}

$results = @()
foreach ($entry in $paths) {
    $results += Analyze-Log -Name $entry.Name -Path $entry.Path -Tail $TailLines
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$outPath = Join-Path $outDirPath ("performance-report-{0}.md" -f $timestamp)

$lines = @()
$lines += "# Performance Monitoring Report"
$lines += ""
$lines += ("Generated: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
$lines += ("Source mode: {0}" -f $Source)
$lines += ""
$lines += "Tip: use spark in-game or on server for richer profiling data."
$lines += ""

foreach ($r in $results) {
    $lines += ("## {0}" -f $r.Name)
    $lines += ("- Log path: {0}" -f $r.Path)
    if (-not $r.Exists) {
        $lines += "- Status: missing log file"
        $lines += ""
        continue
    }

    $lines += "- Status: log found"
    $lines += ("- Analyzed lines: {0}" -f $r.LineCount)
    $lines += ("- Warnings: {0}" -f $r.WarningCount)
    $lines += ("- Errors/exceptions: {0}" -f $r.ErrorCount)
    $lines += ("- spark mentions: {0}" -f $r.SparkMentions)
    $lines += ("- TPS mentions: {0}" -f $r.TpsMentions)
    $lines += ("- MSPT mentions: {0}" -f $r.MsptMentions)
    $lines += ("- TPS avg/min/max: {0} / {1} / {2}" -f $r.AvgTps, $r.MinTps, $r.MaxTps)
    $lines += ("- MSPT avg/min/max: {0} / {1} / {2}" -f $r.AvgMspt, $r.MinMspt, $r.MaxMspt)
    $lines += ""
    $lines += "Evidence tail:"
    foreach ($line in $r.Evidence) {
        $lines += ("- {0}" -f $line)
    }
    $lines += ""
}

Set-Content -Path $outPath -Value $lines

Write-Host ("Performance report generated: {0}" -f $outPath) -ForegroundColor Green
