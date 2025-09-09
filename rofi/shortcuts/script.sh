#!/bin/bash

choices=$(cat <<EOF
󰘳 + Q             ⟹ Open Ghostty
󰘳 + F             ⟹ ToggleFloating mode
󰘳 + ⇧ + F         ⟹ Open Browser
󰘳 + ⇧ + Z         ⟹ Open Zen-Browser
󰘳 + ⇧ + O         ⟹ Open Obsidian
󰘳 + W             ⟹ Kill Active Window
󰘳 + V             ⟹ Open Rofi (Clipboard)
󰘳 + ⇧ + W         ⟹ Open Waybar
󰘳 + ⇧ + S         ⟹ Open Spotify
󰘳 + E             ⟹ Open File Manager (Dolphin)
󰘳 + X             ⟹ Open Power Menu
󰘳 + 󱁐             ⟹ Rofi App Launcher
󰘳 + 󰘵  + W        ⟹ Wallpaper Picker
󰘳 + 󰘵  + 󱘖  + W   ⟹ Open Rofi (Wifi)
󰘳 + 󰘵  + 󱘖  + C   ⟹ Open Terminal Clock
󰘳 + 󱘖  + M        ⟹ Open Cava
󰘳 + 󱘖  + C        ⟹ Open Calendar
󰘳 + 󱘖  + C        ⟹ Open Calendar
󱘖 + 󰘳  + R        ⟹ Restore previews session
󰘳  + H/L/J/K      ⟹ Move window focus 󰁝 󰁅 󰁍 󰁔
󱘖  + 󰘳 + H/L/J/K  ⟹ Snap window 󰁝 󰁅 󰁍 󰁔
󰘳  + 󰍽            ⟹ Resize window in ToggleFloating
󰘳  + 󰍾            ⟹ Move window in ToggleFloating
󰘳  + 1-9          ⟹ Switch to workspace (1-9)
󰘳  + ⇧ + 1-0      ⟹ Move window to workspace (1-10)
󰘳  + /            ⟹ Open help menu
󰘳  + M            ⟹ Switch to workspace 10
󰘳  + S            ⟹ Take a screenshot  
󰘳  + L            ⟹ Open Lock screen  
EOF
)


echo "$choices" | rofi -dmenu -i -p "Shortcuts" -theme "$HOME/.config/rofi/shortcuts/style.rasi"
