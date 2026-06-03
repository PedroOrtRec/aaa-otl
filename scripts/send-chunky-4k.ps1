param(
    [int]$Radius = 4000,
    [switch]$CopyToClipboard
)

$ErrorActionPreference = "Stop"

$commands = @(
    "chunky radius $Radius",
    "chunky start"
)

Write-Host "Run these commands in the server console:" -ForegroundColor Cyan
foreach ($command in $commands) {
    Write-Host $command
}

if ($CopyToClipboard) {
    $commands -join [Environment]::NewLine | Set-Clipboard
    Write-Host "Commands copied to clipboard." -ForegroundColor Green
}