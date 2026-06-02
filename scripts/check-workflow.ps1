param()

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$serverDir = Resolve-Path (Join-Path $repoRoot "../tools/server") -ErrorAction Stop
$prismMinecraftDir = Join-Path $env:APPDATA "PrismLauncher/instances/aaa-otl Desarrollo/minecraft"

function Test-CommandPresent {
    param([string]$Name)
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($cmd) {
        Write-Host "[OK] command $Name -> $($cmd.Source)" -ForegroundColor Green
        return $true
    }
    Write-Host "[ERR] command missing: $Name" -ForegroundColor Red
    return $false
}

function Test-LinkTarget {
    param(
        [string]$Path,
        [string]$ExpectedTarget
    )

    if (-not (Test-Path $Path)) {
        Write-Host "[ERR] missing path: $Path" -ForegroundColor Red
        return $false
    }

    $item = Get-Item $Path
    if (-not ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
        Write-Host "[ERR] not a link: $Path" -ForegroundColor Red
        return $false
    }

    $target = $item.Target
    if ($target -is [System.Array]) { $target = $target[0] }

    if ([IO.Path]::GetFullPath($target) -ne [IO.Path]::GetFullPath($ExpectedTarget)) {
        Write-Host "[ERR] bad target: $Path -> $target (expected $ExpectedTarget)" -ForegroundColor Red
        return $false
    }

    Write-Host "[OK] link: $Path -> $target" -ForegroundColor Green
    return $true
}

function Test-RealDirectory {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        Write-Host "[ERR] missing path: $Path" -ForegroundColor Red
        return $false
    }

    $item = Get-Item $Path
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        Write-Host "[ERR] should be a real directory, not a link: $Path" -ForegroundColor Red
        return $false
    }

    Write-Host "[OK] real directory: $Path" -ForegroundColor Green
    return $true
}

$ok = $true

$ok = (Test-CommandPresent -Name "packwiz") -and $ok
$ok = (Test-CommandPresent -Name "java") -and $ok
$ok = (Test-CommandPresent -Name "git") -and $ok

$repoConfig = Join-Path $repoRoot "config"
$repoKubejs = Join-Path $repoRoot "kubejs"
$repoMods = Join-Path $repoRoot "mods"
$prismInstanceCfg = Join-Path $prismMinecraftDir "..\instance.cfg"
$prismBootstrapJar = Join-Path $prismMinecraftDir "packwiz-installer-bootstrap.jar"
$prismModsDir = Join-Path $prismMinecraftDir "mods"

foreach ($p in @($repoConfig, $repoKubejs, $repoMods, $serverDir)) {
    if (Test-Path $p) {
        Write-Host "[OK] exists: $p" -ForegroundColor Green
    }
    else {
        Write-Host "[ERR] missing: $p" -ForegroundColor Red
        $ok = $false
    }
}

$ok = (Test-LinkTarget -Path (Join-Path $prismMinecraftDir "config") -ExpectedTarget $repoConfig) -and $ok
$ok = (Test-LinkTarget -Path (Join-Path $prismMinecraftDir "kubejs") -ExpectedTarget $repoKubejs) -and $ok
$ok = (Test-RealDirectory -Path $prismModsDir) -and $ok

if (Test-Path $prismInstanceCfg) {
    $cfg = Get-Content $prismInstanceCfg -Raw
    if ($cfg -match 'OverrideCommands=True' -and $cfg -match 'prism-packwiz-bootstrap\.ps1') {
        Write-Host "[OK] Prism prelaunch bootstrap configured" -ForegroundColor Green
    }
    else {
        Write-Host "[ERR] Prism prelaunch bootstrap not configured" -ForegroundColor Red
        $ok = $false
    }
} else {
    Write-Host "[ERR] missing Prism instance.cfg: $prismInstanceCfg" -ForegroundColor Red
    $ok = $false
}

if (Test-Path $prismBootstrapJar) {
    Write-Host "[OK] Prism bootstrap jar exists: $prismBootstrapJar" -ForegroundColor Green
} else {
    Write-Host "[ERR] missing Prism bootstrap jar: $prismBootstrapJar" -ForegroundColor Red
    $ok = $false
}

$ok = (Test-LinkTarget -Path (Join-Path $serverDir "config") -ExpectedTarget $repoConfig) -and $ok
$ok = (Test-LinkTarget -Path (Join-Path $serverDir "kubejs") -ExpectedTarget $repoKubejs) -and $ok

$serverRun = Join-Path $serverDir "run.bat"
$serverPregen = Join-Path $serverDir "run-pregen.ps1"
foreach ($p in @($serverRun, $serverPregen)) {
    if (Test-Path $p) {
        Write-Host "[OK] exists: $p" -ForegroundColor Green
    }
    else {
        Write-Host "[ERR] missing: $p" -ForegroundColor Red
        $ok = $false
    }
}

if ($ok) {
    Write-Host "Workflow check passed." -ForegroundColor Green
    exit 0
}

Write-Host "Workflow check failed." -ForegroundColor Red
exit 1
