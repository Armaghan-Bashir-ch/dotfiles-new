#!/bin/bash
count=$(swaync-client -c 2>/dev/null || echo "0")
dnd=$(swaync-client -D 2>/dev/null || echo "false")

if [ "$dnd" = "true" ]; then
    icon=""
    tooltip="Do Not Disturb is ON"
elif [ "$count" -eq 0 ]; then
    icon=""
    tooltip="No notifications"
else
    icon="<span foreground='red'><sup></sup></span>"
    tooltip="You have $count notification$([ "$count" -ne 1 ] && echo "s")"
fi

echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\"}"