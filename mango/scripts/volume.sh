#!/usr/bin/bash

case $1 in
up)
    pactl set-sink-volume @DEFAULT_SINK@ +5% >/dev/null
    swayosd-client --output-volume 5
    pactl set-sink-mute @DEFAULT_SINK@ 0 >/dev/null
    ;;
down)
    pactl set-sink-volume @DEFAULT_SINK@ -5% >/dev/null
    swayosd-client --output-volume -5
    pactl set-sink-mute @DEFAULT_SINK@ 0 >/dev/null
    ;;
mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle >/dev/null
    ;;
esac
