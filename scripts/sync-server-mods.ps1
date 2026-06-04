param(
	[int]$Port = 8090,
	[ValidateSet("server", "client", "both")]
	[string]$Side = "server"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$syncScript = Resolve-Path (Join-Path $repoRoot "scripts/push-packwiz-to-pregen.ps1") -ErrorAction Stop

Write-Host "Syncing server mods via packwiz bootstrap (metadata-driven side filtering)..." -ForegroundColor Cyan
& $syncScript -RepoRoot $repoRoot -Port $Port -Side $Side
