// NetworkWindow.qml - layer-shell window hosting the Liquid Glass network menu.
//
// Changes vs. the original:
//   - transparent padding around the panel so the QML drop shadow has room to
//     render (the shadow lives inside the window, compositor-blur aware)
//   - smooth open/close animation (fade + gentle scale) instead of an instant
//     visibility toggle
//   - blur is provided by Hyprland via the `quickshell:network` namespace
//     layerrule (see hyprland-glass.conf)

import QtQuick 6.10
import Quickshell
import Quickshell.Wayland

import "."

PanelWindow {
    id: root

    property bool shouldShow: true
    property bool _closing: false
    // Room for the drop shadow around the panel.
    property real shadowPadding: 22

    screen: Quickshell.screens[0]

    anchors {
        top: true
        left: true
    }

    margins {
        top: 0
        left: 150
    }

    implicitWidth: panel.implicitWidth + shadowPadding * 2
    implicitHeight: panel.implicitHeight + shadowPadding * 2

    color: "transparent"

    visible: shouldShow || _closing

    WlrLayershell.namespace: "quickshell:network"
    WlrLayershell.keyboardFocus:
        shouldShow ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    NetworkPanel {
        id: panel
        anchors.fill: parent
        anchors.margins: root.shadowPadding

        onCloseRequested: root.closeAnimated()
    }

    // Fade + scale the panel on explicit close, then hide the window.
    function closeAnimated(): void {
        if (root._closing || !root.shouldShow) return
        root._closing = true
        closeAnim.start()
    }

    // Entrance animation whenever the panel becomes visible.
    onShouldShowChanged: {
        if (root.shouldShow) {
            root._closing = false
            panel.opacity = 0
            panel.scale = 0.94
            openAnim.start()
        }
    }

    // Play the entrance animation once after the first frame so the layer
    // surface is already mapped (avoids a flash of the final state).
    Component.onCompleted: Qt.callLater(() => {
        if (root.shouldShow && !root._closing) {
            panel.opacity = 0
            panel.scale = 0.94
            openAnim.start()
        }
    })

    ParallelAnimation {
        id: openAnim
        running: false

        NumberAnimation {
            target: panel; property: "opacity"; to: 1
            duration: 200; easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: panel; property: "scale"; to: 1
            duration: 260; easing.type: Easing.OutCubic
        }
    }

    ParallelAnimation {
        id: closeAnim

        NumberAnimation {
            target: panel; property: "opacity"; to: 0
            duration: 160; easing.type: Easing.InCubic
        }
        NumberAnimation {
            target: panel; property: "scale"; to: 0.97
            duration: 160; easing.type: Easing.InCubic
        }

        onFinished: {
            root._closing = false
            root.shouldShow = false
        }
    }
}
