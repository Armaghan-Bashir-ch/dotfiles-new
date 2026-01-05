#!/bin/bash
count=$(swaync-client -c)
if [ "$count" -eq 0 ]; then
    echo "󰂛"
else
    echo " $count"
fi
