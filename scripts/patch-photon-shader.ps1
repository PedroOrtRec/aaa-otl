param(
    [string]$InstanceName = "aaa-otl Desarrollo",
    [string]$ShaderZipName = "photon_v1.3b.zip"
)

$ErrorActionPreference = "Stop"

$instanceMinecraft = Join-Path $env:APPDATA ("PrismLauncher/instances/{0}/minecraft" -f $InstanceName)
$shaderZipPath = Join-Path $instanceMinecraft ("shaderpacks/{0}" -f $ShaderZipName)

if (-not (Test-Path $shaderZipPath)) {
    throw "Shader zip not found: $shaderZipPath"
}

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$entryPath = "shaders/shaders.properties"
$zip = [System.IO.Compression.ZipFile]::Open($shaderZipPath, [System.IO.Compression.ZipArchiveMode]::Update)

try {
    $entry = $zip.GetEntry($entryPath)
    if (-not $entry) {
        throw "Entry not found in shader zip: $entryPath"
    }

    $reader = New-Object System.IO.StreamReader($entry.Open())
    $content = $reader.ReadToEnd()
    $reader.Dispose()

    if ($content -notmatch '(?m)^dynamicHandLight\s*=\s*(true|false)\s*$') {
        throw "dynamicHandLight directive not found in shaders.properties"
    }

    $updated = $content -replace '(?m)^dynamicHandLight\s*=\s*true\s*$', 'dynamicHandLight    = false'

    if ($updated -eq $content) {
        Write-Host "Photon patch already applied (dynamicHandLight=false)." -ForegroundColor Green
        return
    }

    $entry.Delete()
    $newEntry = $zip.CreateEntry($entryPath, [System.IO.Compression.CompressionLevel]::Optimal)
    $writer = New-Object System.IO.StreamWriter($newEntry.Open())
    $writer.Write($updated)
    $writer.Flush()
    $writer.Dispose()

    Write-Host "Patched Photon shader: dynamicHandLight=false" -ForegroundColor Green
}
finally {
    $zip.Dispose()
}
