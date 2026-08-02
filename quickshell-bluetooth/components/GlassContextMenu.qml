// GlassContextMenu.qml - floating glass context menu.
//
// A near-opaque dark glass card (more opaque than the main surface so menu
// text stays crisp) with hover-highlighted entries. The host populates
// `model` with {label, icon} entries and handles itemSelected(index).

import QtQuick 6.10
import QtQuick.Layouts 6.10

Item {
    id: root

    signal itemSelected(int index)

    // List of {label: string, icon: string} actions.
    property var model: []
    property color textColor: "white"
    property real cardRadius: GlassTheme.radiusCard
    // Auto-size to the menu entries.
    property real itemHeight: 36
    property real horizontalPadding: 12

    implicitWidth: 192
    // 6 top + 6 bottom margin, 2px gap per item: 38n + 10.
    implicitHeight: model.length * (itemHeight + 2) + 10

    GlassShadow {
        radius: root.cardRadius
        depth: 6
        color: GlassTheme.shadowColor
        anchors.fill: parent
        z: -1
    }

    Rectangle {
        anchors.fill: parent
        radius: root.cardRadius
        color: Qt.rgba(0.03, 0.04, 0.06, 0.82)
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.16)

        // Subtle top catch-light so it reads as glass, not a flat box.
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            height: 1
            color: Qt.rgba(1, 1, 1, 0.20)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 6
        spacing: 2

        Repeater {
            model: root.model

            Rectangle {
                required property var modelData
                required property int index

                Layout.fillWidth: true
                Layout.preferredHeight: root.itemHeight
                radius: GlassTheme.radiusControl
                color: itemMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.11) : "transparent"
                Behavior on color { ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard } }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: root.horizontalPadding
                    anchors.rightMargin: root.horizontalPadding
                    spacing: 10

                    Text {
                        visible: modelData.icon && modelData.icon.length > 0
                        text: modelData.icon
                        font.family: GlassTheme.iconFont
                        font.pixelSize: 13
                        color: root.textColor
                    }

                    Text {
                        text: modelData.label
                        font.family: GlassTheme.fontFamily
                        font.pixelSize: 12
                        color: root.textColor
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    id: itemMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.itemSelected(index)
                }
            }
        }
    }
}
