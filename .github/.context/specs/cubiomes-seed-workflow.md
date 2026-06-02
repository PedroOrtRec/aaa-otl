# Cubiomes Seed Workflow Spec

## Goal
Create a repeatable seed pipeline from Cubiomes discovery to server validation and terrain branching.

## Scope
- Seed discovery: Cubiomes Viewer (GUI) in ../tools/cubiomes-viewer-win
- Candidate tracking: repo file config/worldgen/seed-candidates.csv
- Server smoke evaluation: scripts/evaluate-seeds.ps1
- Terrain branch bootstrap: scripts/new-terrain-branch.ps1

## Why this workflow
Cubiomes Viewer in the current setup does not expose a reliable CLI mode, so discovery starts in GUI.
The rest of the pipeline is scripted and versioned in the repository.

## Pipeline
1. Discover candidate seeds in Cubiomes Viewer.
2. Register candidates in config/worldgen/seed-candidates.csv.
3. Run seed batch evaluation to write per-seed report CSV.
4. Pick winner seed and create terrain branch with naming convention.
5. Continue worldgen tuning in terrain/<slug> branch.

## Candidate file format
Path: config/worldgen/seed-candidates.csv

Columns:
- seed: integer or string seed value.
- slug: short stable identifier for branch suffix.
- source: where the seed came from (cubiomes-filter name or manual note).
- biomeFocus: quick summary of target biome constraints.
- status: candidate | shortlisted | selected | rejected.
- notes: free text.

## Automated evaluation behavior
Script: scripts/evaluate-seeds.ps1

Per seed:
1. Update ../tools/server/server.properties with level-seed.
2. Call ../tools/server/run-pregen.ps1 in preparation mode.
3. Optionally boot server for smoke test and measure startup time.
4. Append result row to reports/seed-eval-<timestamp>.csv.

Output columns:
- timestamp
- seed
- slug
- source
- status
- bootSuccess
- startupSeconds
- logMarkerFound
- reportNotes

## Terrain branch bootstrap
Script: scripts/new-terrain-branch.ps1

Input:
- slug (required)
- seed (optional)

Branch naming:
- terrain/<slug>

Generated artifact:
- config/worldgen/active-seed.txt (if seed is provided)

## Commands
1. Evaluate all candidates with smoke boot:
   - powershell -ExecutionPolicy Bypass -File .\scripts\evaluate-seeds.ps1 -BootServerSmokeTest
2. Dry run without touching server runtime:
   - powershell -ExecutionPolicy Bypass -File .\scripts\evaluate-seeds.ps1 -DryRun
3. Create terrain branch:
   - powershell -ExecutionPolicy Bypass -File .\scripts\new-terrain-branch.ps1 -Slug tectonic-lithosphere-blend -Seed 123456789

## Limits
- Cubiomes discovery remains GUI-first in this setup.
- Smoke test validates boot stability, not full pregeneration radius completion.
- Full pregen completion automation requires a dedicated server-side pregen mod command contract.
