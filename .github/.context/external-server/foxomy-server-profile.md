# External Server Profile (Confidential)

Last updated: 2026-06-04
Purpose: Reference facts for manual-Copilot-external-server workflow planning.

## Hosting facts
- Provider: Foxomy
- Plan: 16GB RAM Plan
- Disclosure: Fixed Hosting Consumer Disclosure
- Monthly price: $35
- Intro/contract note: Not an introductory rate, no contract required.

## Service specifications
- Location: Frankfurt, Germany
- CPU: Intel Core i9-14900KS
- vCores: 10 shared vCores
- Memory (RAM): 16 GB
- Storage: 320 GB soft limit (can be raised for free), fair usage applies
- Backup slots: 30 offsite backups per server
- Port allocations: 10 ports per server
- SQL databases: 10 databases per server
- Container splits: 8 splits
- Add-on: Dedicated IP Address (+$3/mo)

## Charges and terms
- Provider monthly fees: $0
- One-time setup fees: $0
- Late fees: $0
- Invoice note: Sent 2 weeks before due date. If payment is missed by more than a month, contact provider to cancel past due invoices.
- Early termination fee: $0
- Government taxes: $0
- Terms of Service: https://foxomy.com/terms
- Privacy Policy: https://foxomy.com/privacy

## Support
- Email: support@foxomy.com
- Support portal: https://foxomy.com/billing/submitticket.php?step=2&deptid=2

## Pterodactyl default filesystem on first boot
Path: /home7container/
- .cache
- libraries
- logs
- versions
- eula.txt
- server.jar
- server.properties

## Network and runtime
- Public endpoint: 45.152.160.187:25565
- Startup command: bash -lc 'set -euo pipefail; cd /home/container; SCRIPT_URL="https://raw.githubusercontent.com/PedroOrtRec/aaa-otl/terrain/tectonic/scripts/startup-packwiz.sh"; if command -v curl >/dev/null 2>&1; then curl -fsSL "$SCRIPT_URL" -o startup-packwiz.sh; elif command -v wget >/dev/null 2>&1; then wget -qO startup-packwiz.sh "$SCRIPT_URL"; else echo "ERROR: curl/wget not available"; exit 1; fi; sed -i "s/\r$//" startup-packwiz.sh; chmod +x startup-packwiz.sh; exec bash startup-packwiz.sh'
- Docker image: java 25

## Access (highly confidential)
- SFTP address: sftp://fra5.foxomy.com:2022
- Username: vsr4pair.63125061
- Password: ******

## Provider debug metadata
- Node: fra5
- Server id: 63125061-5371-483e-a5f5-fcb679ea0ff9

## Related docs
- manual-copilot-external-server-runbook.md
