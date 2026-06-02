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
