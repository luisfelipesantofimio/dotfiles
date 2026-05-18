#!/usr/bin/env bash
set -euo pipefail

json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="${s//$'\n'/\\n}"
  s="${s//$'\r'/\\r}"
  s="${s//$'\t'/\\t}"
  printf '%s' "$s"
}

emit_empty() {
  printf '{"text":"","tooltip":"","alt":"","class":"","icon":""}\n'
}

if [ $# -gt 0 ]; then
  if ! command -v playerctl >/dev/null 2>&1; then
    exit 0
  fi
  player=$(playerctl -l 2>/dev/null | head -n 1)
  [ -n "$player" ] || exit 0
  exec playerctl -p "$player" "$@"
fi

if ! command -v playerctl >/dev/null 2>&1; then
  emit_empty
  exit 0
fi

player=$(playerctl -l 2>/dev/null | head -n 1)
if [ -z "$player" ]; then
  emit_empty
  exit 0
fi

status=$(playerctl -p "$player" status 2>/dev/null || true)
if [ -z "$status" ] || [ "$status" = "Stopped" ]; then
  emit_empty
  exit 0
fi

title=$(playerctl -p "$player" metadata title 2>/dev/null || true)
artist=$(playerctl -p "$player" metadata artist 2>/dev/null || true)

if [ -z "$title" ] && [ -z "$artist" ]; then
  emit_empty
  exit 0
fi

text=""
if [ -n "$title" ] && [ -n "$artist" ]; then
  text="$artist — $title"
elif [ -n "$title" ]; then
  text="$title"
else
  text="$artist"
fi

case "$status" in
  Playing) icon="" ;;
  Paused) icon="" ;;
  *) icon="" ;;
esac

printf '{"text":"%s","tooltip":"%s","alt":"%s","class":"%s","icon":"%s"}\n' \
  "$(json_escape "$text")" \
  "$(json_escape "$text")" \
  "$(json_escape "$status")" \
  "$(json_escape "$status")" \
  "$(json_escape "$icon")"
