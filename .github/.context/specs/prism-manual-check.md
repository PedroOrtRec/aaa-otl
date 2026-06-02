# Prism Manual Check - perf/bases

## Goal
Validate that the Prism instance can launch correctly with the new base performance and configuration mod set.

## Preconditions
- Branch: perf/bases
- Pack metadata refreshed (`packwiz refresh`)
- Prism instance linked to this repo (`mods`, `config`, `kubejs` symlinks)

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

## Expected result
- Instance starts successfully.
- No immediate crash from dependency graph.
- Performance/configuration baseline mods are active.

## Artifacts
- Installed mod inventory: .github/.context/mod-list.md
- Pack metadata: pack.toml and mods/*.pw.toml
