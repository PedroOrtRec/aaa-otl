# Roadmap

## Current status (2026-06-02)
- Completed: validated repository structure, Prism links, and external tools layout.
- Completed: fixed server pregen script to remove broken commands and missing launcher reference.
- Completed: added workflow automation scripts for checks, packwiz refresh, and dev server start.
- Completed: documented architecture and workflow in `.github/.context`.

## Next priorities
1. Add first curated mod list into `mods/` (jar or packwiz metadata workflow decision).
2. Decide server mod filtering policy (manual allowlist vs denylist patterns).
3. Add pregen profile options (seed, radius, dimensions) to `run-pregen.ps1`.
4. Add CI sanity checks for `pack.toml` and script linting.

## Nice to have
1. Add a script to snapshot and diff server logs for regression checks.
2. Add docs for Magallanes integration contract once dependency points are defined.
