# Content Discovery Workflow Spec

## Goal
Provide fast and repeatable discovery of mods, datapacks, resourcepacks, and shaders across Modrinth, CurseForge, and GitHub source.

## Inputs
- Query text
- Content type: mod | datapack | resourcepack | shader
- Minecraft version (default 1.21.1)
- Loader (default neoforge)

## Workflow
1. Run unified search script to aggregate metadata.
2. Compare compatibility signals:
   - supported versions
   - loader/category tags
   - client/server side constraints
3. Check source link from platform metadata.
4. Run GitHub source search if source URL is missing or uncertain.
5. Document shortlist into decision notes or branch description.

## Output quality checks
- At least one platform result with version compatibility evidence.
- If possible, source repository identified and reachable.
- Conflicting compatibility claims flagged for manual validation.

## Commands
- Unified:
  - powershell -ExecutionPolicy Bypass -File .\scripts\search-content.ps1 -Query "<term>" -Type mod -GameVersion 1.21.1 -Loader neoforge
- Modrinth:
  - powershell -ExecutionPolicy Bypass -File .\scripts\search-modrinth.ps1 -Query "<term>" -Type mod -GameVersion 1.21.1 -Loader neoforge
- CurseForge:
  - powershell -ExecutionPolicy Bypass -File .\scripts\search-curseforge.ps1 -Query "<term>" -Type mod -GameVersion 1.21.1
- GitHub:
  - powershell -ExecutionPolicy Bypass -File .\scripts\search-github-source.ps1 -Query "<term> minecraft"

## Security and limits
- CurseForge API requires CURSEFORGE_API_KEY.
- GitHub unauthenticated calls are rate-limited.
- CurseForge fallback may require manual browser review when API key is absent.
