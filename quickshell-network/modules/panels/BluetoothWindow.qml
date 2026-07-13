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
        right: true
    }

    margins {
        top: 12
        right: 12
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

        onCloseRequested: Qt.quit()
    }
}
