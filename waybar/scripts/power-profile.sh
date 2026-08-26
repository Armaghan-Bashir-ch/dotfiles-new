#!/bin/bash
# Power profile daemon module for waybar
# Cycles through: performance → balanced → power-saver → performance...

PROFILES=("performance" "balanced" "power-saver")
ICONS=("󰈐" "󰈐" "󰈐")  # performance, balanced, power-saver icons
# Alternative icons: "󰈐" (speed), "󰈐" (balance), "󰈐" (leaf)

CURRENT=$(powerprofilesctl get)

# Get current profile index
for i in "${!PROFILES[@]}"; do
    if [[ "${PROFILES[$i]}" == "$CURRENT" ]]; then
        INDEX=$i
        break
    fi
done

# Get icon based on current profile
case "$CURRENT" in
    "performance")
        ICON="󰈐"
        TOOLTIP="Performance Mode"
        ;;
    "balanced")
        ICON="󰈐"
        TOOLTIP="Balanced Mode"
        ;;
    "power-saver")
        ICON="󰈐"
        TOOLTIP="Power Saver Mode"
        ;;
esac

# Output JSON for waybar
echo "{\"text\": \"$ICON\", \"tooltip\": \"$TOOLTIP\", \"class\": \"$CURRENT\"}"
