import QtQuick 6.10
import QtQuick.Layouts 6.10
import Quickshell
import "../../../components"
import "../../../components/effects"

// SwayNC-style notification list for the Control Center.
// Consumes QsServices.Notifs (Quickshell notification backend - event driven,
// no polling, no swaync-client). Only "active" notifications are shown, so
// dismissing a notification (or Clear All) removes it from the list, matching
// SwayNC's control-center behaviour. Height is adaptive and capped so a large
// number of notifications scrolls internally instead of breaking the layout.
Item {
    id: root

    required property var notifs
    property var pywal

    // Color tokens matching the Control Center's M3 pywal palette
    readonly property color cOnSurface: pywal ? pywal.foreground : "#e6e6e6"
    readonly property color cOnSurfaceVariant: pywal ? pywal.onSurfaceMuted : "#999999"
    readonly property color cPrimary: pywal ? pywal.primary : "#82b7b0"
    readonly property color cError: pywal ? pywal.error : "#DE1222"
    readonly property color cSurfaceContainerHigh: pywal ? pywal.surfaceContainerHigh : "#1a1a1a"

    readonly property int notificationCount: root.notifs?.activeNotifications?.length ?? 0

    // Adaptive height: comfortable empty state, grows with notifications, capped
    // so the list scrolls internally and never breaks the Control Center layout.
    Layout.fillWidth: true
    Layout.preferredHeight: root.notificationCount === 0 ? 190 : Math.min(440, 120 + root.notificationCount * 96)
    Behavior on Layout.preferredHeight {
        NumberAnimation { duration: 300; easing.bezierCurve: Material3Anim.emphasized }
    }

    Rectangle {
        id: container
        anchors.fill: parent
        radius: 28
        // Transparent like MediaCard/SystemStats so the section blends into the
        // frosted-glass panel instead of reading as a solid slab.
        color: "transparent"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Header: title + count + clear all
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Notifications"
                    font.family: "Inter"
                    font.pixelSize: 16
                    font.weight: Font.Bold
                    color: root.cOnSurface
                }

                Rectangle {
                    visible: root.notificationCount > 0
                    width: countText.implicitWidth + 16
                    height: 24
                    radius: 12
                    color: Qt.rgba(root.cPrimary.r, root.cPrimary.g, root.cPrimary.b, 0.15)

                    Text {
                        id: countText
                        anchors.centerIn: parent
                        text: root.notificationCount
                        font.family: "Inter"
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        color: root.cPrimary
                    }
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    visible: root.notificationCount > 0
                    width: clearAllText.implicitWidth + 24
                    height: 32
                    radius: 16
                    color: clearAllMouse.pressed
                        ? Qt.rgba(root.cOnSurface.r, root.cOnSurface.g, root.cOnSurface.b, 0.12)
                        : clearAllMouse.containsMouse
                            ? Qt.rgba(root.cOnSurface.r, root.cOnSurface.g, root.cOnSurface.b, 0.08)
                            : "transparent"
                    Behavior on color { ColorAnimation { duration: 150 } }
                    scale: clearAllMouse.pressed ? 0.95 : 1.0
                    Behavior on scale { NumberAnimation { duration: 100; easing.bezierCurve: Material3Anim.springGentle } }

                    Text {
                        id: clearAllText
                        anchors.centerIn: parent
                        text: "Clear All"
                        font.family: "Inter"
                        font.pixelSize: 12
                        font.weight: Font.Medium
                        color: root.cOnSurfaceVariant
                    }

                    MouseArea {
                        id: clearAllMouse
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            if (root.notifs)
                                root.notifs.clearAll()
                        }
                    }
                }
            }

            ListView {
                id: notifListView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 8
                model: root.notifs?.activeNotifications ?? []

                // M3 Spatial Entrance
                add: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 300; easing.bezierCurve: Material3Anim.emphasizedDecelerate }
                    NumberAnimation { property: "x"; from: 50; to: 0; duration: 300; easing.bezierCurve: Material3Anim.emphasizedDecelerate }
                }

                remove: Transition {
                    NumberAnimation { property: "opacity"; to: 0; duration: 150; easing.bezierCurve: Material3Anim.emphasizedAccelerate }
                    NumberAnimation { property: "x"; to: 50; duration: 150; easing.bezierCurve: Material3Anim.emphasizedAccelerate }
                }

                displaced: Transition {
                    NumberAnimation { properties: "x,y"; duration: 250; easing.bezierCurve: Material3Anim.standard }
                }

                delegate: Rectangle {
                    id: notifDelegate
                    required property var modelData

                    width: notifListView.width
                    height: cardContent.implicitHeight + 28
                    radius: 20
                    // Subtle translucent surface - light 6% resting, matching the
                    // glassy hover/pressed state layer of the other control center cards.
                    color: notifMouse.pressed
                        ? Qt.rgba(root.cOnSurface.r, root.cOnSurface.g, root.cOnSurface.b, 0.14)
                        : notifMouse.containsMouse
                            ? Qt.rgba(root.cOnSurface.r, root.cOnSurface.g, root.cOnSurface.b, 0.10)
                            : Qt.rgba(root.cOnSurface.r, root.cOnSurface.g, root.cOnSurface.b, 0.06)
                    Behavior on color { ColorAnimation { duration: 150 } }

                    MouseArea {
                        id: notifMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        // Activate/open the notification's default action when the card body is clicked
                        onClicked: {
                            const actions = notifDelegate.modelData?.actions
                            if (actions && actions.length > 0 && actions[0].invoke)
                                actions[0].invoke()
                        }
                    }

                    NotificationCard {
                        id: cardContent
                        anchors.fill: parent
                        anchors.margins: 14
                        notification: notifDelegate.modelData
                        pywal: root.pywal
                        showCloseButton: true      // dismiss individual notification
                        showTimestamp: true        // relative time ("5m ago")
                        showActions: true          // inline action buttons
                        showBody: true
                        showAppIcon: true          // app icon where available

                        primaryColor: root.cPrimary
                        onSurfaceColor: root.cOnSurface
                        onSurfaceVariantColor: root.cOnSurfaceVariant
                        errorColor: root.cError
                        surfaceContainerHighColor: Qt.rgba(root.cOnSurface.r, root.cOnSurface.g, root.cOnSurface.b, 0.08)
                    }
                }

                // Empty state
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12
                    visible: root.notificationCount === 0
                    opacity: visible ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 200 } }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: root.notifs?.dnd ? "󰂛" : "󰂚"
                        font.family: "Material Design Icons"
                        font.pixelSize: 56
                        color: Qt.rgba(root.cOnSurface.r, root.cOnSurface.g, root.cOnSurface.b, 0.1)
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: root.notifs?.dnd ? "Do Not Disturb is on" : "No Notifications"
                        font.family: "Inter"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        color: Qt.rgba(root.cOnSurface.r, root.cOnSurface.g, root.cOnSurface.b, 0.4)
                    }
                }
            }
        }
    }
}
