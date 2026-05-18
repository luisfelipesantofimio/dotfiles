#!/usr/bin/env bash

set -euo pipefail

# Kill any running wlsunset instances (safe)
if pids=$(pgrep -f wlsunset || true); then
	if [ -n "$pids" ]; then
		pkill -f wlsunset || true
	fi
fi

# Start a fresh background wlsunset, detach and silence output
nohup wlsunset -T 3501 -t 3500 >/dev/null 2>&1 & disown