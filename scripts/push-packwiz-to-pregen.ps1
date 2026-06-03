param(
    [string]$RepoRoot,
    [string]$ServerDir,
    [int]$Port = 8090,
    [string]$BootstrapJarName = "packwiz-installer-bootstrap.jar"
)

$ErrorActionPreference = "Stop"

if (-not $RepoRoot) {
    $RepoRoot = Split-Path -Parent $PSScriptRoot
}

if (-not $ServerDir) {
    $ServerDir = Resolve-Path (Join-Path $RepoRoot "../tools/server") -ErrorAction Stop
}

$RepoRoot = (Resolve-Path $RepoRoot).Path
$ServerDir = (Resolve-Path $ServerDir).Path
$packUrl = "http://127.0.0.1:$Port/pack.toml"
$bootstrapJar = Join-Path $ServerDir $BootstrapJarName
$prismBootstrap = Join-Path $env:APPDATA "PrismLauncher/instances/aaa-otl Desarrollo/minecraft/$BootstrapJarName"

function Ensure-BootstrapJar {
    param(
        [string]$TargetJar,
        [string]$FallbackJar
    )

    if (Test-Path $TargetJar) {
        return
    }

    if (Test-Path $FallbackJar) {
        Copy-Item -Path $FallbackJar -Destination $TargetJar -Force
        return
    }

    $downloadUrl = "https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest/download/packwiz-installer-bootstrap.jar"
    Write-Host "Downloading $downloadUrl" -ForegroundColor Yellow
    Invoke-WebRequest -Uri $downloadUrl -OutFile $TargetJar -UseBasicParsing
}

function Wait-PackwizServe {
    param(
        [string]$WorkingDir,
        [int]$ListenPort,
        [string]$ProbeUrl
    )

    try {
        Invoke-WebRequest -Uri $ProbeUrl -UseBasicParsing -TimeoutSec 1 -ErrorAction Stop | Out-Null
        return $null
    }
    catch {
    }

    $packwizCmd = (Get-Command packwiz -ErrorAction Stop).Source
    $serveProcess = Start-Process -FilePath $packwizCmd -ArgumentList @("serve", "-p", $ListenPort.ToString()) -WorkingDirectory $WorkingDir -PassThru -WindowStyle Hidden

    for ($i = 0; $i -lt 120; $i++) {
        try {
            Invoke-WebRequest -Uri $ProbeUrl -UseBasicParsing -TimeoutSec 1 -ErrorAction Stop | Out-Null
            return $serveProcess
        }
        catch {
            Start-Sleep -Milliseconds 500
        }
    }

    if ($serveProcess -and -not $serveProcess.HasExited) {
        Stop-Process -Id $serveProcess.Id -Force
    }

    throw "packwiz serve did not become ready at $ProbeUrl"
}

Write-Host "Syncing pregen server with packwiz..." -ForegroundColor Cyan
Write-Host "Repo:   $RepoRoot"
Write-Host "Server: $ServerDir"

Ensure-BootstrapJar -TargetJar $bootstrapJar -FallbackJar $prismBootstrap

$serveProcess = $null
Push-Location $ServerDir
try {
    $serveProcess = Wait-PackwizServe -WorkingDir $RepoRoot -ListenPort $Port -ProbeUrl $packUrl
    $javaCmd = (Get-Command java -ErrorAction Stop).Source
    & $javaCmd -jar $bootstrapJar $packUrl
}
finally {
    Pop-Location
    if ($serveProcess -and -not $serveProcess.HasExited) {
        Stop-Process -Id $serveProcess.Id -Force
    }
}

Write-Host "Pregen server pack sync complete." -ForegroundColor Green