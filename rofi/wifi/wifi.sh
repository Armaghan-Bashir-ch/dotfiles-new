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
    # Start with core options
    menu_items=("󰤨   Disable Wi-Fi")
    menu_items+=("   Manual Setup")

    # Add connection status if connected
    if [[ -n "$connected_ssid" ]]; then
        menu_items+=("   Connected to $connected_ssid")
    fi

    # Add saved connections
    for conn in "${saved_connections[@]}"; do
        menu_items+=("$conn")
    done

    # Add available networks
    for network in "${available_networks[@]}"; do
        menu_items+=("$network")
    done

    # Join with newlines
    printf '%s\n' "${menu_items[@]}" | rofi -markup-rows -dmenu -theme "$LIST_THEME"
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
# Get saved connections (can connect without password)
# -------------------------
saved_connections=()
saved_ssids=()
while IFS= read -r conn_name; do
    if [[ -n "$conn_name" && "$conn_name" != "--" && "$conn_name" != "$connected_ssid" ]]; then
        saved_connections+=("󰖩   $conn_name")
        saved_ssids+=("$conn_name")
    fi
done < <(nmcli -t -f name,type connection show 2>/dev/null | grep ":802-11-wireless" | cut -d: -f1)

# -------------------------
# Get available networks (safe) - exclude saved connections and connected network
# -------------------------
available_networks=()
if [[ "$wifi_status" == "enabled" ]]; then
    while IFS= read -r ssid; do
        if [[ -n "$ssid" && "$ssid" != "--" && "$ssid" != "$connected_ssid" ]]; then
            # Check if this SSID is already in saved connections
            skip=false
            for saved_ssid in "${saved_ssids[@]}"; do
                if [[ "$ssid" == "$saved_ssid" ]]; then
                    skip=true
                    break
                fi
            done
            if [[ "$skip" == false ]]; then
                available_networks+=("   $ssid")
            fi
        fi
    done < <(nmcli -t -f ssid dev wifi 2>/dev/null | sort -u)
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
        # Check if it's a saved connection (starts with 󰖩)
        if [[ "$choice" == 󰖩* ]]; then
            # Extract connection name (remove icon)
            conn_name=$(echo "$choice" | sed 's/^[^ ]*  //')
            # Try to connect to saved connection
            if nmcli connection up "$conn_name" 2>/dev/null; then
                # Success - saved connection worked
                true
            else
                # Saved connection failed - try connecting with password
                password=$(prompt_password)
                nmcli dev wifi connect "$choice" password "$password"
            fi
        else
            # Check if this network has a saved connection by SSID
            saved_conn=$(nmcli -t -f name connection show 2>/dev/null | grep -i "^$choice$" | head -1)
            if [[ -n "$saved_conn" ]]; then
                # Try to connect using saved connection
                if nmcli connection up "$saved_conn" 2>/dev/null; then
                    # Success - used saved connection
                    true
                else
                    # Saved connection failed - ask for password
                    password=$(prompt_password)
                    nmcli dev wifi connect "$choice" password "$password"
                fi
            else
                # Regular network - ask for password
                password=$(prompt_password)
                nmcli dev wifi connect "$choice" password "$password"
            fi
        fi
        ;;
esac
