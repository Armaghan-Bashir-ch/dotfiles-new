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
# Connection functions (nmtui-style)
# -------------------------

connect_with_feedback() {
    local ssid="$1"
    local password="$2"

    notify-send "🔄 Connecting to $ssid..." -t 2000

    # Start connection in background
    nmcli dev wifi connect "$ssid" password "$password" &
    local pid=$!

    # Monitor connection progress (like nmtui)
    local timeout=30
    local count=0

    while ((count < timeout)); do
        # Check if connection succeeded
        if nmcli -t dev status | grep -q "wifi.*connected" && nmcli -t -f active,ssid dev wifi | grep -q "yes:$ssid"; then
            notify-send "✅ Connected to $ssid" -t 3000
            return 0
        fi

        # Check for common errors
        if nmcli -t dev wifi | grep -q "$ssid.*--"; then
            kill $pid 2>/dev/null
            notify-send "❌ Failed to connect to $ssid" -t 3000
            return 1
        fi

        sleep 1
        ((count++))
    done

    # Timeout
    kill $pid 2>/dev/null
    notify-send "⏰ Connection to $ssid timed out" -t 3000
    return 1
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
    if [[ -n "$conn_name" && "$conn_name" != "--" ]]; then
        # Check if this connection is currently active
        if [[ "$conn_name" == "$connected_ssid" ]]; then
            saved_connections+=("✓   $conn_name (Connected)")
        else
            saved_connections+=("󰖩   $conn_name")
        fi
        saved_ssids+=("$conn_name")
    fi
done < <(nmcli -t -f name,type connection show 2>/dev/null | grep ":802-11-wireless" | cut -d: -f1)

# -------------------------
# Get available networks (safe) - exclude saved connections
# -------------------------
available_networks=()
if [[ "$wifi_status" == "enabled" ]]; then
    while IFS= read -r ssid; do
        if [[ -n "$ssid" && "$ssid" != "--" ]]; then
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
        connect_with_feedback "$ssid" "$password"
        ;;

    󰖩*|✓*)
        # Saved connection - try to connect without password (nmtui style)
        conn_name=$(echo "$choice" | sed 's/^[^ ]*  //' | sed 's/ (Connected)//')
        notify-send "🔄 Connecting to saved network: $conn_name..." -t 2000

        if nmcli connection up "$conn_name" --timeout 15 2>/dev/null; then
            notify-send "✅ Connected to $conn_name" -t 3000
        else
            notify-send "❌ Failed to connect to saved network: $conn_name" -t 3000
        fi
        ;;

    *)
        # Regular network - check if it has a saved connection first
        ssid=$(echo "$choice" | sed 's/^[^ ]*  //')
        saved_conn=$(nmcli -t -f name connection show 2>/dev/null | grep -i "^$ssid$" | head -1)

        if [[ -n "$saved_conn" ]]; then
            # Has saved connection - try it first
            notify-send "🔄 Connecting to saved network: $ssid..." -t 2000
            if nmcli connection up "$saved_conn" --timeout 15 2>/dev/null; then
                notify-send "✅ Connected to $ssid" -t 3000
            else
                # Saved connection failed - ask for password
                password=$(prompt_password)
                connect_with_feedback "$ssid" "$password"
            fi
        else
            # New network - ask for password
            password=$(prompt_password)
            connect_with_feedback "$ssid" "$password"
        fi
        ;;

    "Connected to"*)
        kitty -e sh -c "nmcli dev wifi show-password; read -p 'Press Return to close...'"
        ;;

    "")
        exit 0
        ;;
esac
