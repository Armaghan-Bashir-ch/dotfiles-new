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

    color: "transparent"

    visible: shouldShow

    WlrLayershell.keyboardFocus:
        shouldShow ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    BluetoothPanel {
        id: panel
        anchors.fill: parent

        onCloseRequested: root.shouldShow = false
    }
}
