#!/bin/bash
# Cycle through power profiles: performance → balanced → power-saver → performance...

PROFILES=("performance" "balanced" "power-saver")
CURRENT=$(powerprofilesctl get)

# Find current index
for i in "${!PROFILES[@]}"; do
    if [[ "${PROFILES[$i]}" == "$CURRENT" ]]; then
        INDEX=$i
        break
    fi
done

# Calculate next index (wrap around)
NEXT_INDEX=$(( (INDEX + 1) % ${#PROFILES[@]} ))
NEXT_PROFILE="${PROFILES[$NEXT_INDEX]}"

# Set the new profile
powerprofilesctl set "$NEXT_PROFILE"

# Optional: send notification
# notify-send "Power Profile" "Switched to $NEXT_PROFILE"
