#!/usr/bin/env bash
set -euo pipefail

# Branch default for external-server pull based startup.
DEFAULT_PACK_URL="https://raw.githubusercontent.com/PedroOrtRec/aaa-otl/terrain/lithosphere/pack.toml"

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

PACK_SOURCE_DIR="/home/container/datapacks"
WORLD_DATAPACKS_DIR="/home/container/${LEVEL_NAME}/datapacks"

echo "[datapacks] Syncing required terrain datapacks into ${WORLD_DATAPACKS_DIR}"
mkdir -p "$WORLD_DATAPACKS_DIR"

STILL_LIFE_SRC="$(find "$PACK_SOURCE_DIR" -maxdepth 1 -type f -name 'still-life*.jar' | head -n1 || true)"
LITHOSPHERE_SRC="$(find "$PACK_SOURCE_DIR" -maxdepth 1 -type f -name 'lithosphere*.jar' | head -n1 || true)"

if [ -z "$STILL_LIFE_SRC" ]; then
  echo "[datapacks] ERROR: still-life*.jar not found in ${PACK_SOURCE_DIR}"
  exit 1
fi

if [ -z "$LITHOSPHERE_SRC" ]; then
  echo "[datapacks] ERROR: lithosphere*.jar not found in ${PACK_SOURCE_DIR}"
  exit 1
fi

# Datapack repository only recognizes directories or .zip files.
# These packs are distributed as .jar archives, so we store them as .zip in world/datapacks.
rm -f "$WORLD_DATAPACKS_DIR"/still-life*.jar "$WORLD_DATAPACKS_DIR"/lithosphere*.jar || true

STILL_LIFE_ZIP="$WORLD_DATAPACKS_DIR/still-life.zip"
LITHOSPHERE_ZIP="$WORLD_DATAPACKS_DIR/lithosphere.zip"

cp -f "$STILL_LIFE_SRC" "$STILL_LIFE_ZIP"
cp -f "$LITHOSPHERE_SRC" "$LITHOSPHERE_ZIP"

echo "[datapacks] Installed: $(basename "$STILL_LIFE_ZIP") from $(basename "$STILL_LIFE_SRC")"
echo "[datapacks] Installed: $(basename "$LITHOSPHERE_ZIP") from $(basename "$LITHOSPHERE_SRC")"

echo "[server] Starting NeoForge server..."
UNIX_ARGS_FILE="libraries/net/neoforged/neoforge/${NEOFORGE_VERSION}/unix_args.txt"
if [ -f "$UNIX_ARGS_FILE" ]; then
  # shellcheck disable=SC2086
  exec java $JAVA_FLAGS @user_jvm_args.txt @"$UNIX_ARGS_FILE" nogui
fi

echo "[server] WARNING: $UNIX_ARGS_FILE not found, falling back to $SERVER_JAR"
# shellcheck disable=SC2086
exec java $JAVA_FLAGS -jar "$SERVER_JAR" nogui
