param(
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [ValidateSet("mod", "datapack", "resourcepack", "shader")]
    [string]$Type = "mod",
    [string]$GameVersion = "1.21.1",
    [string]$Loader = "neoforge",
    [switch]$SkipModrinth,
    [switch]$SkipCurseForge,
    [switch]$SkipGitHub,
    [switch]$ReviewCandidate,
    [int]$Limit = 10
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot

if (-not $SkipModrinth) {
    Write-Host "=== Modrinth ===" -ForegroundColor Cyan
    try {
        & (Join-Path $repoRoot "scripts/search-modrinth.ps1") -Query $Query -Type $Type -GameVersion $GameVersion -Loader $Loader -Limit $Limit
    }
    catch {
        Write-Host "Modrinth search failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    Write-Host ""
}

if (-not $SkipCurseForge) {
    Write-Host "=== CurseForge ===" -ForegroundColor Cyan
    try {
        & (Join-Path $repoRoot "scripts/search-curseforge.ps1") -Query $Query -Type $Type -GameVersion $GameVersion -Limit $Limit
    }
    catch {
        Write-Host "CurseForge search failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    Write-Host ""
}

if (-not $SkipGitHub) {
    Write-Host "=== GitHub source ===" -ForegroundColor Cyan
    $githubQuery = "$Query minecraft $Type"
    try {
        & (Join-Path $repoRoot "scripts/search-github-source.ps1") -Query $githubQuery -Limit $Limit
    }
    catch {
        Write-Host "GitHub search failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

if ($ReviewCandidate) {
    Write-Host "" 
    Write-Host "=== Candidate Review ===" -ForegroundColor Cyan
    try {
        if ($Type -eq "mod") {
            & (Join-Path $repoRoot "scripts/review-mod-candidate.ps1") -Query $Query -GameVersion $GameVersion -Loader $Loader
        }
        else {
            & (Join-Path $repoRoot "scripts/review-content-candidate.ps1") -Query $Query -Type $Type -GameVersion $GameVersion
        }
    }
    catch {
        Write-Host "Candidate review failed: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}
