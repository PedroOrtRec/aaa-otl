# Manual-Copilot-External Server Runbook (Foxomy/Pterodactyl)

Last updated: 2026-06-04
Scope: aaa-otl, Minecraft 1.21.1 + NeoForge, external server in Pterodactyl.

## Goal
Define a safe and reproducible workflow where:
- Repository metadata (mods/*.pw.toml) is the single source of truth.
- Copilot validates changes and risks before deployment.
- External server pulls pack state from packwiz and runs pregen tests.

## Core operating rules
1. Never treat server filesystem as source of truth.
2. Never edit runtime mods manually for long-term changes.
3. Promote only committed pack snapshots.
4. Use rollback by switching to previous snapshot URL.

## Roles
- Manual operator:
  - Adds/updates mods in repository.
  - Triggers deployment in Pterodactyl.
  - Runs and monitors pregen tests.
- Copilot:
  - Reviews side/client-server compatibility.
  - Reviews dependency and conflict risk.
  - Generates checklists, runbooks, and incident notes.
- External server:
  - Executes runtime with pulled artifacts.
  - Produces logs and performance evidence.

## Baseline from existing local workflow
Reference specs:
- .github/.context/specs/manual-mod-addition-and-sync.md
- .github/.context/specs/dev-workflow.md

Local command sequence remains valid before any external promotion:
1. powershell -ExecutionPolicy Bypass -File .\scripts\packwiz-refresh.ps1
2. powershell -ExecutionPolicy Bypass -File .\scripts\update-mod-list.ps1

Note:
- Local script .\scripts\sync-server-mods.ps1 is designed for local server tooling and should not be treated as the primary external deployment strategy.

## External deployment model (recommended)
Use pull-based deployment on Pterodactyl:
1. Publish repository pack snapshot to a reachable PACK_URL (default branch flow: terrain/tectonic).
2. Server bootstrap resolves and downloads the server mod list from PACK_URL.
3. Start NeoForge runtime after bootstrap.

### Why this model
- Reproducibility: each test uses a defined snapshot.
- Fast rollback: swap PACK_URL to previous known-good snapshot.
- Reduced drift: avoids manual jar management in panel/SFTP.

## Required panel variables
Define these in startup environment or equivalent panel fields:
- PACK_URL: public URL to pack.toml of the selected snapshot.
- JAVA_MAIN_JAR: runtime server jar to launch after bootstrap (for example server.jar).
- JAVA_FLAGS: JVM flags for runtime.

Suggested defaults:
- JAVA_FLAGS: -Xms512M -XX:MaxRAMPercentage=95.0
- JAVA_MAIN_JAR: server.jar

## Startup strategy
Because the container currently starts with:
- java -Xms128M -XX:MaxRAMPercentage=95.0 -jar server.jar

Move to a two-step startup command:
1. Download/update startup-packwiz.sh from terrain/tectonic.
2. Bootstrap/update pack from PACK_URL (defaulting to terrain/tectonic/pack.toml inside script).
3. Start server runtime.

Recommended startup command (Pterodactyl):
- bash -lc 'set -euo pipefail; cd /home/container; SCRIPT_URL="https://raw.githubusercontent.com/PedroOrtRec/aaa-otl/terrain/tectonic/scripts/startup-packwiz.sh"; if command -v curl >/dev/null 2>&1; then curl -fsSL "$SCRIPT_URL" -o startup-packwiz.sh; elif command -v wget >/dev/null 2>&1; then wget -qO startup-packwiz.sh "$SCRIPT_URL"; else echo "ERROR: curl/wget not available"; exit 1; fi; sed -i "s/\r$//" startup-packwiz.sh; chmod +x startup-packwiz.sh; exec bash startup-packwiz.sh'

If your egg cannot chain commands directly, wrap with a startup script in the server root and set startup command to that script.

## Daily operating loop
1. Modify mods metadata in repository.
2. Run refresh and inventory update locally:
   - powershell -ExecutionPolicy Bypass -File .\scripts\packwiz-refresh.ps1
   - powershell -ExecutionPolicy Bypass -File .\scripts\update-mod-list.ps1
3. Commit and push snapshot.
4. Set PACK_URL in Pterodactyl to snapshot target.
5. Restart server.
6. Validate startup logs and mod load success.
7. Run pregen workload.
8. Capture findings in reports.

## Pre-deploy Copilot review checklist
1. Every new mod has side correctly declared in mods/*.pw.toml.
2. No client-only mod is required by server runtime path.
3. Dependency chain is complete and version-compatible.
4. No conflicting worldgen core mods are enabled simultaneously without explicit test plan.
5. Rollback target snapshot is identified before deploy.

## Deploy checklist (manual)
1. Snapshot URL points to intended commit/tag.
2. Pterodactyl startup variables are set.
3. Backup slot available before high-risk changes.
4. Server restart performed from clean state.
5. Server reaches playable state without crash loop.
6. Console shows expected mod loading summary.

## Pregen test checklist
1. World seed and settings recorded.
2. Radius/target objective recorded.
3. Start time logged.
4. TPS and memory trend sampled periodically.
5. Completion status captured.
6. Critical warnings/errors copied to report.

## Rollback playbook
Trigger conditions:
- Crash loop on startup.
- Severe TPS degradation sustained beyond acceptable threshold.
- World corruption indicators.

Steps:
1. Stop server.
2. Set PACK_URL to last known-good snapshot.
3. Restart server and verify stable boot.
4. If needed, restore backup slot.
5. Open incident note with:
   - broken snapshot
   - rollback snapshot
   - first failing log evidence
   - suspected mod/mod set

## Incident logging template
- Date/time (UTC/local):
- Environment: Foxomy fra5, server id
- Snapshot URL:
- Seed/world details:
- Symptom:
- First error in logs:
- Rollback performed (yes/no):
- Next action:

## Security notes
1. Keep credentials only in ignored files under .github/.context/external-server.
2. Rotate credentials immediately after accidental exposure.
3. Avoid copying secrets into commit messages, reports, or public issues.

## Files in this confidential folder
- foxomy-server-profile.md: provider and access details.
- manual-copilot-external-server-runbook.md: this operational guide.
- pterodactyl-startup-template.md: exact panel startup command and variables.
- startup-packwiz.sh: uploadable startup script for /home/container.
