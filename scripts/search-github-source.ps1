param(
    [Parameter(Mandatory = $true)]
    [string]$Query,
    [int]$Limit = 15
)

$ErrorActionPreference = "Stop"

$headers = @{ "Accept" = "application/vnd.github+json" }
if (-not [string]::IsNullOrWhiteSpace($env:GITHUB_TOKEN)) {
    $headers["Authorization"] = "Bearer $($env:GITHUB_TOKEN)"
}

$search = [uri]::EscapeDataString("$Query in:name,description,readme")
$url = "https://api.github.com/search/repositories?q=$search&sort=stars&order=desc&per_page=$Limit"

$response = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
if (-not $response.items -or $response.items.Count -eq 0) {
    Write-Host "No GitHub repositories found for query: $Query" -ForegroundColor Yellow
    exit 0
}

$results = $response.items | Select-Object `
    @{N = "fullName"; E = { $_.full_name }}, `
    @{N = "stars"; E = { $_.stargazers_count }}, `
    @{N = "updated"; E = { $_.updated_at }}, `
    @{N = "language"; E = { $_.language }}, `
    @{N = "archived"; E = { $_.archived }}, `
    @{N = "url"; E = { $_.html_url }}, `
    @{N = "description"; E = { $_.description }}

$results | Format-Table -Wrap -AutoSize
