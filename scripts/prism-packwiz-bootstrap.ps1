param(
    [string]$RepoRoot = "C:\Users\pedro\Developer\aaa-otl",
    [string]$InstanceName = "aaa-otl Desarrollo",
    [int]$Port = 8080
)

$ErrorActionPreference = "Stop"

$repoRootResolved = (Resolve-Path $RepoRoot).Path
$instanceMinecraft = Join-Path $env:APPDATA ("PrismLauncher/instances/{0}/minecraft" -f $InstanceName)
$bootstrapJar = Join-Path $instanceMinecraft "packwiz-installer-bootstrap.jar"
$packUrl = "http://127.0.0.1:$Port/pack.toml"

if (-not (Test-Path $bootstrapJar)) {
    throw "Bootstrap jar not found: $bootstrapJar"
}

function Wait-PackwizServe {
    param([string]$WorkingDir, [int]$Port)

    try {
        Invoke-WebRequest -Uri $packUrl -UseBasicParsing -TimeoutSec 1 -ErrorAction Stop | Out-Null
        return $null
    }
    catch {
    }

    $packwizCmd = (Get-Command packwiz -ErrorAction Stop).Source
    $process = Start-Process -FilePath $packwizCmd -ArgumentList @("serve", "-p", $Port.ToString()) -WorkingDirectory $WorkingDir -PassThru -WindowStyle Hidden

    for ($i = 0; $i -lt 60; $i++) {
        try {
            Invoke-WebRequest -Uri $packUrl -UseBasicParsing -TimeoutSec 1 -ErrorAction Stop | Out-Null
            return $process
        }
        catch {
            Start-Sleep -Milliseconds 500
        }
    }

    if ($process -and -not $process.HasExited) {
        Stop-Process -Id $process.Id -Force
    }

    throw "packwiz serve did not become ready at $packUrl"
}

$serveProcess = $null
Push-Location $instanceMinecraft
try {
    $serveProcess = Wait-PackwizServe -WorkingDir $repoRootResolved -Port $Port
    $javaCmd = (Get-Command java -ErrorAction Stop).Source
    & $javaCmd -jar $bootstrapJar $packUrl
}
finally {
    Pop-Location
    if ($serveProcess -and -not $serveProcess.HasExited) {
        Stop-Process -Id $serveProcess.Id -Force
    }
}
