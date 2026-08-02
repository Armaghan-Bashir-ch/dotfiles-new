// GlassButton.qml - pill-shaped text button in two flavors:
//   primary = filled with the accent color (dialog "Connect")
//   ghost   = translucent white glass with a thin rim (dialog "Cancel")
//
// Emits clicked().

import QtQuick 6.10

Item {
    id: root

    signal clicked()

    property string text: ""
    property color textColor: "white"
    property color accentColor: Qt.rgba(0, 0.6, 0.6, 1)
    property bool primary: false
    property bool enabled: true

    readonly property bool hovered: hoverArea.containsMouse
    readonly property bool pressed: hoverArea.pressed

    implicitWidth: Math.max(76, textItem.implicitWidth + 30)
    implicitHeight: 36

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: height / 2
        color: {
            if (!root.enabled) return Qt.rgba(1, 1, 1, GlassTheme.overlayDisabled)
            if (root.primary)
                return Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b,
                               root.pressed ? 0.62 : root.hovered ? 0.54 : 0.46)
            return Qt.rgba(1, 1, 1, root.pressed ? 0.16 : root.hovered ? 0.12 : 0.07)
        }
        border.width: 1
        border.color: root.primary
            ? Qt.rgba(1, 1, 1, 0.28)
            : Qt.rgba(1, 1, 1, root.hovered ? GlassTheme.borderHover : GlassTheme.borderStandard)

        Behavior on color { ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard } }
        Behavior on border.color { ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard } }
    }

    scale: root.pressed ? 0.96 : 1.0
    Behavior on scale { NumberAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeSpring } }

    Text {
        id: textItem
        anchors.centerIn: parent
        text: root.text
        font.family: GlassTheme.fontFamily
        font.pixelSize: 12
        font.weight: root.primary ? Font.DemiBold : Font.Normal
        color: root.primary ? "#ffffff" : root.textColor
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
