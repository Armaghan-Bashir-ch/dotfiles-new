#!/bin/bash
count=$(swaync-client -c)
dnd=$(swaync-client -D)

if [ "$dnd" = "true" ]; then
    echo ""
elif [ "$count" -eq 0 ]; then
    echo ""
else
    echo "<span foreground='red'><sup></sup></span>"
fi
