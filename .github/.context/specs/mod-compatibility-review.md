# Mod Compatibility Review Spec

## Goal
Provide a repeatable decision process to evaluate whether a new mod should be added to the pack.

## Inputs
- Mod query/name
- Target runtime: Minecraft 1.21.1 + NeoForge
- Current installed stack from `.github/.context/mod-list.md`

## Command
- powershell -ExecutionPolicy Bypass -File .\\scripts\\review-mod-candidate.ps1 -Query "<mod-name>"

## Decision rubric
1. Version support for 1.21.1.
2. NeoForge support signal.
3. Client/server compatibility.
4. Functional overlap with existing stack.
5. Source availability and project activity.

## Output
- Candidate summary
- Compatibility score
- Recommendation: Recommended | Review Manually | Risky
- Notes for manual checks

## Post-decision
- If accepted, install with packwiz and run:
  - scripts/update-mod-list.ps1
  - scripts/prepare-prism-check.ps1
