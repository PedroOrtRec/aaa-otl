#!/usr/bin/env bash
set -euo pipefail

# Built-in defaults for restricted Pterodactyl eggs (no custom startup variables).
DEFAULT_PACK_URL="https://raw.githubusercontent.com/PedroOrtRec/aaa-otl/terrain/tectonic/pack.toml"

# Optional environment overrides (if panel supports them).
PACK_URL="${PACK_URL:-$DEFAULT_PACK_URL}"
BOOTSTRAP_JAR="${BOOTSTRAP_JAR:-packwiz-installer-bootstrap.jar}"
BOOTSTRAP_URL="${BOOTSTRAP_URL:-https://github.com/packwiz/packwiz-installer-bootstrap/releases/latest/download/packwiz-installer-bootstrap.jar}"
JAVA_FLAGS="${JAVA_FLAGS:--Xms512M -XX:MaxRAMPercentage=95.0}"
SERVER_JAR="${SERVER_JAR:-server.jar}"
NEOFORGE_VERSION="${NEOFORGE_VERSION:-21.1.233}"

cd /home/container

echo "[bootstrap] PACK_URL=${PACK_URL}"

if [ ! -f "$BOOTSTRAP_JAR" ]; then
  echo "[bootstrap] Missing $BOOTSTRAP_JAR, downloading..."
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$BOOTSTRAP_URL" -o "$BOOTSTRAP_JAR"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$BOOTSTRAP_JAR" "$BOOTSTRAP_URL"
  else
    echo "[bootstrap] ERROR: neither curl nor wget is available in container"
    exit 1
  fi
fi

echo "[bootstrap] Running packwiz installer bootstrap..."
java -jar "$BOOTSTRAP_JAR" -g -s server "$PACK_URL"

LEVEL_NAME=""
if [ -f "server.properties" ]; then
  LEVEL_NAME="$(sed -n 's/^level-name=//p' server.properties | tail -n1)"
fi
if [ -z "$LEVEL_NAME" ]; then
  LEVEL_NAME="world"
fi

WORLD_DATAPACKS_DIR="/home/container/${LEVEL_NAME}/datapacks"

echo "[datapacks] Ensuring datapacks directory exists at ${WORLD_DATAPACKS_DIR}"
mkdir -p "$WORLD_DATAPACKS_DIR"

# No explicit terrain datapack sync is required by default.

echo "[server] Starting NeoForge server..."
UNIX_ARGS_FILE="libraries/net/neoforged/neoforge/${NEOFORGE_VERSION}/unix_args.txt"
if [ -f "$UNIX_ARGS_FILE" ]; then
  # shellcheck disable=SC2086
  exec java $JAVA_FLAGS @user_jvm_args.txt @"$UNIX_ARGS_FILE" nogui
fi

echo "[server] WARNING: $UNIX_ARGS_FILE not found, falling back to $SERVER_JAR"
# shellcheck disable=SC2086
exec java $JAVA_FLAGS -jar "$SERVER_JAR" nogui
