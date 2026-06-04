# Performance Baseline Report - 2026-06-05

## Scenario A - Baseline without shaders

### User-collected metrics
- FPS at rest: ~117
- FPS during 60s rotation:
  - Max: 119
  - Min: 102
- Stutters: none observed
- JVM memory view (F3): variable between 20% and 80% of 8064 MB

### spark health snapshot
- TPS:
  - 1m: 20.00
  - 5m: 17.07
  - 15m: 16.76
- MSPT:
  - min: 6.43
  - median: 13.4
  - 95%ile: 43.8
  - max: 301
- CPU:
  - Process 1m: 69.69%
  - Process 15m: 65.1%
  - System 1m: 78.75%
  - System 15m: 74.72%
- Memory:
  - Process: 5.5 GB / 7.9 GB (69.52%)
  - Physical: 14.6 GB / 15.2 GB (95.96%)
  - Swap: 34.4 GB / 35.6 GB (96.81%)
- GC (ZGC):
  - Minor cycles: 84 total, 476 ms avg time, 7.6 s avg frequency
  - Minor pauses: 252 total, 0.06 ms avg time, 2.7 s avg frequency
  - Major cycles: 11 total, 1880 ms avg time, 59.6 s avg frequency
  - Major pauses: 57 total, 0.02 ms avg time, 11.9 s avg frequency

### Environment snapshot (from spark)
- Platform: NeoForge server 21.1.233 (Minecraft 1.21.1)
- Mode: online mode
- Players during profile: 1
- OS: Windows 11 amd64
- CPU threads available: 12
- Java runtime: 21.0.7 (Microsoft)
- JVM: OpenJDK 64-Bit Server VM
- Process uptime at capture: 11m 17s
- Profiling duration: 2m 13s (2635 ticks)

### Initial assessment
- Client rendering baseline is good: stable 102-119 FPS, no visible stutter.
- Server-side simulation is mostly healthy for this pass:
  - Median MSPT is strong at 13.4.
  - 95%ile MSPT at 43.8 is still under the 50 ms risk threshold.
- There are occasional heavy spikes (MSPT max 301), likely from chunk updates, background loading, or memory pressure.
- System RAM and swap are critically saturated; this is the main risk to measurement quality and can cause hidden spikes independent of mod configs.

### Actions before Scenario B
1. Close background applications to free RAM aggressively (target physical memory below 85%).
2. Keep same world and route to maintain comparability.
3. Start Scenario B with Photon shader and shadow distance sweep 16 -> 24 -> 32.

### Missing artifact
- spark profiler URL was not provided for Scenario A.

---

## Handoff - Scenario B (next session)

### Goal
Measure Photon shader impact and choose the best shadow distance for stable frame time.

### Preconditions
1. Keep same world and test route used in Scenario A.
2. Close heavy background applications to reduce system memory pressure.
3. Confirm shader pack is Photon (`photon_v1.3b.zip`).

### Runbook
1. Set shadow distance to 16 and run a 60s pass:
  - Record FPS min, max, avg.
  - Record visual notes (stutter, shimmer, ghosting).
2. Set shadow distance to 24 and repeat 60s pass.
3. Set shadow distance to 32 and repeat 60s pass.
4. Choose best shadow distance (best stability and acceptable visual quality).
5. Run spark profile on chosen value:
  - `/spark profiler start`
  - Move through the same route for 2 minutes
  - `/spark profiler stop`
  - `/spark health`

### Data to paste in next chat session
1. Shadow 16: FPS min/max/avg + notes
2. Shadow 24: FPS min/max/avg + notes
3. Shadow 32: FPS min/max/avg + notes
4. Selected shadow value and rationale
5. Full `/spark health` output
6. `/spark profiler stop` URL
