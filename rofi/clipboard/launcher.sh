#!/usr/bin/env bash

# Exit if clipboard is empty
if [[ -z $(wl-paste) ]]; then
    notify-send -i ~/App-Icons/Clipboard.png "Clipboard Manager" "Clipboard is Empty, Copy something"
    exit
fi

dir="$HOME/.config/rofi/clipboard"

# Main clipboard menu
choice=$(echo -e "\t\uf1f8   Wipe Clipboard\n$(cliphist list)" | \
    rofi -markup-rows -dmenu \
    -display-columns 2 \
    -theme "${dir}/clipboard.rasi")

# Handle "Wipe Clipboard"
if [[ $choice == *"Wipe Clipboard"* ]]; then
    cliphist wipe
    wl-copy -c
        notify-send -i ~/App-Icons/Clipboard.png "Clipboard Manager" "Clipboard has been wiped"
    exit

# Handle selection from history
elif [[ -n $choice ]]; then
    cliphist decode "$choice" | wl-copy
    wtype -M ctrl -M shift -P v -s 500 -p v -m shift -m ctrl

else
    exit
fi
