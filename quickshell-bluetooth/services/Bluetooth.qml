pragma Singleton

import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var connectedDevices: Bluetooth.devices.values.filter(device => device.connected)
    readonly property bool powered: adapter?.enabled ?? false
    readonly property bool connected: connectedDevices.length > 0
    readonly property string deviceName: connected ? (connectedDevices[0]?.name ?? connectedDevices[0]?.alias ?? "Device") : ""
    readonly property int connectedCount: connectedDevices.length

    function togglePower() {
        const isOn = adapter?.enabled ?? false
        if (isOn) {
            toggleProc.command = ["quickshell-bt", "off"]
        } else {
            toggleProc.command = ["quickshell-bt", "on"]
        }
        toggleProc.running = true
    }

    function setDiscovering(enabled: bool) {
        if (adapter)
            adapter.discovering = enabled
    }

    Process {
        id: toggleProc
        command: []
        onExited: {
            // After the script runs, poll until Quickshell's adapter state syncs
            syncTimer.start()
        }
    }

    // Poll adapter state after toggle — Quickshell may need time to pick
    // up the adapter from BlueZ after rfkill unblock
    Timer {
        id: syncTimer
        interval: 600
        repeat: false
        onTriggered: {
            // Force binding re-evaluation
            var _ = Bluetooth.defaultAdapter
            // If rfkill was unblocked and adapter now visible, ensure it's powered on
            if (adapter && !adapter.enabled) {
                adapter.enabled = true
            }
        }
    }
}
