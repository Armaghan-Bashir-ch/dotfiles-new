// GlassToggle.qml - glass switch used for Wi-Fi on/off.
//
// Track animates color (200ms), knob slides with a gentle spring, scales
// slightly while pressed or hovered, and the checked state emits a soft halo
// of accent light. Keeps the exact toggle semantics of the original menu
// (checked <-> wifiEnabled).

import QtQuick 6.10

Item {
    id: root

    signal toggled()

    property bool checked: false
    property color accentColor: Qt.rgba(0.51, 0.72, 0.69, 1)
    property bool enabled: true

    readonly property bool hovered: mouse.containsMouse
    readonly property bool pressed: mouse.pressed

    implicitWidth: 50
    implicitHeight: 30

    // Soft ambient glow when the toggle is on.
    Rectangle {
        anchors.fill: parent
        anchors.margins: -3
        radius: height / 2 + 3
        color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.14)
        opacity: root.checked ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
        }
    }

    // Track
    Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2
        color: root.checked
            ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b,
                      root.pressed ? 0.95 : 0.88)
            : Qt.rgba(1, 1, 1, root.hovered ? 0.22 : 0.14)
        border.width: 1
        border.color: root.checked
            ? Qt.rgba(1, 1, 1, 0.26)
            : Qt.rgba(1, 1, 1, GlassTheme.borderStandard)

        Behavior on color {
            ColorAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
        }
        Behavior on border.color {
            ColorAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
        }
    }

    // Knob
    Rectangle {
        id: knob
        width: 22
        height: 22
        radius: height / 2
        anchors.verticalCenter: parent.verticalCenter
        x: root.checked ? parent.width - width - 4 : 4
        color: "#ffffff"
        antialiasing: true

        // Soft ambient shadow under the knob.
        Rectangle {
            anchors.fill: parent
            anchors.margins: -1
            radius: height / 2
            color: Qt.rgba(0, 0, 0, 0.28)
            z: -1
            opacity: 0.6
        }

        Behavior on x {
            NumberAnimation { duration: GlassTheme.durSlow; easing.type: GlassTheme.easeSpring }
        }

        scale: root.pressed ? 1.12 : (root.hovered ? 1.06 : 1.0)
        Behavior on scale {
            NumberAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeSpring }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled()
    }
}
