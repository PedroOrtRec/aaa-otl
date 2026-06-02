---
name: performance-monitoring-aaa-otl
description: Reads Prism and pregen server logs to produce performance snapshots using spark/TPS/MSPT signals.
---

# Performance Monitoring Skill

## Use when
- User asks for instance performance health.
- Comparing perf branches after mod changes.
- Inspecting Prism or pregen server runtime stability.

## Data sources
- Prism log: %AppData%/PrismLauncher/instances/aaa-otl Desarrollo/minecraft/logs/latest.log
- Server log: ../tools/server/logs/latest.log
- spark markers and TPS/MSPT traces in logs

## Command
- powershell -ExecutionPolicy Bypass -File .\scripts\monitor-performance.ps1 -Source both

## Output
- Markdown report in reports/performance-report-*.md with:
  - warnings/errors counts
  - spark/TPS/MSPT mentions
  - extracted TPS and MSPT stats
  - evidence tail for quick diagnosis

## Recommended workflow
1. Run baseline capture before mod changes.
2. Run same capture after changes.
3. Compare reports for regressions (MSPT up, TPS down, errors increase).
4. If regression appears, profile with spark and rollback candidate mods.
