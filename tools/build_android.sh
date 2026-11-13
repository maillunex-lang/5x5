#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
GODOT_BIN="${GODOT_BIN:-godot}"
command -v "$GODOT_BIN" >/dev/null || { echo 'Godot binary missing' >&2; exit 127; }
"$GODOT_BIN" --headless --path . --editor --quit
"$GODOT_BIN" --headless --path . --script res://tools/godot_smoke.gd
mkdir -p build
"$GODOT_BIN" --headless --path . --export-debug Android build/eternal-legends-debug.apk
test -s build/eternal-legends-debug.apk
sha256sum build/eternal-legends-debug.apk | tee build/SHA256SUMS.txt