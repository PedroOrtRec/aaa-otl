# Context Map - aaa-otl

## Project purpose
- Modpack repository for An Awesome Adventure: Ode To Leonor.
- Target stack: Minecraft 1.21.1 + NeoForge 21.1.233 + packwiz.
- Magallanes is an external core dependency managed in another repository.

## Workspace map
- `pack.toml`: main packwiz metadata.
- `index.toml`: packwiz index and hash manifest.
- `mods/`: packwiz source metadata files.
- `config/`: shared config linked into Prism instance and server.
- `kubejs/`: shared scripts/data linked into Prism instance and server.
- `.github/.context/`: living docs for architecture, roadmap, ADRs, and specs.
- `scripts/`: local automation entrypoints for daily workflow.

## External topology
- Prism instance: `%AppData%/PrismLauncher/instances/aaa-otl Desarrollo/minecraft`
- Server tools: `../tools/server`
- Cubiomes viewer: `../tools/cubiomes-viewer-win/cubiomes-viewer.exe`

## Verified links
- Prism `config` -> repo `config`
- Prism `kubejs` -> repo `kubejs`
- Server `config` -> repo `config`
- Server `kubejs` -> repo `kubejs`
- Prism `mods` runtime folder is managed by packwiz-installer-bootstrap

## Daily commands
- Check environment and links:
	- `powershell -ExecutionPolicy Bypass -File .\scripts\check-workflow.ps1`
- Refresh packwiz index:
	- `powershell -ExecutionPolicy Bypass -File .\scripts\packwiz-refresh.ps1`
- Start dev server flow (reset world + sync mods + launch):
	- `powershell -ExecutionPolicy Bypass -File .\scripts\start-server-dev.ps1`
- Evaluate Cubiomes seed candidates and generate report:
	- `powershell -ExecutionPolicy Bypass -File .\scripts\evaluate-seeds.ps1 -DryRun`
- Create terrain branch from selected seed:
	- `powershell -ExecutionPolicy Bypass -File .\scripts\new-terrain-branch.ps1 -Slug <name> -Seed <seed>`
- Search mods/datapacks/resourcepacks/shaders (Modrinth + CurseForge + GitHub):
	- `powershell -ExecutionPolicy Bypass -File .\scripts\search-content.ps1 -Query <term> -Type mod -GameVersion 1.21.1 -Loader neoforge`
- Prepare Prism manual validation preflight:
	- `powershell -ExecutionPolicy Bypass -File .\scripts\prepare-prism-check.ps1`
- Setup Prism runtime bootstrap and real mods folder:
	- `powershell -ExecutionPolicy Bypass -File .\scripts\setup-prism-runtime.ps1`
- Regenerate installed mod inventory:
	- `powershell -ExecutionPolicy Bypass -File .\scripts\update-mod-list.ps1`
- Review compatibility of a new mod candidate:
	- `powershell -ExecutionPolicy Bypass -File .\scripts\review-mod-candidate.ps1 -Query <mod>`
- Generate Prism/server performance report:
	- `powershell -ExecutionPolicy Bypass -File .\scripts\monitor-performance.ps1 -Source both`

## Context docs
- Architecture: `.github/.context/system-architecture.md`
- Roadmap: `.github/.context/roadmap.md`
- Workflow spec: `.github/.context/specs/dev-workflow.md`
- Server allowlist/pregen spec: `.github/.context/specs/server-allowlist-pregen-profiles.md`
- Cubiomes seed workflow spec: `.github/.context/specs/cubiomes-seed-workflow.md`
- Content discovery spec: `.github/.context/specs/content-discovery-workflow.md`
- Prism check spec: `.github/.context/specs/prism-manual-check.md`
- Prism runtime bootstrap script: `scripts/setup-prism-runtime.ps1`
- Prism prelaunch bootstrap script: `scripts/prism-packwiz-bootstrap.ps1`
- Installed mods inventory: `.github/.context/mod-list.md`
- Mod compatibility review spec: `.github/.context/specs/mod-compatibility-review.md`
- Performance monitoring spec: `.github/.context/specs/performance-monitoring-workflow.md`
- Git convention spec: `.github/.context/specs/git-branch-and-commit-convention.md`
- Git workflow skill: `.github/.context/skills/git-workflow/SKILL.md`
- Content discovery skill: `.github/.context/skills/content-discovery/SKILL.md`
- Mod compatibility review skill: `.github/.context/skills/mod-compat-review/SKILL.md`
- Performance monitoring skill: `.github/.context/skills/performance-monitoring/SKILL.md`
- ADR: `.github/.context/adr/ADR-0001-dev-workflow-topology.md`
- ADR: `.github/.context/adr/ADR-0002-git-branching-and-commit-convention.md`

## Conversation notes (2026-06-02)
- `.github/.context` existed but was empty.
- `run-pregen.ps1` used invalid command (`packwiz jmra export`) and referenced missing `run.ps1`.
- Script was fixed to use robust local sync + `run.bat nogui`.
- Workflow scripts were added to remove manual steps.
