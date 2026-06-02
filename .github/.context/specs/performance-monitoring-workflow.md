# Performance Monitoring Workflow Spec

## Goal
Monitor and summarize runtime health for Prism instance and pregen server logs.

## Command
- powershell -ExecutionPolicy Bypass -File .\\scripts\\monitor-instance-performance.ps1

## Inputs
- Prism instance latest.log
- Pregen server latest.log

## Output
- Markdown report in `reports/perf-monitor-<timestamp>.md`
- Extracted health indicators:
  - Can't keep up warnings
  - Exceptions/errors
  - spark references
  - Tick/TPS/MSPT signals

## Operational loop
1. Run baseline report before major mod changes.
2. Apply change.
3. Re-run report and compare key counters.
4. Use spark deep profile for unresolved hotspots.

## Related scripts
- scripts/monitor-instance-performance.ps1
- scripts/prepare-prism-check.ps1
- scripts/update-mod-list.ps1
