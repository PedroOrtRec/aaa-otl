# Dev Workflow Spec

## Objective
Provide a repeatable local loop for editing and validating the modpack with minimum manual setup.

## Preconditions
- Windows PowerShell available.
- `packwiz`, `java`, and `git` available in PATH.
- Prism instance `aaa-otl Desarrollo` exists.
- `../tools/server` exists and contains NeoForge server files.

## Commands
1. Validate links and tooling:
   - `powershell -ExecutionPolicy Bypass -File .\\scripts\\check-workflow.ps1`
2. Refresh packwiz index after metadata edits:
   - `powershell -ExecutionPolicy Bypass -File .\\scripts\\packwiz-refresh.ps1`
3. Start server dev flow:
   - `powershell -ExecutionPolicy Bypass -File .\\scripts\\start-server-dev.ps1`

## Manual mod addition flow
When adding a new mod by editing `mods/*.pw.toml` directly:
1. Refresh packwiz state.
2. Regenerate the installed mod inventory.
3. Sync the pregen server mods.
4. Launch Prism so the runtime bootstrap materializes the client mods.

Recommended commands:
- `powershell -ExecutionPolicy Bypass -File .\\scripts\\packwiz-refresh.ps1`
- `powershell -ExecutionPolicy Bypass -File .\\scripts\\update-mod-list.ps1`
- `powershell -ExecutionPolicy Bypass -File .\\scripts\\sync-server-mods.ps1`
- `powershell -ExecutionPolicy Bypass -File .\\scripts\\setup-prism-runtime.ps1` (one-time)
- `powershell -ExecutionPolicy Bypass -File .\\scripts\\prism-packwiz-bootstrap.ps1` (launch bootstrap)

## Server pregen behavior
`run-pregen.ps1` performs:
1. Optional world reset (`world/` removal).
2. Optional mod sync (`repo/mods` -> `server/mods`) with client-only denylist.
3. Optional server launch with `run.bat nogui`.

## Optional flags
- `-SkipWorldReset`
- `-SkipModSync`
- `-NoLaunch`

## Known limits
- Client-only detection is pattern based, not metadata-based.
- If repo has no jar mods, sync is skipped and existing server jars are preserved.
