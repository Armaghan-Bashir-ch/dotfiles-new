#!/bin/bash

# Quickshell notification bell - replaces swaync-count.sh.
# Reads unread count + DND state from the quickshell-controlcenter IPC handler.

CC_PATH="/home/armaghan/.config/quickshell-controlcenter"

count=$(qs ipc -p "$CC_PATH" prop get controlcenter unreadCount 2>/dev/null)
dnd=$(qs ipc -p "$CC_PATH" prop get controlcenter dnd 2>/dev/null)

# QuickShell can print "No running instances..." to stdout.
# Only accept the values we actually expect.
if [[ "$count" =~ ^[0-9]+$ ]]; then
    :
else
    count=0
fi

if [[ "$dnd" == "true" ]]; then
    dnd=true
else
    dnd=false
fi

if [ "$dnd" = true ]; then
    icon=""
    tooltip="Do Not Disturb is ON"
elif [ "$count" -eq 0 ]; then
    icon=""
    tooltip="No notifications"
else
    plural=""
    [ "$count" -ne 1 ] && plural="s"

    icon=""
    tooltip="You have $count notification$plural"
fi

# Generate valid JSON.
printf '{"text":"%s","tooltip":"%s"}\n' "$icon" "$tooltip"
