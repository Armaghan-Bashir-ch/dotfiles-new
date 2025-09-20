#!/usr/bin/env bash

notify-send "󰤨  Checking for Wifi connections"

set -euo pipefail

# -------------------------
# Paths to Rofi themes
# -------------------------
LIST_THEME="$HOME/.config/rofi/wifi/list.rasi"
ENABLE_THEME="$HOME/.config/rofi/wifi/enable.rasi"
SSID_THEME="$HOME/.config/rofi/wifi/ssid.rasi"
PASSWORD_THEME="$HOME/.config/rofi/wifi/password.rasi"

# -------------------------
# Menu functions
# -------------------------

# Menu: Enable Wi-Fi
enable_wifi_menu() {
    echo -e "Enable Wi-Fi" | rofi -dmenu -theme "$ENABLE_THEME"
}

# Menu: List Wi-Fi Networks
list_wifi_menu() {
    echo -e "󰤨   Disable Wi-Fi\n${connection_status}   Manual Setup\n${wifi_list}" \
        | rofi -markup-rows -dmenu -theme "$LIST_THEME"
}

# Prompt for SSID
prompt_ssid() {
    rofi -dmenu -p "SSID" -theme "$SSID_THEME"
}

# Prompt for password
prompt_password() {
    rofi -dmenu -p "Password" -theme "$PASSWORD_THEME"
}

# -------------------------
# Check Wi-Fi status
# -------------------------
wifi_status=$(nmcli -t -f WIFI general | tail -n1)

if [[ "$wifi_status" == "disabled" ]]; then
    choice=$(enable_wifi_menu)
    nmcli radio wifi on
fi

# -------------------------
# Get current connection
# -------------------------
connected_ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null \
    | grep '^yes' | cut -d: -f2- || true)

# -------------------------
# Get available networks (safe)
# -------------------------
wifi_list=""
if [[ "$wifi_status" == "enabled" ]]; then
    wifi_list=$(nmcli -t -f ssid,security dev wifi 2>/dev/null || echo "" \
        | awk -F: '
        {
            icon = ($2 ~ /WPA|WEP|802\.1X/) ? "" : "";
            if ($1 != "") {
                printf "%s   %s\n", icon, $1
            }
        }' | sort -u)
fi

# -------------------------
# Connection status string
# -------------------------
if [[ -n "$connected_ssid" ]]; then
    connection_status="   Connected to $connected_ssid\n"
else
    connection_status=""
fi

# -------------------------
# Main interaction
# -------------------------
if [[ "$wifi_status" == "enabled" ]]; then
    choice=$(list_wifi_menu)
else
    choice=$(enable_wifi_menu)
    nmcli radio wifi on
fi

# Strip leading icons/spaces
choice=$(echo "$choice" | sed -E 's/^[^a-zA-Z0-9]+//')

case "$choice" in
    "Enable Wi-Fi")
        nmcli radio wifi on
        ;;

    "Disable Wi-Fi")
        nmcli radio wifi off
        ;;

    "Manual Setup")
        ssid=$(prompt_ssid)
        [[ -z "$ssid" ]] && exit 0
        password=$(prompt_password)
        nmcli dev wifi connect "$ssid" hidden yes password "$password"
        ;;

    "Connected to"*)
        kitty -e sh -c "nmcli dev wifi show-password; read -p 'Press Return to close...'"
        ;;

    "")
        exit 0
        ;;

    *)
        password=$(prompt_password)
        nmcli dev wifi connect "$choice" password "$password"
        ;;
esac
