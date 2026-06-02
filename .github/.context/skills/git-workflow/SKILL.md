---
name: git-workflow-aaa-otl
description: Enforces repository branch strategy and commit conventions for aaa-otl modpack development.
---

# Git Workflow Skill

## Use when
- Creating a new branch for work.
- Naming commits or PR titles.
- Deciding merge target between dev-pack and main.

## Rules
1. Stable branches:
- main: production-ready and playable pack.
- dev-pack: integration and validation branch.

2. Work branch prefixes:
- terrain/: world generation experiments only.
- perf/: optimization benchmark branches.
- feature/: gameplay, quest, and KubeJS features.
- update/: temporary packwiz bulk update branches.

3. Merge flow:
- Work branch -> dev-pack -> main.
- No direct pushes to main.

4. Commit/PR format:
- <type>(<scope>): <summary>
- Preferred types: feat, fix, chore, docs, perf, refactor, test, build, ci, revert.

## Branch examples
- terrain/tectonic-lithosphere-blend
- terrain/amplified-biomes-test
- perf/c2me-vs-vanilla-chunkloading
- feature/kubejs-recipe-unification
- feature/add-questline-chapter1
- update/mods-may-2026

## Commit examples
- feat(kubejs): add recipe unification script
- perf(mods): benchmark c2me chunk throughput
- fix(server): correct pregen startup flags
- chore(packwiz): update monthly mod batch
