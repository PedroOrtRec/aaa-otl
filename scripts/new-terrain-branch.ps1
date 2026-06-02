param(
    [Parameter(Mandatory = $true)]
    [string]$Slug,
    [string]$Seed,
    [switch]$NoCheckout
)

$ErrorActionPreference = "Stop"
if ($null -ne (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue)) {
    $PSNativeCommandUseErrorActionPreference = $false
}

$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot
try {
    $branchName = "terrain/$Slug"

    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "git not found in PATH"
    }

    cmd /c "git rev-parse --is-inside-work-tree >nul 2>nul"
    if ($LASTEXITCODE -ne 0) {
        throw "Current folder is not a git repository: $repoRoot"
    }

    cmd /c "git rev-parse --verify HEAD >nul 2>nul"
    $hasHead = ($LASTEXITCODE -eq 0)

    cmd /c "git show-ref --verify --quiet refs/heads/$branchName"
    $branchExists = ($LASTEXITCODE -eq 0)

    if ($branchExists) {
        Write-Host "Branch already exists: $branchName" -ForegroundColor Yellow
    }
    else {
        if (-not $hasHead) {
            if ($NoCheckout) {
                throw "Cannot create branch without initial commit when -NoCheckout is used. Create an initial commit or run without -NoCheckout to create an orphan branch."
            }

            git checkout --orphan $branchName | Out-Null
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to create orphan branch: $branchName"
            }
            Write-Host "Orphan branch created and checked out: $branchName" -ForegroundColor Green
        }
        else {
            git branch $branchName | Out-Null
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to create branch: $branchName"
            }
            Write-Host "Branch created: $branchName" -ForegroundColor Green
        }
    }

    if (-not $NoCheckout -and $hasHead) {
        git checkout $branchName | Out-Null
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to checkout branch: $branchName"
        }
        Write-Host "Checked out: $branchName" -ForegroundColor Green
    }

    if ($Seed) {
        $activeSeedPath = Join-Path $repoRoot "config/worldgen/active-seed.txt"
        Set-Content -Path $activeSeedPath -Value $Seed
        Write-Host "Active seed written: $activeSeedPath" -ForegroundColor Green
    }
}
finally {
    Pop-Location
}
