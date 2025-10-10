#!/bin/bash

# Get current theme
THEME_FILE="$HOME/.config/hypr/current_theme.txt"
if [ -f "$THEME_FILE" ]; then
    THEME=$(cat "$THEME_FILE")
else
    THEME="Catppuccin-Mocha"
fi

# Map theme to tty-clock color (0-7)
case "$THEME" in
    "Catppuccin-Latte"|"Catppuccin-Mocha"|"Catppuccin-Macchiato"|"Catppuccin-Frappe")
        COLOR=4  # Blue
        ;;
    "Decay-Green")
        COLOR=2  # Green
        ;;
    "Frosted-Glass")
        COLOR=6  # Cyan
        ;;
    "Gruvbox-Retro"|"Gruvbox-Dark"|"Gruvbox-Light")
        COLOR=3  # Yellow
        ;;
    "Material-Sakura")
        COLOR=5  # Magenta
        ;;
    "Nordic-Blue")
        COLOR=4  # Blue
        ;;
    "Rose-Pine"|"Rose-Pine-Dawn"|"Rose-Pine-Moon")
        COLOR=5  # Magenta
        ;;
    "Synth-Wave")
        COLOR=1  # Red
        ;;
    "Tokyo-Night"|"Tokyo-Day"|"Tokyo-Future"|"Tokyo-Moon"|"Tokyo-Storm")
        COLOR=4  # Blue
        ;;
    *)
        COLOR=7  # White
        ;;
esac

# Launch tty-clock with theme color
ghostty -e tty-clock -c -C $COLOR -s -t