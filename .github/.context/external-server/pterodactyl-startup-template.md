# Pterodactyl Startup Template (Foxomy)

Last updated: 2026-06-04
Target: NeoForge 1.21.1 server with packwiz pull-based bootstrap.

## Restricted panel mode (your current case)
If your panel only allows changing Server Jar File and Server Version, use this mode.

1. Keep startup command as:
  - bash -lc 'set -euo pipefail; cd /home/container; SCRIPT_URL="https://raw.githubusercontent.com/PedroOrtRec/aaa-otl/terrain/tectonic/scripts/startup-packwiz.sh"; if command -v curl >/dev/null 2>&1; then curl -fsSL "$SCRIPT_URL" -o startup-packwiz.sh; elif command -v wget >/dev/null 2>&1; then wget -qO startup-packwiz.sh "$SCRIPT_URL"; else echo "ERROR: curl/wget not available"; exit 1; fi; sed -i "s/\r$//" startup-packwiz.sh; chmod +x startup-packwiz.sh; exec bash startup-packwiz.sh'
2. Do not create extra startup variables.
3. The script already includes built-in defaults for:
  - PACK_URL -> terrain/tectonic branch
  - JAVA_FLAGS -> -Xms512M -XX:MaxRAMPercentage=95.0
  - SERVER_JAR -> server.jar
4. Leave Server Jar File as server.jar.

## 1) Server Startup Command (panel)
Use this as startup command in Pterodactyl:

```bash
bash -lc 'set -euo pipefail; cd /home/container; SCRIPT_URL="https://raw.githubusercontent.com/PedroOrtRec/aaa-otl/terrain/tectonic/scripts/startup-packwiz.sh"; if command -v curl >/dev/null 2>&1; then curl -fsSL "$SCRIPT_URL" -o startup-packwiz.sh; elif command -v wget >/dev/null 2>&1; then wget -qO startup-packwiz.sh "$SCRIPT_URL"; else echo "ERROR: curl/wget not available"; exit 1; fi; sed -i "s/\r$//" startup-packwiz.sh; chmod +x startup-packwiz.sh; exec bash startup-packwiz.sh'
```

## 2) Required startup variables
Create/update these variables in panel startup:

- PACK_URL
  - Example: https://raw.githubusercontent.com/<owner>/<repo>/<commit-or-tag>/pack.toml
  - Must point to the exact snapshot to test (default baked into script: terrain/tectonic/pack.toml).
- JAVA_FLAGS
  - Recommended: -Xms512M -XX:MaxRAMPercentage=95.0
- SERVER_JAR
  - Recommended: server.jar
- BOOTSTRAP_JAR
  - Recommended: packwiz-installer-bootstrap.jar
- BOOTSTRAP_URL
  - Example: https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest/download/packwiz-installer-bootstrap.jar

If your panel does not expose custom variables, skip this section and use Restricted panel mode.

## 3) First-time file upload
Upload this file via SFTP to /home/container:

- startup-packwiz.sh

Set executable bit in console (if needed):

```bash
chmod +x /home/container/startup-packwiz.sh
```

## 4) Validation after restart
1. Console logs show bootstrap execution before Java server start.
2. Console logs show PACK_URL from terrain/tectonic (or configured override) and successful packwiz dependency resolution.
3. Runtime starts without crash loop.
4. Mods update when PACK_URL changes to another commit or when terrain/tectonic advances.
5. Rollback works by restoring previous PACK_URL.

## 5) Rollback quick command (panel-level)
1. Stop server.
2. Set PACK_URL to last known-good snapshot.
3. Start server.
4. Confirm stable startup in logs.
