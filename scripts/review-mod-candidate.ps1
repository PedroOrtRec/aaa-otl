param(
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [string]$GameVersion = "1.21.1",
    [string]$Loader = "neoforge",
    [string]$ModsDir = "mods",
    [string]$OutDir = "reports"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$modsDirPath = Join-Path $repoRoot $ModsDir
$outDirPath = Join-Path $repoRoot $OutDir
if (-not (Test-Path $outDirPath)) {
    New-Item -ItemType Directory -Path $outDirPath | Out-Null
}

if (-not (Test-Path $modsDirPath)) {
    throw "Mods directory not found: $modsDirPath"
}

function Parse-PwTomlValue {
    param(
        [string[]]$Lines,
        [string]$Key,
        [switch]$Last
    )

    $matches = $Lines | Where-Object { $_ -match ('^' + [regex]::Escape($Key) + '\s*=\s*"') }
    if (-not $matches) { return $null }
    $line = if ($Last) { $matches | Select-Object -Last 1 } else { $matches | Select-Object -First 1 }
    return ($line -replace ('^' + [regex]::Escape($Key) + '\s*=\s*"|"$'), '')
}

$installedByModId = @{}
$installedByName = @{}
Get-ChildItem -Path $modsDirPath -Filter "*.pw.toml" -File | ForEach-Object {
    $raw = Get-Content -Path $_.FullName
    $name = Parse-PwTomlValue -Lines $raw -Key "name"
    $modId = Parse-PwTomlValue -Lines $raw -Key "mod-id"
    if ($name) { $installedByName[$name.ToLowerInvariant()] = $true }
    if ($modId) { $installedByModId[$modId] = $true }
}

$facets = ('[["project_type:mod"],["versions:' + $GameVersion + '"],["categories:' + $Loader + '"]]')
$url = "https://api.modrinth.com/v2/search?query=$([uri]::EscapeDataString($Query))&limit=10&index=relevance&facets=$([uri]::EscapeDataString($facets))"
$search = Invoke-RestMethod -Uri $url -Method Get
if (-not $search.hits -or $search.hits.Count -eq 0) {
    throw "No Modrinth mod results found for query '$Query' ($GameVersion/$Loader)."
}

$candidate = $search.hits | Select-Object -First 1
$modId = $candidate.project_id
$project = Invoke-RestMethod -Uri ("https://api.modrinth.com/v2/project/{0}" -f $modId) -Method Get
$loadersParam = [uri]::EscapeDataString('["' + $Loader + '"]')
$versionsParam = [uri]::EscapeDataString('["' + $GameVersion + '"]')
$versionQuery = "https://api.modrinth.com/v2/project/$modId/version?loaders=$loadersParam&game_versions=$versionsParam"
$versions = Invoke-RestMethod -Uri $versionQuery -Method Get

$selectedVersion = $null
if ($versions -and $versions.Count -gt 0) {
    $selectedVersion = $versions[0]
}

$requiredDeps = @()
$missingDeps = @()
if ($selectedVersion -and $selectedVersion.dependencies) {
    foreach ($dep in $selectedVersion.dependencies) {
        if ($dep.dependency_type -ne "required") {
            continue
        }

        if (-not $dep.project_id) {
            continue
        }

        $requiredDeps += $dep.project_id
        if (-not $installedByModId.ContainsKey($dep.project_id)) {
            $depProject = $null
            try {
                $depProject = Invoke-RestMethod -Uri ("https://api.modrinth.com/v2/project/{0}" -f $dep.project_id) -Method Get
            }
            catch {
            }

            $missingDeps += [PSCustomObject]@{
                ProjectId = $dep.project_id
                Name = if ($depProject) { $depProject.title } else { "unknown" }
            }
        }
    }
}

$alreadyInstalled = $installedByModId.ContainsKey($modId) -or $installedByName.ContainsKey($project.title.ToLowerInvariant())

$clientSide = if ($candidate.client_side) { $candidate.client_side } else { "unknown" }
$serverSide = if ($candidate.server_side) { $candidate.server_side } else { "unknown" }
$serverRisk = if ($serverSide -eq "unsupported") { "high" } elseif ($serverSide -eq "optional") { "medium" } else { "low" }

$compatibility = "good"
if ($missingDeps.Count -gt 0) {
    $compatibility = "needs-dependencies"
}
if ($serverRisk -eq "high") {
    $compatibility = "client-only-risk"
}
if ($alreadyInstalled) {
    $compatibility = "already-installed"
}

$summary = "Candidate appears suitable for evaluation"
if ($compatibility -eq "already-installed") {
    $summary = "Candidate is already installed in the pack."
}
elseif ($compatibility -eq "client-only-risk") {
    $summary = "Candidate is client-focused; validate dedicated server compatibility before adding."
}
elseif ($compatibility -eq "needs-dependencies") {
    $summary = "Candidate requires additional dependencies not currently installed."
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$safeSlug = ($project.slug -replace "[^a-zA-Z0-9-]", "-")
$outPath = Join-Path $outDirPath ("mod-review-{0}-{1}.md" -f $safeSlug, $timestamp)

$lines = @()
$lines += "# Mod Candidate Review"
$lines += ""
$lines += ("Query: {0}" -f $Query)
$lines += ("Candidate: {0}" -f $project.title)
$lines += ("Slug: {0}" -f $project.slug)
$lines += ("Modrinth ID: {0}" -f $modId)
$lines += ("Compatibility verdict: {0}" -f $compatibility)
$lines += ("Summary: {0}" -f $summary)
$lines += ""
$lines += "## Compatibility"
$lines += ("- Game version target: {0}" -f $GameVersion)
$lines += ("- Loader target: {0}" -f $Loader)
$lines += ("- Client side: {0}" -f $clientSide)
$lines += ("- Server side: {0}" -f $serverSide)
$lines += ("- Server risk level: {0}" -f $serverRisk)
$lines += ""
$lines += "## Dependencies"
if ($requiredDeps.Count -eq 0) {
    $lines += "- Required dependencies: none"
}
else {
    $lines += ("- Required dependencies detected: {0}" -f $requiredDeps.Count)
}
if ($missingDeps.Count -eq 0) {
    $lines += "- Missing dependencies in current pack: none"
}
else {
    foreach ($dep in $missingDeps) {
        $lines += ("- Missing: {0} ({1})" -f $dep.Name, $dep.ProjectId)
    }
}
$lines += ""
$lines += "## Metadata"
$lines += ("- Description: {0}" -f $project.description)
$lines += ("- Project URL: https://modrinth.com/mod/{0}" -f $project.slug)
$lines += ("- Source URL: {0}" -f ($(if ($project.source_url) { $project.source_url } else { "n/a" })))
if ($selectedVersion) {
    $lines += ("- Selected version: {0}" -f $selectedVersion.version_number)
    $lines += ("- Version id: {0}" -f $selectedVersion.id)
}
$lines += ""
$lines += ("Generated: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))

Set-Content -Path $outPath -Value $lines

Write-Host ("Review generated: {0}" -f $outPath) -ForegroundColor Green
Write-Host ("Verdict: {0}" -f $compatibility) -ForegroundColor Cyan
