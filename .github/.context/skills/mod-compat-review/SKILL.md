---
name: mod-compat-review-aaa-otl
description: Evaluates compatibility and suitability before adding a new mod to the current Minecraft 1.21.1 NeoForge stack.
---

# Mod Compatibility Review Skill

## Use when
- User asks whether a mod is safe or suitable to add.
- Reviewing side compatibility (client/server) for current pack.
- Checking required dependencies against installed mods.

## Primary data sources
1. Current installed mod metadata in mods/*.pw.toml.
2. Modrinth project + compatible version metadata.
3. Existing context docs and mod-list inventory.

## Command
- powershell -ExecutionPolicy Bypass -File .\scripts\review-mod-candidate.ps1 -Query "<mod name or slug>"

## Output
- Markdown report in reports/mod-review-*.md containing:
  - compatibility verdict
  - dependency gap analysis
  - client/server risk signal
  - quick recommendation summary

## Decision hints
- already-installed: do not re-add.
- client-only-risk: avoid for dedicated server baseline unless explicitly client profile.
- needs-dependencies: install missing deps first.
- good: candidate is suitable for controlled integration testing.
