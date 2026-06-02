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

$instanceLines = Get-Content -Path $instanceCfg
$preLaunchCommand = 'powershell -ExecutionPolicy Bypass -File "{0}"' -f $preLaunchScript

$normalizedLines = New-Object System.Collections.Generic.List[string]
foreach ($line in $instanceLines) {
    if ($line -notmatch '^(OverrideCommands=|PreLaunchCommand=)') {
        $normalizedLines.Add($line)
    }
}

$normalizedLines.Add('OverrideCommands=True')
$normalizedLines.Add('PreLaunchCommand=' + $preLaunchCommand)

Set-Content -Path $instanceCfg -Value $normalizedLines

Write-Host "Prism runtime configured." -ForegroundColor Green
Write-Host "Bootstrap jar: $bootstrapJar"
Write-Host "Instance mods folder: $instanceMods"
Write-Host "PreLaunchCommand set to: $preLaunchCommand"
