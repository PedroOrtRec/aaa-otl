param(
    [string]$RepoRoot = "C:\Users\pedro\Developer\aaa-otl",
    [string]$InstanceName = "aaa-otl Desarrollo"
)

$ErrorActionPreference = "Stop"
$ConfirmPreference = 'None'

$instanceRoot = Join-Path $env:APPDATA ("PrismLauncher/instances/{0}" -f $InstanceName)
$instanceMinecraft = Join-Path $instanceRoot "minecraft"
$instanceMods = Join-Path $instanceMinecraft "mods"
$bootstrapJar = Join-Path $instanceMinecraft "packwiz-installer-bootstrap.jar"
$preLaunchScript = Join-Path $RepoRoot "scripts/prism-packwiz-bootstrap.ps1"
$instanceCfg = Join-Path $instanceRoot "instance.cfg"

if (-not (Test-Path $instanceRoot)) {
    throw "Prism instance not found: $instanceRoot"
}

if (-not (Test-Path $instanceMinecraft)) {
    throw "Prism minecraft folder not found: $instanceMinecraft"
}

if (-not (Test-Path $preLaunchScript)) {
    throw "Prelaunch script not found: $preLaunchScript"
}

$release = Invoke-RestMethod -Uri "https://api.github.com/repos/packwiz/packwiz-installer-bootstrap/releases/latest" -Headers @{ "User-Agent" = "Mozilla/5.0" }
$asset = $release.assets | Where-Object { $_.name -eq "packwiz-installer-bootstrap.jar" } | Select-Object -First 1
if (-not $asset) {
    throw "packwiz-installer-bootstrap.jar asset not found in latest release"
}

if ((Test-Path $bootstrapJar) -eq $false) {
    Write-Host "Downloading packwiz-installer-bootstrap.jar..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $bootstrapJar
}

if (Test-Path $instanceMods) {
    Remove-Item -LiteralPath $instanceMods -Recurse -Force -Confirm:$false
}

if (-not (Test-Path $instanceMods)) {
    New-Item -ItemType Directory -Path $instanceMods | Out-Null
}

if (-not (Test-Path $instanceCfg)) {
    throw "instance.cfg not found: $instanceCfg"
}

$instanceLines = [System.Collections.Generic.List[string]](Get-Content -Path $instanceCfg)
$preLaunchScriptForCfg = $preLaunchScript -replace '\\', '/'
$preLaunchCommand = 'powershell -ExecutionPolicy Bypass -File "{0}"' -f $preLaunchScriptForCfg

# Prism expects keys in [General]. Insert or replace there to avoid ignored values.
$generalStart = $instanceLines.IndexOf('[General]')
if ($generalStart -lt 0) {
    throw "[General] section not found in instance.cfg"
}

$nextSection = $instanceLines.Count
for ($i = $generalStart + 1; $i -lt $instanceLines.Count; $i++) {
    if ($instanceLines[$i] -match '^\[') {
        $nextSection = $i
        break
    }
}

$overrideFound = $false
$preLaunchFound = $false
for ($i = $generalStart + 1; $i -lt $nextSection; $i++) {
    if ($instanceLines[$i] -match '^OverrideCommands=') {
        $instanceLines[$i] = 'OverrideCommands=True'
        $overrideFound = $true
    }
    elseif ($instanceLines[$i] -match '^PreLaunchCommand=') {
        $instanceLines[$i] = 'PreLaunchCommand=' + $preLaunchCommand
        $preLaunchFound = $true
    }
}

$insertIndex = $nextSection
if (-not $overrideFound) {
    $instanceLines.Insert($insertIndex, 'OverrideCommands=True')
    $insertIndex++
}
if (-not $preLaunchFound) {
    $instanceLines.Insert($insertIndex, 'PreLaunchCommand=' + $preLaunchCommand)
}

# Remove duplicated keys outside [General] (legacy bad writes)
for ($i = $instanceLines.Count - 1; $i -ge 0; $i--) {
    if ($i -le $generalStart -or $i -ge $nextSection) {
        if ($instanceLines[$i] -match '^(OverrideCommands=|PreLaunchCommand=)') {
            $instanceLines.RemoveAt($i)
        }
    }
}

Set-Content -Path $instanceCfg -Value $instanceLines

Write-Host "Prism runtime configured." -ForegroundColor Green
Write-Host "Bootstrap jar: $bootstrapJar"
Write-Host "Instance mods folder: $instanceMods"
Write-Host "PreLaunchCommand set to: $preLaunchCommand"
