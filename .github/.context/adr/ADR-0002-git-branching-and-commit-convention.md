# ADR-0002: Git branching and commit convention

## Status
Accepted - 2026-06-02

## Context
The repository needs a predictable collaboration model for parallel modpack workstreams:
- stable release management
- integration validation before production
- isolated experiment tracks for worldgen, performance, gameplay, and bulk updates

Without explicit branch and commit rules, changes can mix concerns and increase regression risk.

## Decision
Adopt the following branch strategy and commit naming convention.

### Stable branches
- main: stable pack ready to play and ready for production server deployment.
- dev-pack: integration and testing branch for validated merges.

### Work branch prefixes
- terrain/: world generation experiments only.
  - Example: terrain/tectonic-lithosphere-blend
  - Example: terrain/amplified-biomes-test
- perf/: FPS or TPS benchmark branches for optimization comparisons.
  - Example: perf/c2me-vs-vanilla-chunkloading
- feature/: gameplay mechanics, quests, and KubeJS systems.
  - Example: feature/kubejs-recipe-unification
  - Example: feature/add-questline-chapter1
- update/: temporary branches for packwiz-driven bulk jar updates.
  - Example: update/mods-may-2026

### Merge flow
1. Work branch merges into dev-pack.
2. dev-pack is validated.
3. dev-pack is promoted into main.
4. No direct pushes/commits to main.

### Commit and PR title format
- Format: <type>(<scope>): <summary>
- Commit type follows Conventional Commits style, in English.
- Recommended types: feat, fix, chore, docs, perf, refactor, test, build, ci, revert.
- Scope should map to subsystem when possible: kubejs, config, mods, packwiz, server.

## Consequences
Pros:
- Clear separation between stable, integration, and experiment work.
- Easier review by intent (terrain/perf/feature/update).
- Better traceability from branch name to release risk profile.

Cons:
- Requires discipline to keep branch naming and merge order consistent.
- update/ branches can accumulate noise if not deleted after merge.

## Follow-up
- Keep branch and commit examples aligned in `.github/.context/specs/git-branch-and-commit-convention.md`.
- Keep agent guidance aligned in `.github/.context/skills/git-workflow/SKILL.md`.
