param(
    [string]$ModsDir = "mods",
    [string]$CategoryMapPath = "config/mod-catalog/categories.json",
    [string]$OutputPath = ".github/.context/mod-list.md",
    [int]$MaxDescriptionLength = 140
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$modsDirPath = Join-Path $repoRoot $ModsDir
$mapPath = Join-Path $repoRoot $CategoryMapPath
$outPath = Join-Path $repoRoot $OutputPath

if (-not (Test-Path $modsDirPath)) {
    throw "Mods directory not found: $modsDirPath"
}

if (-not (Test-Path $mapPath)) {
    throw "Category map not found: $mapPath"
}

$categoryMap = Get-Content -Path $mapPath -Raw | ConvertFrom-Json
$byName = $categoryMap.byName
$order = @($categoryMap.categoryOrder)

function Parse-PwTomlValue {
    param(
        [string[]]$Lines,
        [string]$Key,
        [switch]$Last
    )

    $matches = $Lines | Where-Object { $_ -match ('^' + [regex]::Escape($Key) + '\s*=\s*"') }
    if (-not $matches) {
        return $null
    }

    $line = if ($Last) { $matches | Select-Object -Last 1 } else { $matches | Select-Object -First 1 }
    return ($line -replace ('^' + [regex]::Escape($Key) + '\s*=\s*"|"$'), '')
}

$files = Get-ChildItem -Path $modsDirPath -Filter "*.pw.toml" -File | Sort-Object Name
if (-not $files -or $files.Count -eq 0) {
    throw "No .pw.toml files found in $modsDirPath"
}

$items = @()
foreach ($file in $files) {
    $raw = Get-Content -Path $file.FullName

    $name = Parse-PwTomlValue -Lines $raw -Key "name"
    $filename = Parse-PwTomlValue -Lines $raw -Key "filename"
    $modId = Parse-PwTomlValue -Lines $raw -Key "mod-id"
    $versionId = Parse-PwTomlValue -Lines $raw -Key "version" -Last

    if ([string]::IsNullOrWhiteSpace($name)) {
        $name = $file.BaseName
    }

    $version = if ($filename) { $filename -replace "\.jar$", "" } else { "unknown" }
    $author = "unknown"
    $description = "Utility component for pack behavior and compatibility."

    if (-not [string]::IsNullOrWhiteSpace($modId)) {
        try {
            $project = Invoke-RestMethod -Uri ("https://api.modrinth.com/v2/project/{0}" -f $modId) -Method Get
            if ($project.description) {
                $description = $project.description.Trim()
            }

            $members = Invoke-RestMethod -Uri ("https://api.modrinth.com/v2/project/{0}/members" -f $modId) -Method Get
            $owner = $members | Where-Object { $_.role -match "Owner|owner" } | Select-Object -First 1
            if ($owner -and $owner.user -and $owner.user.username) {
                $author = $owner.user.username
            }
            elseif ($members -and $members[0].user -and $members[0].user.username) {
                $author = $members[0].user.username
            }
        }
        catch {
            if (-not [string]::IsNullOrWhiteSpace($versionId)) {
                try {
                    $versionInfo = Invoke-RestMethod -Uri ("https://api.modrinth.com/v2/version/{0}" -f $versionId) -Method Get
                    if ($versionInfo -and $versionInfo.author_id) {
                        $user = Invoke-RestMethod -Uri ("https://api.modrinth.com/v2/user/{0}" -f $versionInfo.author_id) -Method Get
                        if ($user -and $user.username) {
                            $author = $user.username
                        }
                    }
                }
                catch {
                }
            }
        }
    }

    if ($description.Length -gt $MaxDescriptionLength) {
        $description = $description.Substring(0, $MaxDescriptionLength - 3) + "..."
    }

    $normalized = $name.ToLowerInvariant()
    $category = $byName.$normalized
    if ([string]::IsNullOrWhiteSpace($category)) {
        $category = "uncategorized"
    }

    $items += [PSCustomObject]@{
        Category = $category
        Name = $name
        Version = $version
        Author = $author
        Description = $description
    }
}

$grouped = @{}
foreach ($item in $items) {
    if (-not $grouped.ContainsKey($item.Category)) {
        $grouped[$item.Category] = @()
    }
    $grouped[$item.Category] += $item
}

$finalOrder = @()
$finalOrder += $order
foreach ($category in ($grouped.Keys | Sort-Object)) {
    if ($finalOrder -notcontains $category) {
        $finalOrder += $category
    }
}

$lines = @()
$lines += "# mod-list"
$lines += ""
$lines += ("Total mods: {0}" -f $items.Count)
$lines += ""

foreach ($category in $finalOrder) {
    if (-not $grouped.ContainsKey($category)) {
        continue
    }

    $lines += ("## {0}" -f $category)
    $lines += "| Name | Version | Author | Description |"
    $lines += "|---|---|---|---|"
    foreach ($item in ($grouped[$category] | Sort-Object Name)) {
        $lines += ("| {0} | {1} | {2} | {3} |" -f $item.Name, $item.Version, $item.Author, $item.Description)
    }
    $lines += ""
}

$lines += ("Updated: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))

Set-Content -Path $outPath -Value $lines
Write-Host ("mod-list regenerated: {0}" -f $outPath) -ForegroundColor Green
