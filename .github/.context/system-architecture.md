# System Architecture

## Overview
This repository is the source of truth for shared modpack state:
- packwiz metadata (`pack.toml`, `index.toml`)
- runtime assets (`mods`, `config`, `kubejs`)

Prism client instance and the local NeoForge server consume this state through symlinks and sync scripts.

## Components
- Repository (`aaa-otl`): authoring and version control.
- Prism Launcher instance (`aaa-otl Desarrollo`): local client runtime.
- Server runtime (`../tools/server`): local integration and pregen testing.
- Cubiomes viewer (`../tools/cubiomes-viewer-win`): seed and world research support.

## Link topology
- Prism instance links three directories to this repository:
	- `minecraft/config` -> `aaa-otl/config`
	- `minecraft/kubejs` -> `aaa-otl/kubejs`
- Server links two directories to this repository:
	- `server/config` -> `aaa-otl/config`
	- `server/kubejs` -> `aaa-otl/kubejs`

Prism `minecraft/mods` is a real runtime folder populated at launch by packwiz-installer-bootstrap.
Repository `mods/` contains packwiz source metadata only.
Server mods are synchronized from `aaa-otl/mods` into `../tools/server/mods` by script.

## Development flow
1. Edit configs/scripts/mod files in this repository.
2. Prism sees changes immediately through symlinks.
3. Server flow script resets world (optional), syncs mods, and runs NeoForge headless.
4. packwiz refresh keeps index/hash state consistent.

## Risk notes
- Client-only mods can crash dedicated server startup.
- Script denylist filters common client-only jars, but this is heuristic.
- If `mods/` only contains `.pw.toml` files and no jars, server sync intentionally does not delete current jars and warns.
