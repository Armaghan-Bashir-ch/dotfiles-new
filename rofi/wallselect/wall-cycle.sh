#!/bin/bash

# Recursively find all images in ~/backgrounds
WALLPAPERS=$(find ~/backgrounds -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -iname "*.gif" \) | sort)

for SELECTED in $WALLPAPERS; do
    if [ -n "$SELECTED" ]; then
        swww img "$SELECTED" \
            --transition-type grow \
            --transition-duration 0.5 \
            --transition-fps 60
    fi
    sleep 1.5
done

