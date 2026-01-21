#!/bin/bash

set -euo pipefail

# -------------------------
# Notify initial check
# -------------------------
notify-send -e -h string:x-canonical-private-synchronous:wifi_notif -u low -i ~/App-Icons/WiFi_Logo.svg "WiFi Manager" "Checking for Wi-Fi connections..."

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
enable_wifi_menu() {
    echo "Enable Wi-Fi" | rofi -dmenu -theme "$ENABLE_THEME"
}

list_wifi_menu() {
    menu_items=("󰤨   Disable Wi-Fi" "   Manual Setup")

    [[ -n "$connected_ssid" ]] && menu_items+=("   Connected to $connected_ssid")

    for conn in "${saved_connections[@]}"; do
        menu_items+=("$conn")
    done

    for net in "${available_networks[@]}"; do
        menu_items+=("$net")
    done

    printf '%s\n' "${menu_items[@]}" | rofi -markup-rows -dmenu -theme "$LIST_THEME"
}

prompt_ssid() {
    rofi -dmenu -p "SSID" -theme "$SSID_THEME"
}

prompt_password() {
    rofi -dmenu -p "Password" -theme "$PASSWORD_THEME"
}

# -------------------------
# Verify connection
# -------------------------
verify_connection() {
    local ssid="$1"
    local max_wait="${2:-15}"
    local count=0

    local device
    device=$(nmcli -t -f device,type device status 2>/dev/null | grep ":wifi$" | cut -d: -f1 | head -1)
    [[ -z "$device" ]] && return 1

    while [[ $count -lt $max_wait ]]; do
        local active_ssid
        active_ssid=$(nmcli -t -f active,ssid dev "$device" 2>/dev/null | grep '^yes' | cut -d: -f2-)

        if [[ "$active_ssid" == "$ssid" ]]; then
            local ip
            ip=$(nmcli -t -f ip4.address dev "$device" 2>/dev/null | head -1)
            if [[ -n "$ip" && "$ip" != "--" ]]; then
                if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
                    return 0
                fi
            fi
        fi

        sleep 1
        ((count++))
    done

    return 1
}

# -------------------------
# Connect function with feedback
# -------------------------
connect_with_feedback() {
    local ssid="$1"
    local password="$2"

    notify-send -e -h string:x-canonical-private-synchronous:wifi_notif -u low -i ~/App-Icons/WiFi_Logo.svg "WiFi Manager" "  Connecting to $ssid..." -t 2000

    if nmcli dev wifi connect "$ssid" password "$password" --timeout 30 >/dev/null 2>&1; then
        if verify_connection "$ssid" 15; then
            notify-send -i ~/App-Icons/WiFi_Logo.svg "WiFi Manager" "  Connected to $ssid" -t 3000
            return 0
        else
            notify-send -e -h string:x-canonical-private-synchronous:wifi_notif -u low -i ~/App-Icons/WiFi_Logo.svg "WiFi Manager" "  Connected but no internet - $ssid" -t 3000
            return 1
        fi
    else
        notify-send -e -h string:x-canonical-private-synchronous:wifi_notif -u low -i ~/App-Icons/WiFi_Logo.svg "WiFi Manager" "  Failed to connect to $ssid" -t 3000
        return 1
    fi
}

# -------------------------
# Check Wi-Fi status
# -------------------------
wifi_status=$(nmcli -t -f WIFI general | tail -n1)
[[ "$wifi_status" == "disabled" ]] && {
    enable_wifi_menu >/dev/null
    nmcli radio wifi on
}

# -------------------------
# Current connection
# -------------------------
connected_ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2- || true)

# -------------------------
# Saved connections
# -------------------------
saved_connections=()
saved_ssids=()
while IFS= read -r conn_name; do
    [[ -z "$conn_name" || "$conn_name" == "--" ]] && continue

    if [[ "$conn_name" == "$connected_ssid" ]]; then
        saved_connections+=("✓   $conn_name (Connected)")
    else
        saved_connections+=("󰖩   $conn_name")
    fi
    saved_ssids+=("$conn_name")
done < <(nmcli -t -f name,type connection show 2>/dev/null | grep ":802-11-wireless" | cut -d: -f1)

# -------------------------
# Available networks
# -------------------------
available_networks=()
if [[ "$wifi_status" == "enabled" ]]; then
    while IFS= read -r ssid; do
        [[ -z "$ssid" || "$ssid" == "--" ]] && continue

        skip=false
        for saved_ssid in "${saved_ssids[@]}"; do
            [[ "$ssid" == "$saved_ssid" ]] && { skip=true; break; }
        done
        [[ "$skip" == false ]] && available_networks+=("   $ssid")
    done < <(nmcli -t -f ssid dev wifi 2>/dev/null | sort -u)
fi

# -------------------------
# Show menu
# -------------------------
choice=$(list_wifi_menu)

# -------------------------
# Strip only whitespace, keep icons
# -------------------------
choice=$(echo "$choice" | sed -E 's/^[[:space:]]+//;s/[[:space:]]+$//')

# -------------------------
# Handle choice
# -------------------------
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
        conn_name=$(echo "$choice" | sed -E 's/^[^[:alnum:]]+\s*//;s/\s*\(Connected\)//')
        ssid=$(nmcli -g 802-11-wireless.ssid connection show "$conn_name" 2>/dev/null)
        [[ -z "$ssid" ]] && ssid="$conn_name"
        notify-send -e -h string:x-canonical-private-synchronous:wifi_notif -u low -i ~/App-Icons/WiFi_Logo.svg "WiFi Manager" "  Connecting to saved network: $ssid..." -t 2000
        if nmcli connection up "$conn_name" --timeout 15 >/dev/null 2>&1; then
            verify_connection "$ssid" 10 && \
                notify-send -e -h string:x-canonical-private-synchronous:wifi_notif -u low -i ~/App-Icons/WiFi_Logo.svg "WiFi Manager" "  Connected to $ssid" -t 3000 || \
                notify-send -e -h string:x-canonical-private-synchronous:wifi_notif -u low -i ~/App-Icons/WiFi_Logo.svg "WiFi Manager" "  Connected but no internet: $ssid" -t 3000
        else
            notify-send -e -h string:x-canonical-private-synchronous:wifi_notif -u low -i ~/App-Icons/WiFi_Logo.svg "WiFi Manager" "  Failed to connect: $ssid" -t 3000
        fi
        ;;

    *)
        ssid=$(echo "$choice" | sed -E 's/^[^[:alnum:]]+\s*//')
        password=$(prompt_password)
        connect_with_feedback "$ssid" "$password"
        ;;

    "")
        exit 0
        ;;
esac
