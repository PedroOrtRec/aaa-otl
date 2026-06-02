# Git Branch and Commit Convention

## Stable branches
- main: stable pack ready to play and deploy to production server.
- dev-pack: integration/testing branch for stable configuration merges.

## Working branch prefixes
- terrain/: world generation experiments only.
  - Example: terrain/tectonic-lithosphere-blend
  - Example: terrain/amplified-biomes-test
- perf/: FPS or TPS benchmark branches for optimization mod comparisons.
  - Example: perf/c2me-vs-vanilla-chunkloading
- feature/: new gameplay mechanics, quests, or KubeJS systems.
  - Example: feature/kubejs-recipe-unification
  - Example: feature/add-questline-chapter1
- update/: temporary bulk update branches generated for packwiz-driven jar updates.
  - Example: update/mods-may-2026

## Merge policy
1. Never commit directly to main.
2. Merge into dev-pack first, validate, then promote to main.
3. Keep update/ branches short-lived and delete after merge.

## Commit convention
Use:
<type>(<scope>): <summary>

Allowed types:
- feat
- fix
- chore
- docs
- perf
- refactor
- test
- build
- ci
- revert

Scope guidance:
- Prefer scope to match folder or subsystem: kubejs, config, mods, packwiz, server.

Examples:
- terrain(worldgen): test tectonic+lithosphere blend profile
- perf(mods): compare c2me vs vanilla chunk loading
- feature(kubejs): add chapter1 quest unlock chain
- update(packwiz): refresh mods for may 2026 batch
- fix(server): correct run-pregen deterministic sync validation

## PR title convention
Mirror commit convention:
<type>(<scope>): <summary>
