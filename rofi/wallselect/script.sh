#!/bin/bash

WALL_DIR="$HOME/backgrounds/"

# Kill hyprpaper if running (we're switching to swww)
pkill hyprpaper 2>/dev/null

# Start swww daemon if not already running
if ! pgrep -x swww-daemon >/dev/null; then
    swww init
fi

# Rofi wallpaper selector with previews (now includes .gif)
SELECTED=$(find "$WALL_DIR" \
    -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) \
    | shuf \
    | while read -r img; do
        echo -en "$img\0icon\x1f$img\n"
    done \
    | rofi -dmenu -show-icons -theme "$HOME/.config/rofi/wallselect/style.rasi")

# If user selected a wallpaper, set it with swww
if [ -n "$SELECTED" ]; then
    swww img "$SELECTED" \
        --transition-type grow \
        --transition-duration 0.5 \
        --transition-fps 144
fi
