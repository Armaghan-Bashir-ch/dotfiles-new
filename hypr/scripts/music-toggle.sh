#!/bin/bash

# Get player status
status=$(playerctl --player=spotify status 2>/dev/null || playerctl status 2>/dev/null)

if [ "$status" = "Playing" ]; then
    echo '{"text": "󰏤", "tooltip": "Playing - Click to pause"}'
elif [ "$status" = "Paused" ]; then
    echo '{"text": "󰐊", "tooltip": "Paused - Click to play"}'
else
    # No player or stopped
    echo '{"text": "󰐊", "tooltip": "No music playing"}'
fi
