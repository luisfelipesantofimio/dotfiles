#!/usr/bin/env bash

set -euo pipefail

# Kill dimland if running and notify
pkill -f dimland || true
notify-send "Display restored"

exit 0
