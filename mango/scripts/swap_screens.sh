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
internal_width=$(jq -r --arg name "$internal" '.[] | select(.name == $name) | .current_mode.width' <<<"$json")
external_width=$(jq -r --arg name "$external" '.[] | select(.name == $name) | .current_mode.width' <<<"$json")

external_x=$(jq -r --arg name "$external" '.[] | select(.name == $name) | .x // 0' <<<"$json")
external_y=$(jq -r --arg name "$external" '.[] | select(.name == $name) | .y // 0' <<<"$json")

if [ "$external_x" -eq 0 ] && [ "$external_y" -eq 0 ]; then
    # External is currently the left/top display; switch internal to primary
    wlr-randr --output "$external" --mode "$external_mode" --pos 0x0 \
              --output "$internal" --mode "$internal_mode" --pos "${external_width}x0" --primary
else
    # Otherwise make external primary and place internal on the right
    wlr-randr --output "$internal" --mode "$internal_mode" --pos "${external_width}x0" \
              --output "$external" --mode "$external_mode" --pos 0x0 --primary
fi
