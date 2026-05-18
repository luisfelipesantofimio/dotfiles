#!/usr/bin/env bash

set -euo pipefail

# Toggle internal eDP-1 output on/off
if ! command -v wlr-randr >/dev/null 2>&1; then
    echo "wlr-randr not found" >&2
    exit 1
fi

enable=$(wlr-randr --json | jq -r --arg name "eDP-1" '.[] | select(.name == $name) | .enabled' || echo "false")
if [ "$enable" = "true" ]; then
    wlr-randr --output eDP-1 --off
else
    wlr-randr --output eDP-1 --on
fi
