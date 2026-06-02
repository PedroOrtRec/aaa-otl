# Server Allowlist and Pregen Profiles Spec

## Goal
Replace heuristic server/client mod filtering with a deterministic allowlist, and define reusable pregen profiles (seed/radius/dimensions).

## Scope
- Repository: aaa-otl
- Runtime target: NeoForge dedicated server in ../tools/server
- Script target: ../tools/server/run-pregen.ps1

## Problem statement
Current mod sync in run-pregen.ps1 uses jar-name heuristics to skip common client-only mods.
This can fail with false positives/false negatives and is not production-grade.

## Proposed solution
1. Add explicit server allowlist file in repository.
2. Sync only jars explicitly listed in allowlist.
3. Add pregen profiles file with named presets.
4. Extend run-pregen.ps1 to load profile and launch server with profile parameters.

## New files
1. config/mod-sync/server-allowlist.txt
2. config/pregen/profiles.json

## File formats
### server-allowlist.txt
Plain text, one jar filename per line.
Rules:
- Exact jar filename match.
- Empty lines allowed.
- Lines starting with # are comments.

Example:
# Core
kubejs-neoforge-2101.7.1-build.181.jar
architectury-13.0.8-neoforge.jar

# Worldgen
tectonic-2.4.1-neoforge.jar
lithosphere-1.4.0-neoforge.jar

### profiles.json
JSON object with named profiles.

Example:
{
  "default": {
    "seed": "123456789",
    "radiusChunks": 2000,
    "dimensions": ["minecraft:overworld"]
  },
  "terrain-test": {
    "seed": "-987654321",
    "radiusChunks": 3000,
    "dimensions": [
      "minecraft:overworld",
      "minecraft:the_nether"
    ]
  }
}

## Script behavior changes
### run-pregen.ps1
Add parameters:
- -AllowlistPath (default: repo config/mod-sync/server-allowlist.txt)
- -PregenProfile (default: default)
- -ProfilesPath (default: repo config/pregen/profiles.json)

Sync rules:
1. Read allowlist file.
2. Remove all jar files from server mods directory.
3. Copy only allowed jars found in repo mods directory.
4. Fail if allowlisted jar is missing in repo mods directory.

Pregen rules:
1. Read selected profile from profiles.json.
2. Validate seed, radiusChunks, and dimensions.
3. Inject args to server launch command (or pregen mod command wrapper if configured).

## Validation and safety
- Hard fail if allowlist file is missing.
- Hard fail if profile file is missing or profile key does not exist.
- Hard fail if allowlist references unknown jars.
- Dry-run mode prints planned copy set and pregen arguments.

## Acceptance criteria
1. Same input set always produces same server mods set.
2. No heuristic filtering remains in deterministic mode.
3. Profile selection is reproducible by name.
4. Script exits with non-zero code on config errors.
5. Workflow remains one-command from repo scripts layer.

## Rollout plan
1. Create allowlist and profile files with initial values.
2. Implement deterministic mode in run-pregen.ps1.
3. Keep legacy heuristic mode behind optional -HeuristicFallback switch for one transition cycle.
4. Remove fallback after migration is validated.
