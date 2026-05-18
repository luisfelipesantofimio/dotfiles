#!/usr/bin/env bash

set -euo pipefail

if ! command -v wlr-randr >/dev/null 2>&1; then
    echo "wlr-randr not found" >&2
    exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "jq not found" >&2
    exit 1
fi

json=$(wlr-randr --json)
internal_name="eDP-1"
internal=$(jq -r --arg name "$internal_name" '.[] | select(.name == $name and .enabled == true) | .name' <<<"$json")
if [ -z "$internal" ]; then
    internal=$(jq -r '.[] | select(.enabled == true and (.name | test("eDP|LVDS|DFP|DSI"))) | .name' <<<"$json" | head -n1)
fi

if [ -z "$internal" ]; then
    echo "No internal display detected." >&2
    exit 1
fi

external=$(jq -r --arg internal "$internal" '.[] | select(.name != $internal and .enabled == true) | .name' <<<"$json" | head -n1)
if [ -z "$external" ]; then
    echo "No external display connected." >&2
    exit 1
fi

internal_mode=$(jq -r --arg name "$internal" '.[] | select(.name == $name) | "\(.current_mode.width)x\(.current_mode.height)"' <<<"$json")
external_mode=$(jq -r --arg name "$external" '.[] | select(.name == $name) | "\(.current_mode.width)x\(.current_mode.height)"' <<<"$json")

readarray -t internal_modes < <(jq -r --arg name "$internal" '.[] | select(.name == $name) | .modes[] | "\(.width)x\(.height)"' <<<"$json" | sort -u)
readarray -t external_modes < <(jq -r --arg name "$external" '.[] | select(.name == $name) | .modes[] | "\(.width)x\(.height)"' <<<"$json" | sort -u)

common_mode=$(printf '%s\n' "${internal_modes[@]}" "${external_modes[@]}" | sort | uniq -d | sort -t x -k1,1n -k2,2n | tail -n1)
if [ -z "$common_mode" ]; then
    echo "No common mode found between $internal and $external." >&2
    exit 1
fi

mirror_mode="$common_mode"

wlr-randr --output "$internal" --mode "$mirror_mode" --pos 0x0 --primary \
          --output "$external" --mode "$mirror_mode" --pos 0x0
