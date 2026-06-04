# Manual Mod Addition and Sync Workflow

## Goal
Document the manual flow for adding a new mod to the pack and propagating it to the mod inventory, the pregen server, and Prism Launcher.

## Scope
- Repository: `aaa-otl`
- Runtime target: Minecraft 1.21.1 + NeoForge
- Pack format: packwiz metadata in `mods/*.pw.toml`

## Working rule
- Treat `mods/` as the source of truth for packwiz metadata.
- Do not edit Prism `minecraft/mods` by hand; it is a runtime folder populated at launch.
- Server mods are synchronized separately from repository metadata.

## Manual add flow
1. Add the mod with packwiz, using the source that matches the project:
   - Modrinth: `packwiz modrinth add [URL|slug|search]`
   - CurseForge: `packwiz curseforge add [URL|slug|search]`
   - GitHub releases: `packwiz github add [URL|slug]`
   - Direct download: `packwiz url add [name] [url]`
   - Use `-y` when you want packwiz to accept the default prompt choices non-interactively.
2. Confirm the new or updated metadata in `mods/<mod>.pw.toml`.
3. Refresh packwiz state:
   - `powershell -ExecutionPolicy Bypass -File .\\scripts\\packwiz-refresh.ps1`
4. Regenerate the installed mod inventory used by the docs and reviews:
   - `powershell -ExecutionPolicy Bypass -File .\\scripts\\update-mod-list.ps1`
5. Sync the pregen server mods from repository metadata:
   - `powershell -ExecutionPolicy Bypass -File .\\scripts\\sync-server-mods.ps1`
6. Launch Prism Launcher or run the Prism preflight if you want to verify the runtime immediately:
   - One-time setup, if needed: `powershell -ExecutionPolicy Bypass -File .\\scripts\\setup-prism-runtime.ps1`
   - Launch-time bootstrap: `powershell -ExecutionPolicy Bypass -File .\\scripts\\prism-packwiz-bootstrap.ps1`

## What each step updates
- `packwiz-refresh.ps1`: keeps the pack metadata and index/hash state consistent.
- `update-mod-list.ps1`: regenerates `.github/.context/mod-list.md` from `mods/*.pw.toml`.
- `sync-server-mods.ps1`: updates the local pregen server `mods` folder from the repository metadata.
- `setup-prism-runtime.ps1`: configures the Prism instance once so it uses a real runtime `mods` folder and the prelaunch bootstrap.
- `prism-packwiz-bootstrap.ps1`: materializes Prism runtime mods on launch from the current repo pack state.

## Result
- Repository metadata is updated once.
- Prism picks up the new mod on launch.
- The pregen server receives the synced mod set.
- The mod inventory stays current for review and documentation workflows.
