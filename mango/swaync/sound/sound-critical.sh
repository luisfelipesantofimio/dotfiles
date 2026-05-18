#!/usr/bin/env bash

state="false"
if command -v swaync-client >/dev/null 2>&1; then
    state=$(swaync-client -D || echo "false")
fi

if [[ "$state" == "true" ]]; then
    exit 0
fi

play -v 0.3 ~/.config/mango/swaync/sound/critical.oga
