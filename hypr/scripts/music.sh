#!/bin/bash

status=$(playerctl --player=spotify status 2>/dev/null || playerctl status 2>/dev/null)

case "$1" in
    playpause_json)
        if [ "$status" = "Playing" ]; then
            echo '{"text": "󰏤", "tooltip": "Playing - Click to pause"}'
        elif [ "$status" = "Paused" ]; then
            echo '{"text": "󰐊", "tooltip": "Paused - Click to play"}'
        else
            echo '{"text": "󰐊", "tooltip": "No music playing"}'
        fi
        ;;
    seekback_json)
        # only show the button while music is actually playing
        if [ "$status" = "Playing" ]; then
            echo '{"text": "󰒮", "class": "on"}'
        else
            echo '{"text": "", "class": "off"}'
        fi
        ;;
    seekfwd_json)
        if [ "$status" = "Playing" ]; then
            echo '{"text": "󰒭", "class": "on"}'
        else
            echo '{"text": "", "class": "off"}'
        fi
        ;;
    seekback)
        playerctl --player=spotify position 10- 2>/dev/null || playerctl position 10- 2>/dev/null
        ;;
    seekfwd)
        playerctl --player=spotify position 10+ 2>/dev/null || playerctl position 10+ 2>/dev/null
        ;;
    next)
        playerctl --player=spotify next 2>/dev/null || playerctl next 2>/dev/null
        ;;
    prev)
        playerctl --player=spotify previous 2>/dev/null || playerctl previous 2>/dev/null
        ;;
esac
