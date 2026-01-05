#!/bin/bash

current=$(powerprofilesctl get 2>/dev/null | tr -d '\n')

if [[ -z "$current" ]]; then
    printf '{"text": "?", "tooltip": "Power Profile: unknown"}'
    exit 1
fi

case $current in
    power-saver) icon="󱤅"
    ;;
    performance) icon="󰠠"
    ;;
    balanced) icon="󱠆"
    ;;
    *) icon="?"
    ;;
esac

printf '{"text": "%s", "tooltip": "Power Profile is %s"}' "$icon" "$current"