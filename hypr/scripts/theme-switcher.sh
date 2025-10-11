#!/bin/bash

# Theme switcher script for waybar and rofi based on wallpaper directory
# Run after setting wallpaper via swww

# Get current wallpaper path
WALLPAPER_PATH=$(swww query | grep -oP 'image: \K.*')

if [ -z "$WALLPAPER_PATH" ]; then
    notify-send "Theme Switcher" "No wallpaper set, using default theme"
    THEME="Catppuccin-Mocha"
else
    # Extract theme from directory name
    THEME_DIR=$(dirname "$WALLPAPER_PATH")
    THEME=$(basename "$THEME_DIR")

# Validate theme (list of supported themes)
VALID_THEMES=("Catppuccin-Latte" "Catppuccin-Mocha" "Decay-Green" "Frosted-Glass" "Gruvbox-Retro" "Material-Sakura" "Nordic-Blue" "Rose-Pine" "Synth-Wave" "Tokyo-Night")
if [[ ! " ${VALID_THEMES[@]} " =~ " ${THEME} " ]]; then
    notify-send "Theme Switcher" "Invalid theme '$THEME', using default"
    THEME="Catppuccin-Mocha"
fi

# Randomly select waybar theme variant for multi-variant themes
WAYBAR_THEME="$THEME"
case "$THEME" in
    "Catppuccin-Mocha")
        if [ $((RANDOM % 2)) -eq 0 ]; then
            WAYBAR_THEME="Catppuccin-Macchiato"
        fi
        ;;
    "Catppuccin-Latte")
        if [ $((RANDOM % 2)) -eq 0 ]; then
            WAYBAR_THEME="Catppuccin-Frappe"
        else
            WAYBAR_THEME="Catppuccin-Latte"
        fi
        ;;
    "Tokyo-Night")
        VARIANTS=("Tokyo-Day" "Tokyo-Future" "Tokyo-Moon" "Tokyo-Night" "Tokyo-Storm")
        WAYBAR_THEME="${VARIANTS[$((RANDOM % 5))]}"
        ;;
    "Gruvbox-Retro")
        VARIANTS=("Gruvbox-Dark" "Gruvbox-Light" "Gruvbox-Retro")
        WAYBAR_THEME="${VARIANTS[$((RANDOM % 3))]}"
        ;;
    "Rose-Pine")
        VARIANTS=("Rose-Pine" "Rose-Pine-Dawn" "Rose-Pine-Moon")
        WAYBAR_THEME="${VARIANTS[$((RANDOM % 3))]}"
        ;;
    *)
        WAYBAR_THEME="$THEME"
        ;;
esac

# Update waybar style.css
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
sed -i "s|@import \"themes/.*\.css\";|@import \"themes/$WAYBAR_THEME.css\";|" "$WAYBAR_STYLE"

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

notify-send -h string:image-path:"$WALLPAPER_PATH" "Theme Switcher" "Switched to $THEME theme"

# Save current theme for other scripts
echo "$THEME" > ~/.config/hypr/current_theme.txt
fi
