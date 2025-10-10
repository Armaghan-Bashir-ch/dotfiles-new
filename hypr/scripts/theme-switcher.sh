#!/bin/bash

# Theme switcher script for waybar and rofi based on wallpaper directory
# Run after setting wallpaper via swww

# Get current wallpaper path
WALLPAPER_PATH=$(swww query | grep -oP 'image: \K.*')

if [ -z "$WALLPAPER_PATH" ]; then
    echo "No wallpaper set, using default theme"
    THEME="Catppuccin-Mocha"
else
    # Extract theme from directory name
    THEME_DIR=$(dirname "$WALLPAPER_PATH")
    THEME=$(basename "$THEME_DIR")
    
    # Validate theme (list of supported themes)
    VALID_THEMES=("Catppuccin-Latte" "Catppuccin-Mocha" "Decay-Green" "Frosted-Glass" "Gruvbox-Retro" "Material-Sakura" "Nordic-Blue" "Rose-Pine" "Synth-Wave" "Tokyo-Night")
    if [[ ! " ${VALID_THEMES[@]} " =~ " ${THEME} " ]]; then
        echo "Invalid theme '$THEME', using default"
        THEME="Catppuccin-Mocha"
    fi
fi

# Update waybar style.css
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
sed -i "s|@import \"themes/.*\.css\";|@import \"themes/$THEME.css\";|" "$WAYBAR_STYLE"

# Update rofi styles that import themes
ROFI_STYLES=("$HOME/.config/rofi/launcher/style.rasi" "$HOME/.config/rofi/wallselect/style.rasi")
THEME_PATH="$HOME/.config/rofi/themes/$THEME.rasi"
for STYLE in "${ROFI_STYLES[@]}"; do
    if [ -f "$STYLE" ]; then
        sed -i "s|@import \".*themes/.*\.rasi\"|@import \"$THEME_PATH\"|" "$STYLE"
    fi
done

# Update rofi launcher background-image to current wallpaper
ROFI_STYLE2="$HOME/.config/rofi/styles/Style-2.rasi"
if [ -f "$ROFI_STYLE2" ] && [ -n "$WALLPAPER_PATH" ]; then
    # Escape path for sed
    ESCAPED_PATH=$(printf '%s\n' "$WALLPAPER_PATH" | sed 's/[[\.*^$()+?{|]/\\&/g')
    sed -i "s|url(\"[^\"]*\", height)|url(\"$ESCAPED_PATH\", height)|g" "$ROFI_STYLE2"
    sed -i "s|url(\"[^\"]*\", width)|url(\"$ESCAPED_PATH\", width)|g" "$ROFI_STYLE2"
fi

# Reload waybar
pkill -SIGUSR2 waybar

echo "Switched to $THEME theme"