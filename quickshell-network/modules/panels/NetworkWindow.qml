import QtQuick 6.10
import Quickshell
import Quickshell.Wayland

import "."

PanelWindow {
    id: root

    property bool shouldShow: true

    screen: Quickshell.screens[0]

    anchors {
        top: true
        left: true
    }

    margins {
        top: 12
        left: 150
    }

    implicitWidth: panel.implicitWidth
    implicitHeight: panel.implicitHeight

    color: Qt.rgba(0.17, 0.17, 0.19, 0.35)

    visible: shouldShow

    WlrLayershell.namespace: "quickshell:network"
    WlrLayershell.keyboardFocus:
        shouldShow ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    NetworkPanel {
        id: panel
        anchors.fill: parent

        onCloseRequested: root.shouldShow = false
    }
}
