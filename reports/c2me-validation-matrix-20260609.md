# C2ME Validation Matrix (NeoForge 1.21.1)

Status: proposed-and-installed-for-testing  
Scope: validate C2ME in this pack before promoting to stable branch

## Entry Under Test
- Mod: Concurrent Chunk Management Engine (NeoForge)
- Slug: c2me-neoforge
- Version: 0.3.0+alpha.0.93+1.21.1
- Channel: alpha
- Why test: improve chunk generation, loading, and I/O throughput

## Test Matrix
| ID | Scenario | Environment | Duration | Success Criteria | Fail Signals |
|---|---|---|---|---|---|
| C2ME-01 | Cold start boot | Client + dedicated server | 10 min | No startup crash; world join succeeds first attempt | Crash loop, mixin errors, registry freeze |
| C2ME-02 | Baseline worldgen play | Client SP + server MP | 20 min | Stable TPS/FPS, no recurring worldgen exceptions | Stutters with stack traces, chunk ticket spam |
| C2ME-03 | Chunky pregen stress | Dedicated server with Chunky radius run | 30-45 min | Pregen completes without fatal errors/OOM | OOM, deadlock-like stall, repeated async chunk errors |
| C2ME-04 | Mod interaction pass | With Noisium, Lithium, ModernFix, Distant Horizons present | 20 min | No incompatibility warnings escalating to errors | Conflicting threading warnings or crash on chunk operations |
| C2ME-05 | Save/load integrity | Save, stop, restart, reload same world | 10 min | World reload is clean; no corruption signs | Corrupt chunks, forced rollback, datafixer anomalies |

## Measurement Checklist
- Collect server log and latest crash reports after each scenario.
- Capture MSPT/TPS snapshots during C2ME-03 and C2ME-04.
- Compare against last known stable run without C2ME.
- Record pass/fail per scenario with short notes.

## Go/No-Go Rule
- Go to stable only if C2ME-01..05 all pass and no data integrity issue appears.
- Keep in test branch if performance is better but any reliability concern remains.
- Reject for now if any world corruption or repeatable crash appears.

## Rollback Plan
- Remove mods/c2me-neoforge.pw.toml.
- Run scripts/packwiz-refresh.ps1.
- Re-run smoke boot test to confirm baseline stability.

Generated: 2026-06-09
