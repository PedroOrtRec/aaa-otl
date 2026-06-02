# Prism Manual Check - perf/bases

## Goal
Validate that the Prism instance can launch correctly with the new base performance and configuration mod set.

## Preconditions
- Branch: perf/bases
- Pack metadata refreshed (`packwiz refresh`)
- Prism instance linked to this repo (`config`, `kubejs` symlinks)
- Preflight completed successfully with `scripts/prepare-prism-check.ps1`
- Prism runtime bootstrap configured via `scripts/setup-prism-runtime.ps1`
- Prism `mods/` is a real runtime directory, not a repo symlink

## Current status
- Instance version confirmed: Minecraft 1.21.1 + NeoForge 21.1.233
- Instance launch confirmed without immediate crash
- Test world opened/created successfully
- Minimap/world map UI not confirmed in this pass
- Iris shader menu not confirmed in this pass
- spark profiler not run in this pass

## Preflight command
- powershell -ExecutionPolicy Bypass -File .\\scripts\\prepare-prism-check.ps1

## Manual verification steps
1. Open Prism Launcher.
2. Select instance: aaa-otl Desarrollo.
3. Verify instance points to Minecraft 1.21.1 + NeoForge 21.1.233.
4. Start the instance.
5. In main menu, confirm KubeJS and performance stack loads without crash.
6. Create or open a test world.
7. Confirm minimap/world map UI appears.
8. Open shader menu and validate Iris is present.
9. Run quick spark profiler command in-game if applicable.

## Result of this pass
- Steps 1-6: passed
- Step 7: not confirmed
- Step 8: not confirmed
- Step 9: not run in this pass

## Runtime model
- Repository `mods/` keeps packwiz metadata only (`*.pw.toml`).
- Prism `minecraft/mods/` is populated at launch by packwiz-installer-bootstrap.
- `config/` and `kubejs/` remain symlinked to the repo.

## Performance handoff
- Performance report generated: `reports/performance-report-20260602-213530.md`
- Prism log: no errors or warnings detected in analyzed tail
- Server log: no errors or warnings detected in analyzed tail

## Expected result
- Instance starts successfully.
- No immediate crash from dependency graph.
- Performance/configuration baseline mods are active.

## Artifacts
- Installed mod inventory: .github/.context/mod-list.md
- Pack metadata: pack.toml and mods/*.pw.toml
