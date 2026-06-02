param(
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [ValidateSet("mod", "datapack", "resourcepack", "shader")]
    [string]$Type = "mod",
    [string]$GameVersion = "1.21.1",
    [string]$Loader = "neoforge",
    [int]$Limit = 20
)

$ErrorActionPreference = "Stop"

$facetParts = @()
$facetParts += ('["project_type:' + $Type + '"]')
$facetParts += ('["versions:' + $GameVersion + '"]')

if ($Type -eq "mod" -and -not [string]::IsNullOrWhiteSpace($Loader)) {
    $facetParts += ('["categories:' + $Loader + '"]')
}

$facetsJson = "[" + ($facetParts -join ",") + "]"
$encodedFacets = [uri]::EscapeDataString($facetsJson)
$encodedQuery = [uri]::EscapeDataString($Query)
$url = "https://api.modrinth.com/v2/search?query=$encodedQuery&limit=$Limit&index=relevance&facets=$encodedFacets"

$response = Invoke-RestMethod -Uri $url -Method Get

if (-not $response.hits -or $response.hits.Count -eq 0) {
    Write-Host "No Modrinth results for query: $Query" -ForegroundColor Yellow
    exit 0
}

$results = $response.hits | Select-Object `
    @{N = "title"; E = { $_.title }}, `
    @{N = "type"; E = { $_.project_type }}, `
    @{N = "slug"; E = { $_.slug }}, `
    @{N = "downloads"; E = { $_.downloads }}, `
    @{N = "versions"; E = { ($_.versions -join ",") }}, `
    @{N = "categories"; E = { ($_.categories -join ",") }}, `
    @{N = "client"; E = { $_.client_side }}, `
    @{N = "server"; E = { $_.server_side }}, `
    @{N = "sourceUrl"; E = { $_.source_url }}, `
    @{N = "projectUrl"; E = { "https://modrinth.com/$($_.project_type)/$($_.slug)" }}

$results | Format-Table -AutoSize
