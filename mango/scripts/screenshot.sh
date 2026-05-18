#!/usr/bin/env bash
set -euo pipefail

SCREENSHOT_DIR="$HOME/Imágenes/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"
OUTPUT="$SCREENSHOT_DIR/screenshot_${TIMESTAMP}.png"

if [ "${1:-}" = "area" ]; then
  if command -v slurp >/dev/null 2>&1; then
    GEOMETRY="$(slurp)"
    [ -n "$GEOMETRY" ] || exit 0
    grim -g "$GEOMETRY" "$OUTPUT"
  else
    grim "$OUTPUT"
  fi
else
  grim "$OUTPUT"
fi

if command -v wl-copy >/dev/null 2>&1; then
  wl-copy < "$OUTPUT"
fi

if command -v notify-send >/dev/null 2>&1; then
  notify-send "Screenshot saved" "$OUTPUT"
fi
