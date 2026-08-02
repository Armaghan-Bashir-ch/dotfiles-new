// GlassIconButton.qml - rounded icon button with a liquid glass treatment.
//
// States: idle (subtle base tint) -> hover (soft white overlay) -> pressed
// (stronger overlay + quick scale-down). Supports a `busy` spinner, an
// infinitely rotating icon, and a disabled state.

import QtQuick 6.10

Item {
    id: root

    signal clicked()

    property string icon: ""
    property real size: GlassTheme.controlSize
    property color iconColor: "white"
    // Optional accent tint for the base state (e.g. header icon chip).
    property color baseColor: "transparent"
    // Shows a thin arc spinner instead of the icon.
    property bool busy: false
    // Rotates the icon continuously (used while scanning).
    property bool spinning: false
    property bool enabled: true

    readonly property bool hovered: hoverArea.containsMouse
    readonly property bool pressed: hoverArea.pressed

    implicitWidth: size
    implicitHeight: size

    // Background pill
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: GlassTheme.radiusControl
        color: {
            if (!root.enabled) return Qt.rgba(1, 1, 1, GlassTheme.overlayDisabled)
            if (root.pressed) return Qt.rgba(1, 1, 1, GlassTheme.overlayPressed + 0.04)
            if (root.hovered) return Qt.rgba(1, 1, 1, GlassTheme.overlayHover + 0.03)
            return root.baseColor
        }
        border.width: 1
        border.color: root.hovered
            ? Qt.rgba(1, 1, 1, GlassTheme.borderHover)
            : root.baseColor.a > 0.01
                ? Qt.rgba(1, 1, 1, GlassTheme.borderStandard)
                : Qt.rgba(1, 1, 1, GlassTheme.borderSubtle)

        Behavior on color { ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard } }
        Behavior on border.color { ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard } }
    }

    // Press scale with a subtle spring.
    scale: root.pressed ? 0.92 : 1.0
    Behavior on scale { NumberAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeSpring } }

    // Icon glyph
    Text {
        anchors.centerIn: parent
        visible: !root.busy
        text: root.icon
        font.family: GlassTheme.iconFont
        font.pixelSize: Math.round(size * 0.5)
        // The glyph brightens toward white while hovered - a soft, smooth
        // color interpolation instead of a hard state switch.
        color: root.enabled
            ? (root.hovered ? Qt.lighter(root.iconColor, 1.35) : root.iconColor)
            : Qt.rgba(1, 1, 1, 0.35)

        Behavior on color {
            ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard }
        }

        rotation: 0
        RotationAnimation on rotation {
            running: root.spinning
            from: 0
            to: 360
            duration: 900
            loops: Animation.Infinite
            easing.type: GlassTheme.easeLinear
        }
    }

    // Busy spinner
    GlassSpinner {
        anchors.centerIn: parent
        visible: root.busy
        size: Math.round(root.size * 0.5)
        color: root.enabled ? root.iconColor : Qt.rgba(1, 1, 1, 0.35)
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
