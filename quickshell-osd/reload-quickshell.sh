#!/bin/bash
# Reload QuickShell

# Kill the OSD instance gracefully first, then force if needed
OSD_PATH="$HOME/.config/quickshell-osd"
if pgrep -f "qs -n -p $OSD_PATH" > /dev/null; then
    echo "Stopping QuickShell..."
    pkill -f "qs -n -p $OSD_PATH"
    # Wait up to 5 seconds
    for i in {1..50}; do
        if ! pgrep -f "qs -n -p $OSD_PATH" > /dev/null; then
            break
        fi
        sleep 0.1
    done
    # Force kill if still running
    if pgrep -f "qs -n -p $OSD_PATH" > /dev/null; then
        pkill -9 -f "qs -n -p $OSD_PATH"
    fi
fi

# Start new instance
echo "Starting QuickShell..."
setsid -f qs -n -p "$OSD_PATH" > /dev/null 2>&1

echo "Done."
