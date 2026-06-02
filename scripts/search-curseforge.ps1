param(
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [ValidateSet("mod", "datapack", "resourcepack", "shader")]
    [string]$Type = "mod",
    [string]$GameVersion = "1.21.1",
    [int]$Limit = 20
)

$ErrorActionPreference = "Stop"

$apiKey = $env:CURSEFORGE_API_KEY
if ([string]::IsNullOrWhiteSpace($apiKey)) {
    $fallbackUrl = "https://www.curseforge.com/minecraft/search?page=1&pageSize=$Limit&sortBy=relevancy&search=$([uri]::EscapeDataString($Query))"
    Write-Host "CURSEFORGE_API_KEY not set. Use browser fallback:" -ForegroundColor Yellow
    Write-Host $fallbackUrl -ForegroundColor Cyan
    exit 0
}

$typeKeyword = switch ($Type) {
    "mod" { "mod" }
    "datapack" { "datapack" }
    "resourcepack" { "resource pack" }
    "shader" { "shader" }
}

$searchFilter = "$Query $typeKeyword"
$encodedSearch = [uri]::EscapeDataString($searchFilter)
$encodedVersion = [uri]::EscapeDataString($GameVersion)
$url = "https://api.curseforge.com/v1/mods/search?gameId=432&searchFilter=$encodedSearch&gameVersion=$encodedVersion&pageSize=$Limit&sortField=2&sortOrder=desc"

$headers = @{ "x-api-key" = $apiKey }
$response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers

if (-not $response.data -or $response.data.Count -eq 0) {
    Write-Host "No CurseForge results for query: $Query" -ForegroundColor Yellow
    exit 0
}

$results = $response.data | Select-Object `
    @{N = "name"; E = { $_.name }}, `
    @{N = "id"; E = { $_.id }}, `
    @{N = "summary"; E = { $_.summary }}, `
    @{N = "downloads"; E = { $_.downloadCount }}, `
    @{N = "latestFiles"; E = { $_.latestFilesIndexes.Count }}, `
    @{N = "links"; E = { $_.links.websiteUrl }}

$results | Format-Table -Wrap -AutoSize
