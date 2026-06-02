param(
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [ValidateSet("datapack", "resourcepack", "shader")]
    [string]$Type,
    [string]$GameVersion = "1.21.1",
    [string]$OutDir = "reports",
    [int]$Limit = 20
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$outDirPath = Join-Path $repoRoot $OutDir
if (-not (Test-Path $outDirPath)) {
    New-Item -ItemType Directory -Path $outDirPath | Out-Null
}

function Invoke-ModrinthSearch {
    param(
        [string]$SearchQuery,
        [string]$FacetsJson,
        [int]$ResultLimit
    )

    $encodedQuery = [uri]::EscapeDataString($SearchQuery)
    $url = "https://api.modrinth.com/v2/search?query=$encodedQuery&limit=$ResultLimit&index=relevance"
    if (-not [string]::IsNullOrWhiteSpace($FacetsJson)) {
        $url += "&facets=$([uri]::EscapeDataString($FacetsJson))"
    }

    return Invoke-RestMethod -Uri $url -Method Get
}

function Resolve-RequiredDependencies {
    param(
        [object]$VersionObject
    )

    $resolved = @()
    if (-not $VersionObject -or -not $VersionObject.dependencies) {
        return $resolved
    }

    foreach ($dep in $VersionObject.dependencies) {
        if ($dep.dependency_type -ne "required") {
            continue
        }

        if (-not $dep.project_id) {
            continue
        }

        $depName = "unknown"
        try {
            $depProject = Invoke-RestMethod -Uri ("https://api.modrinth.com/v2/project/{0}" -f $dep.project_id) -Method Get
            if ($depProject -and $depProject.title) {
                $depName = $depProject.title
            }
        }
        catch {
        }

        $resolved += [PSCustomObject]@{
            ProjectId = $dep.project_id
            Name = $depName
        }
    }

    return $resolved
}

# Primary search constrained by type + game version.
$facets = ('[["project_type:' + $Type + '"],["versions:' + $GameVersion + '"]]')
$primary = Invoke-ModrinthSearch -SearchQuery $Query -FacetsJson $facets -ResultLimit $Limit
$typedHits = @($primary.hits | Where-Object { $_.project_type -eq $Type })

# Some queries can ignore type facets on Modrinth; fallback to broad query and enforce type locally.
if ($typedHits.Count -eq 0) {
    $fallback = Invoke-ModrinthSearch -SearchQuery $Query -FacetsJson $null -ResultLimit $Limit
    $typedHits = @($fallback.hits | Where-Object { $_.project_type -eq $Type })
}

if ($typedHits.Count -eq 0) {
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $safeQuery = (($Query.ToLowerInvariant() -replace "[^a-z0-9]+", "-").Trim('-'))
    if ([string]::IsNullOrWhiteSpace($safeQuery)) {
        $safeQuery = "query"
    }
    $outPath = Join-Path $outDirPath ("content-review-{0}-{1}.md" -f $safeQuery, $timestamp)

    $lines = @()
    $lines += "# Content Candidate Review"
    $lines += ""
    $lines += ("Query: {0}" -f $Query)
    $lines += "Candidate: n/a"
    $lines += ("Type: {0}" -f $Type)
    $lines += "Slug: n/a"
    $lines += "Modrinth ID: n/a"
    $lines += "Compatibility verdict: no-modrinth-match"
    $lines += "Summary: No matching candidate found on Modrinth for the requested type and Minecraft version."
    $lines += ""
    $lines += "## Compatibility"
    $lines += ("- Game version target: {0}" -f $GameVersion)
    $lines += ("- Project type: {0}" -f $Type)
    $lines += "- Matching version found: no"
    $lines += ""
    $lines += "## Dependencies"
    $lines += "- Required dependencies: unknown (no candidate selected)"
    $lines += ""
    $lines += "## Metadata"
    $lines += "- Description: n/a"
    $lines += "- Project URL: n/a"
    $lines += "- Source URL: n/a"
    $lines += ""
    $lines += "## Notes"
    $lines += "- Modrinth returned no matching typed result."
    $lines += ("- Manual fallback (CurseForge search): https://www.curseforge.com/minecraft/search?page=1&pageSize=20&sortBy=relevancy&search={0}" -f [uri]::EscapeDataString($Query))
    $lines += "- This reviewer is intended for datapacks/resourcepacks/shaders and does not validate local installation state."
    $lines += ""
    $lines += ("Generated: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))

    Set-Content -Path $outPath -Value $lines

    Write-Host ("Review generated: {0}" -f $outPath) -ForegroundColor Green
    Write-Host "Verdict: no-modrinth-match" -ForegroundColor Cyan
    exit 0
}

$candidate = $typedHits | Select-Object -First 1
$project = Invoke-RestMethod -Uri ("https://api.modrinth.com/v2/project/{0}" -f $candidate.project_id) -Method Get

$versionsParam = [uri]::EscapeDataString('["' + $GameVersion + '"]')
$versionUrl = "https://api.modrinth.com/v2/project/$($candidate.project_id)/version?game_versions=$versionsParam"
$versions = Invoke-RestMethod -Uri $versionUrl -Method Get

$selectedVersion = $null
if ($versions -and $versions.Count -gt 0) {
    $selectedVersion = $versions[0]
}

$requiredDeps = Resolve-RequiredDependencies -VersionObject $selectedVersion

$compatibility = "good"
$summary = "Candidate appears suitable for evaluation."
if (-not $selectedVersion) {
    $compatibility = "no-game-version-match"
    $summary = "Candidate exists but no compatible version was found for the requested Minecraft version."
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$safeSlug = ($project.slug -replace "[^a-zA-Z0-9-]", "-")
$outPath = Join-Path $outDirPath ("content-review-{0}-{1}.md" -f $safeSlug, $timestamp)

$lines = @()
$lines += "# Content Candidate Review"
$lines += ""
$lines += ("Query: {0}" -f $Query)
$lines += ("Candidate: {0}" -f $project.title)
$lines += ("Type: {0}" -f $Type)
$lines += ("Slug: {0}" -f $project.slug)
$lines += ("Modrinth ID: {0}" -f $candidate.project_id)
$lines += ("Compatibility verdict: {0}" -f $compatibility)
$lines += ("Summary: {0}" -f $summary)
$lines += ""
$lines += "## Compatibility"
$lines += ("- Game version target: {0}" -f $GameVersion)
$lines += ("- Project type: {0}" -f $candidate.project_type)
if ($selectedVersion) {
    $lines += "- Matching version found: yes"
}
else {
    $lines += "- Matching version found: no"
}
$lines += ""
$lines += "## Dependencies"
if (-not $selectedVersion) {
    $lines += "- Required dependencies: unknown (no compatible version found)"
}
elseif ($requiredDeps.Count -eq 0) {
    $lines += "- Required dependencies: none"
}
else {
    $lines += ("- Required dependencies detected: {0}" -f $requiredDeps.Count)
    foreach ($dep in $requiredDeps) {
        $lines += ("- Required: {0} ({1})" -f $dep.Name, $dep.ProjectId)
    }
}
$lines += ""
$lines += "## Metadata"
$lines += ("- Description: {0}" -f $project.description)
$lines += ("- Project URL: https://modrinth.com/{0}/{1}" -f $candidate.project_type, $project.slug)
$lines += ("- Source URL: {0}" -f ($(if ($project.source_url) { $project.source_url } else { "n/a" })))
if ($selectedVersion) {
    $lines += ("- Selected version: {0}" -f $selectedVersion.version_number)
    $lines += ("- Version id: {0}" -f $selectedVersion.id)
}
$lines += ""
$lines += "## Notes"
$lines += "- This reviewer is intended for datapacks/resourcepacks/shaders and does not validate local installation state."
$lines += ""
$lines += ("Generated: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))

Set-Content -Path $outPath -Value $lines

Write-Host ("Review generated: {0}" -f $outPath) -ForegroundColor Green
Write-Host ("Verdict: {0}" -f $compatibility) -ForegroundColor Cyan