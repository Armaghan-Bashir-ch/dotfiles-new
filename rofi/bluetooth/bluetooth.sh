#!/usr/bin/env bash

notify-send -i ~/App-Icons/Bluetooth.png "Bluetooth Manager" "Checking Bluetooth devices"

set -euo pipefail

# -------------------------
# Paths to Rofi themes
# -------------------------
THEME="$HOME/.config/rofi/bluetooth/bluetooth.rasi"

# -------------------------
# Menu functions
# -------------------------

# Menu: List Bluetooth options
list_bluetooth_menu() {
    # Start with disable option
    menu_items=("󰂲  Disable Bluetooth")

    # Add connected device status if connected
    if [[ ${#connected_devices[@]} -gt 0 ]]; then
        # Get the first connected device name (remove icon)
        first_device="${connected_devices[0]}"
        device_name=$(echo "$first_device" | sed 's/^[^ ]*  //')
        menu_items+=("   Connected to $device_name")
    fi

    # Always add scan option
    menu_items+=("󰂰  Scan for devices")

    # Add all available devices (connected devices are already shown in status)
    for device in "${available_devices[@]}"; do
        menu_items+=("$device")
    done

    # Join with newlines
    printf '%s\n' "${menu_items[@]}" | rofi -markup-rows -dmenu -theme "$THEME"
}

# -------------------------
# Check Bluetooth status
# -------------------------
bluetooth_status=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')

# -------------------------
# Get device arrays
# -------------------------
connected_devices=()
available_devices=()
connected_names=()

if [[ "$bluetooth_status" == "yes" ]]; then
    # Get connected devices
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            device_name=$(echo "$line" | awk '{$1=$2=""; print substr($0,3)}' | sed 's/^[[:space:]]*//')
            if [[ -n "$device_name" ]]; then
                connected_devices+=("󰂱  $device_name")
                connected_names+=("$device_name")
            fi
        fi
    done < <(bluetoothctl devices Connected 2>/dev/null || echo "")

    # Get paired but not connected devices (exclude connected ones)
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            device_name=$(echo "$line" | awk '{$1=$2=""; print substr($0,3)}' | sed 's/^[[:space:]]*//')
            if [[ -n "$device_name" ]]; then
                # Check if this device is already connected
                skip=false
                for connected_name in "${connected_names[@]}"; do
                    if [[ "$device_name" == "$connected_name" ]]; then
                        skip=true
                        break
                    fi
                done
                if [[ "$skip" == false ]]; then
                    available_devices+=("󰂯  $device_name")
                fi
            fi
        fi
    done < <(bluetoothctl devices Paired 2>/dev/null | grep -v "Connected" || echo "")

    # Get discovered devices (not paired, exclude connected ones and already listed paired devices)
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            device_name=$(echo "$line" | awk '{$1=$2=""; print substr($0,3)}' | sed 's/^[[:space:]]*//')
            if [[ -n "$device_name" ]]; then
                # Check if this device is already connected or already in available_devices
                skip=false
                for connected_name in "${connected_names[@]}"; do
                    if [[ "$device_name" == "$connected_name" ]]; then
                        skip=true
                        break
                    fi
                done
                # Also check against already added available devices
                if [[ "$skip" == false ]]; then
                    for avail_device in "${available_devices[@]}"; do
                        avail_name=$(echo "$avail_device" | sed 's/^[^ ]*  //')
                        if [[ "$device_name" == "$avail_name" ]]; then
                            skip=true
                            break
                        fi
                    done
                fi
                if [[ "$skip" == false ]]; then
                    available_devices+=("󰂰  $device_name")
                fi
            fi
        fi
    done < <(bluetoothctl devices 2>/dev/null | grep -v "Paired\|Connected" || echo "")
fi

# -------------------------
# Main interaction
# -------------------------
if [[ "$bluetooth_status" == "yes" ]]; then
    choice=$(list_bluetooth_menu)
else
    # Show enable menu when Bluetooth is disabled
    choice=$(echo -e "󰂯  Enable Bluetooth" | rofi -dmenu -theme "$THEME")
fi

# -------------------------
# Handle choice
# -------------------------
case "$choice" in
    "󰂯  Enable Bluetooth")
        bluetoothctl power on
        notify-send -i ~/App-Icons/Bluetooth.png "Bluetooth Manager" "Bluetooth enabled"
        # Re-run the script to show the main menu
        exec "$0"
        ;;

    "󰂲  Disable Bluetooth")
        bluetoothctl power off
        notify-send -i ~/App-Icons/Bluetooth.png "Bluetooth Manager" "Bluetooth disabled"
        exit 0
        ;;

    "󰂰  Scan for devices")
        notify-send -i ~/App-Icons/Bluetooth.png "Bluetooth Manager" "Scanning for Bluetooth devices..."
        bluetoothctl scan on &
        sleep 8
        bluetoothctl scan off
        notify-send -i ~/App-Icons/Bluetooth.png "Bluetooth Manager" "Scan complete"
        # Re-run the script to show new devices
        exec "$0"
        ;;

    "󰂱"*|"󰂯"*|"󰂰"*)
        # Extract device name
        device_name=$(echo "$choice" | sed 's/^[^ ]*  //')

        # Find MAC address for this device name
        mac=$(bluetoothctl devices | grep -i "$device_name" | head -1 | awk '{print $2}')

        if [[ -n "$mac" && -n "$device_name" ]]; then
            # Check if already connected
            if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
                # Disconnect
                bluetoothctl disconnect "$mac"
                notify-send -i ~/App-Icons/Bluetooth.png "Bluetooth Manager" "Disconnected from $device_name"
            else
                # Try to connect - ensure device is trusted first
                notify-send -i ~/App-Icons/Bluetooth.png "Bluetooth Manager" "Connecting to $device_name..."
                bluetoothctl trust "$mac" 2>/dev/null || true
                if bluetoothctl connect "$mac"; then
                    notify-send -i ~/App-Icons/Bluetooth.png "Bluetooth Manager" "Connected to $device_name"
                else
                    notify-send -i ~/App-Icons/Bluetooth.png "Bluetooth Manager" "Failed to connect to $device_name"
                fi
            fi
        else
            notify-send -i ~/App-Icons/Bluetooth.png "Bluetooth Manager" "Could not find device: $device_name"
        fi
        ;;

    "")
        exit 0
        ;;
esac
