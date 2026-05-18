#!/usr/bin/env bash

# Adjust brightness and show OSD
# Usage: brightness.sh up|down

BRIGHTNESS_CMD="brightnessctl"

# Amount to change (percent)
STEP=5

case $1 in
  up)
    if command -v "$BRIGHTNESS_CMD" >/dev/null 2>&1; then
      $BRIGHTNESS_CMD set +${STEP}% -q
      # Show OSD with new brightness percentage
      swayosd-client --brightness "$($BRIGHTNESS_CMD get)"
    else
      notify-send "Error" "$BRIGHTNESS_CMD not found"
    fi
    ;;
  down)
    if command -v "$BRIGHTNESS_CMD" >/dev/null 2>&1; then
      $BRIGHTNESS_CMD set ${STEP}%- -q
      swayosd-client --brightness "$($BRIGHTNESS_CMD get)"
    else
      notify-send "Error" "$BRIGHTNESS_CMD not found"
    fi
    ;;
  *)
    echo "Usage: $0 [up|down]"
    exit 1
    ;;
esac
