# ADR-0001: Symlink-first dev workflow topology

## Status
Accepted - 2026-06-02

## Context
The project needs a low-friction local workflow for Minecraft 1.21.1 NeoForge development using:
- packwiz in repository
- Prism Launcher for client testing
- local dedicated server under ../tools/server

Existing links already connect Prism and server config/kubejs to repository folders.

## Decision
Use repository folders as source of truth and keep a symlink-first topology:
- Prism reads `mods`, `config`, `kubejs` from repository via symlink.
- Server reads `config` and `kubejs` from repository via symlink.
- Server `mods` is synchronized from repository `mods` through script before launch.

## Consequences
Pros:
- One edit location for config and kubejs.
- Fast iteration in Prism and server.
- Repeatable server startup flow.

Cons:
- Server mod sync uses heuristic client-only filtering.
- If repository mods contains only metadata (`.pw.toml`), jars are not materialized automatically.

## Follow-up
- Define an optional explicit server allowlist file for deterministic filtering.
- Optionally add packwiz-installer based materialization flow if metadata-only mod management is preferred.
