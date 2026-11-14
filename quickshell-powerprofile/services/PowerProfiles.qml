pragma Singleton

import QtQuick 6.10
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property var availableProfiles: ["performance", "balanced", "power-saver"]
    readonly property var profileIcons: ({
        "power-saver": "󱤅",
        "performance": "󰠠",
        "balanced": "󱠆"
    })

    property bool available: false
    property bool busy: false
    property string activeProfile: ""
    property string errorMessage: ""

    signal daemonStopped()

    Component.onCompleted: refresh()

    function refresh() {
        statusProc.exec(["powerprofilesctl", "get"])
    }

    function setProfile(profile: string) {
        if (root.busy || !root.available || !root.availableProfiles.includes(profile)) return

        root.busy = true
        root.errorMessage = ""
        setProc.exec(["powerprofilesctl", "set", profile])
    }

    function stopDaemon() {
        if (root.busy) return

        root.busy = true
        root.errorMessage = ""
        stopProc.exec(["systemctl", "--no-ask-password", "stop", "power-profiles-daemon.service"])
    }

    function profileLabel(profile: string) {
        switch (profile) {
        case "performance": return "Performance"
        case "balanced": return "Balanced"
        case "power-saver": return "Power Saver"
        default: return profile
        }
    }

    Process {
        id: statusProc

        command: ["powerprofilesctl", "get"]

        stdout: StdioCollector {
            onStreamFinished: {
                const profile = text.trim()
                if (profile.length === 0) return

                root.available = true
                root.activeProfile = profile
                root.errorMessage = ""
            }
        }

        onExited: code => {
            if (code !== 0) {
                root.available = false
                root.activeProfile = ""
                if (!root.busy) root.errorMessage = "Power-profiles daemon is not running"
            }
        }
    }

    Process {
        id: setProc

        onExited: code => {
            root.busy = false
            if (code === 0) {
                root.refresh()
            } else {
                root.errorMessage = "Could not switch power profile"
                root.refresh()
            }
        }
    }

    Process {
        id: stopProc

        onExited: code => {
            root.busy = false
            if (code === 0) {
                root.available = false
                root.activeProfile = ""
                root.errorMessage = ""
                root.daemonStopped()
            } else {
                root.errorMessage = "Could not stop power-profiles-daemon"
                root.refresh()
            }
        }
    }
}
