#!/bin/bash

# Theme switcher script for waybar and rofi based on wallpaper directory
# Run after setting wallpaper via swww

# Read current theme
CURRENT_THEME=$(cat ~/.config/hypr/current_theme.txt 2>/dev/null || echo "")

# Get current wallpaper path
WALLPAPER_PATH=$(swww query | grep -oP 'image: \K.*')

if [ -z "$WALLPAPER_PATH" ]; then
    notify-send "Theme Switcher" "No wallpaper set, using default theme"
    THEME="Catppuccin-Mocha"
else
    # Extract theme from directory name
    THEME_DIR=$(dirname "$WALLPAPER_PATH")
    THEME=$(basename "$THEME_DIR")
    WALLPAPER_NAME=$(basename "$WALLPAPER_PATH")

# Validate theme (list of supported themes)
VALID_THEMES=("Catppuccin-Latte" "Catppuccin-Mocha" "Decay-Green" "Frosted-Glass" "Gruvbox-Retro" "Material-Sakura" "Nordic-Blue" "Rose-Pine" "Synth-Wave" "Tokyo-Night")
if [[ ! " ${VALID_THEMES[@]} " =~ " ${THEME} " ]]; then
    notify-send "Theme Switcher" "Invalid theme '$THEME', using default"
    THEME="Catppuccin-Mocha"
fi

# Select waybar theme based on specific wallpapers
WAYBAR_THEME="$THEME"
case "$THEME" in
    "Catppuccin-Latte")
        WAYBAR_THEME="Catppuccin-Latte"
        ;;
    "Catppuccin-Mocha")
        LIGHT_WALLPAPERS=("Up-InSky.jpg" "ColorfulRoad-Design.jpg" "StreeView-FromRoofTop.png" "Abandoned-Town.jpg" "DarkWinter-Forest.jpg" "Aesthetic-FuturisticTown.jpg" "Sunset-Evening.png")
        if [[ " ${LIGHT_WALLPAPERS[@]} " =~ " ${WALLPAPER_NAME} " ]]; then
            WAYBAR_THEME="Catppuccin-Frappe"
        else
            WAYBAR_THEME="Catppuccin-Macchiato"
        fi
        ;;
    "Tokyo-Night")
        if [ "$WALLPAPER_NAME" = "Night-Cafe.jpg" ]; then
            VARIANTS=("Tokyo-Future" "Tokyo-Moon" "Tokyo-Storm")
            WAYBAR_THEME="${VARIANTS[$((RANDOM % 3))]}"
        else
            WAYBAR_THEME="Tokyo-Day"
        fi
        ;;
    "Gruvbox-Retro")
        LIGHT_WALLPAPERS=("Morning-StreetView.png" "ChillBedroom-Cyan.png" "PrettyGreen-Town.jpg" "Town-in-Progress.jpg")
        if [[ " ${LIGHT_WALLPAPERS[@]} " =~ " ${WALLPAPER_NAME} " ]]; then
            WAYBAR_THEME="Gruvbox-Light"
        else
            VARIANTS=("Gruvbox-Dark" "Gruvbox-Retro")
            WAYBAR_THEME="${VARIANTS[$((RANDOM % 2))]}"
        fi
        ;;
    "Rose-Pine")
        LIGHT_WALLPAPERS=("SunSet-AnimatedForest.png" "Japanese-WavesFlow.jpg" "Warm-Setup.jpeg" "Reflected-Ocean.jpg")
        if [[ " ${LIGHT_WALLPAPERS[@]} " =~ " ${WALLPAPER_NAME} " ]]; then
            WAYBAR_THEME="Rose-Pine-Dawn"
        else
            VARIANTS=("Rose-Pine" "Rose-Pine-Moon")
            WAYBAR_THEME="${VARIANTS[$((RANDOM % 2))]}"
        fi
        ;;
    *)
        WAYBAR_THEME="$THEME"
        ;;
esac

# Set swaync theme to match waybar
SWAYNC_THEME="$WAYBAR_THEME"

# Update waybar style.css
WAYBAR_STYLE="$HOME/.config/waybar/style.css"
sed -i "s|@import \"themes/.*\.css\";|@import \"themes/$WAYBAR_THEME.css\";|" "$WAYBAR_STYLE"

# Update wlogout style.css
WLOGOUT_STYLE="$HOME/.config/wlogout/style.css"
sed -i "s|@import \"/home/armaghan/.config/waybar/themes/.*\.css\";|@import \"/home/armaghan/.config/waybar/themes/$WAYBAR_THEME.css\";|" "$WLOGOUT_STYLE"

# Update rofi styles that import themes
ROFI_STYLES=("$HOME/.config/rofi/launcher/style.rasi" "$HOME/.config/rofi/wallselect/style.rasi")
THEME_PATH="$HOME/.config/rofi/themes/$THEME.rasi"
for STYLE in "${ROFI_STYLES[@]}"; do
    if [ -f "$STYLE" ]; then
        sed -i "s|@import \".*themes/.*\.rasi\"|@import \"$THEME_PATH\"|g; s|@theme \".*themes/.*\.rasi\"|@theme \"$THEME_PATH\"|g" "$STYLE"
    fi
done

# Randomly switch launcher between Style-1 and Style-2
LAUNCHER_STYLE_FILE="$HOME/.config/rofi/launcher/style.rasi"
if [ -f "$LAUNCHER_STYLE_FILE" ]; then
    RANDOM_STYLE=$((RANDOM % 2))
    if [ $RANDOM_STYLE -eq 0 ]; then
        STYLE_FILE="Style-1.rasi"
    else
        STYLE_FILE="Style-2.rasi"
    fi
    sed -i "s|@import \"styles/.*\.rasi\"|@import \"styles/$STYLE_FILE\"|" "$LAUNCHER_STYLE_FILE"
fi

# Update rofi launcher background-image to current wallpaper in both styles
ROFI_STYLES_UPDATE=("$HOME/.config/rofi/styles/Style-1.rasi" "$HOME/.config/rofi/styles/Style-2.rasi")
if [ -n "$WALLPAPER_PATH" ]; then
    # Escape path for sed
    ESCAPED_PATH=$(printf '%s\n' "$WALLPAPER_PATH" | sed 's/[[\.*^$()+?{|]/\\&/g')
    for STYLE_FILE in "${ROFI_STYLES_UPDATE[@]}"; do
        if [ -f "$STYLE_FILE" ]; then
            sed -i "s|url(\"[^\"]*\", height)|url(\"$ESCAPED_PATH\", height)|g" "$STYLE_FILE"
            sed -i "s|url(\"[^\"]*\", width)|url(\"$ESCAPED_PATH\", width)|g" "$STYLE_FILE"
        fi
    done
fi

# Update swaync style.css
SWAYNC_STYLE="$HOME/.config/swaync/style.css"
sed -i "s|@import \"themes/.*\.css\";|@import \"themes/$SWAYNC_THEME.css\";|" "$SWAYNC_STYLE"

# Reload swaync only if theme changed
if [ "$THEME" != "$CURRENT_THEME" ]; then
    (
        G_MESSAGES_DEBUG=none G_LOG_LEVEL=0 swaync-client --reload-css
        G_MESSAGES_DEBUG=none G_LOG_LEVEL=0 swaync-client --reload-config
    ) >/dev/null 2>&1 &
    disown
fi

# Reload waybar
pkill -SIGUSR2 waybar

notify-send -h string:image-path:"$WALLPAPER_PATH" "Theme Switcher" "Switched to $THEME theme"

# Save current theme for other scripts
echo "$THEME" > ~/.config/hypr/current_theme.txt
fi
