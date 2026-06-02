---
name: content-discovery-aaa-otl
description: Fast discovery workflow for mods, datapacks, resourcepacks, and shaders across Modrinth, CurseForge, and GitHub source repositories.
---

# Content Discovery Skill

## Use when
- Searching mods, datapacks, resourcepacks, or shaders for Minecraft 1.21.1 NeoForge.
- Verifying compatibility, descriptions, links, and source repositories.
- Locating source code for mods/packs on GitHub.

## Priority order
1. Modrinth API for structured metadata.
2. CurseForge API (when CURSEFORGE_API_KEY is available).
3. GitHub repository search for source code and implementation details.

## Scripts
- scripts/search-modrinth.ps1
- scripts/search-curseforge.ps1
- scripts/search-github-source.ps1
- scripts/search-content.ps1

## Fast commands
- Unified search:
  - powershell -ExecutionPolicy Bypass -File .\scripts\search-content.ps1 -Query "tectonic" -Type mod -GameVersion 1.21.1 -Loader neoforge
- Modrinth only:
  - powershell -ExecutionPolicy Bypass -File .\scripts\search-modrinth.ps1 -Query "embeddium" -Type mod -GameVersion 1.21.1 -Loader neoforge
- CurseForge only:
  - powershell -ExecutionPolicy Bypass -File .\scripts\search-curseforge.ps1 -Query "journeymap" -Type mod -GameVersion 1.21.1
- GitHub source scan:
  - powershell -ExecutionPolicy Bypass -File .\scripts\search-github-source.ps1 -Query "tectonic minecraft mod"

## Environment variables
- CURSEFORGE_API_KEY: enables CurseForge API search.
- GITHUB_TOKEN: optional, increases GitHub API rate limits.

## Notes
- In environments without CURSEFORGE_API_KEY, script prints direct CurseForge search URL fallback.
- GitHub results are heuristic and should be validated against mod pages.
