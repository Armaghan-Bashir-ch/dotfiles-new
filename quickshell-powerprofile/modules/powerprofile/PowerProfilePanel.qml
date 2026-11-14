import QtQuick 6.10
import QtQuick.Layouts 6.10
import Quickshell
import "../../services" as QsServices
import "../../components"

FocusScope {
    id: root

    property var pywal: null
    property string fontFamily: "Inter"
    property string iconFont: "Material Design Icons Desktop"
    readonly property var service: QsServices.PowerProfiles

    signal closeRequested()

    implicitWidth: 316
    implicitHeight: contentLayout.implicitHeight + 32
    focus: true

    readonly property color cPrimary: root.pywal ? root.pywal.primary : "#CE6649"
    readonly property color cOnSurface: root.pywal ? root.pywal.foreground : "#e5e8eb"
    readonly property color cOnSurfaceVariant: root.pywal ? root.pywal.onSurfaceMuted : "#9a9a9a"
    readonly property color cError: root.pywal ? root.pywal.error : "#DE1222"

    Keys.onEscapePressed: root.closeRequested()

    GlassSurface {
        id: glassPanel
        anchors.fill: parent
        radius: GlassTheme.radiusPanel
        fillColor: root.pywal ? root.pywal.background : "#070605"
        fillOpacity: GlassTheme.glassFillOpacity
        shadowDepth: GlassTheme.shadowDepth

        ColumnLayout {
            id: contentLayout
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Rectangle {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    radius: 12
                    color: Qt.rgba(root.cPrimary.r, root.cPrimary.g, root.cPrimary.b, 0.16)
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, GlassTheme.borderStandard)

                    Text {
                        anchors.centerIn: parent
                        text: "󱄇"
                        font.family: root.iconFont
                        font.pixelSize: 18
                        color: root.cPrimary
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 2

                    Text {
                        text: "Power Profile"
                        font.family: root.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: root.cOnSurface
                    }

                    Text {
                        text: root.service.busy
                            ? "Applying change..."
                            : root.service.available
                                ? root.service.profileLabel(root.service.activeProfile)
                                : "Daemon unavailable"
                        font.family: root.fontFamily
                        font.pixelSize: 11
                        color: root.service.available ? root.cOnSurfaceVariant : root.cError
                    }
                }

            }

            GridLayout {
                Layout.fillWidth: true
                columns: 3
                columnSpacing: 8
                rowSpacing: 8

                Repeater {
                    model: root.service.availableProfiles

                    delegate: Item {
                        required property string modelData
                        readonly property string profile: modelData
                        readonly property bool selected: root.service.activeProfile === profile
                        readonly property bool interactive: root.service.available && !root.service.busy

                        Layout.fillWidth: true
                        Layout.preferredHeight: 72
                        opacity: interactive ? 1 : 0.72

                        Rectangle {
                            id: profileBackground
                            anchors.fill: parent
                            radius: GlassTheme.radiusItem
                            color: selected
                                ? "transparent"
                                : Qt.rgba(1, 1, 1,
                                    profileMouse.pressed ? GlassTheme.overlayPressed
                                        : profileMouse.containsMouse ? GlassTheme.overlayHover : 0.07)
                            border.width: selected ? 0 : 1
                            border.color: Qt.rgba(1, 1, 1,
                                profileMouse.containsMouse ? GlassTheme.borderHover : GlassTheme.borderStandard)

                            Rectangle {
                                anchors.fill: parent
                                radius: GlassTheme.radiusItem
                                visible: selected
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: Qt.rgba(root.cPrimary.r, root.cPrimary.g, root.cPrimary.b, 0.22) }
                                    GradientStop { position: 0.45; color: Qt.rgba(root.cPrimary.r, root.cPrimary.g, root.cPrimary.b, 0.13) }
                                    GradientStop { position: 1.0; color: Qt.rgba(root.cPrimary.r, root.cPrimary.g, root.cPrimary.b, 0.09) }
                                }
                                border.width: 1
                                border.color: Qt.rgba(root.cPrimary.r, root.cPrimary.g, root.cPrimary.b, 0.38)

                                Rectangle {
                                    anchors.fill: parent
                                    radius: GlassTheme.radiusItem
                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: "transparent" }
                                        GradientStop { position: 0.82; color: "transparent" }
                                        GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.05) }
                                    }
                                }
                            }

                            Column {
                                anchors.centerIn: parent
                                spacing: 4

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: root.service.profileIcons[profile]
                                    font.family: root.iconFont
                                    font.pixelSize: 23
                                    color: selected ? root.cPrimary : root.cOnSurface
                                }

                                Text {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: root.service.profileLabel(profile)
                                    font.family: root.fontFamily
                                    font.pixelSize: 10
                                    font.weight: selected ? Font.DemiBold : Font.Normal
                                    color: selected ? root.cPrimary : root.cOnSurfaceVariant
                                }
                            }

                            MouseArea {
                                id: profileMouse
                                anchors.fill: parent
                                enabled: interactive
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    root.service.setProfile(profile)
                                    root.forceActiveFocus()
                                }
                            }
                        }
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                visible: !root.service.available || root.service.errorMessage.length > 0
                text: root.service.errorMessage.length > 0
                    ? root.service.errorMessage
                    : "Start power-profiles-daemon to select a profile"
                font.family: root.fontFamily
                font.pixelSize: 10
                color: root.cError
                elide: Text.ElideRight
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 36

                Rectangle {
                    anchors.fill: parent
                    radius: GlassTheme.radiusControl
                    color: offMouse.pressed
                        ? Qt.rgba(root.cError.r, root.cError.g, root.cError.b, 0.62)
                        : offMouse.containsMouse
                            ? Qt.rgba(root.cError.r, root.cError.g, root.cError.b, 0.54)
                            : Qt.rgba(root.cError.r, root.cError.g, root.cError.b, 0.46)
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, 0.28)

                    Row {
                        anchors.centerIn: parent
                        spacing: 0

                        Text {
                            text: "Off"
                            font.family: root.fontFamily
                            font.pixelSize: 11
                            font.weight: Font.DemiBold
                            color: "#ffffff"
                        }
                    }

                    MouseArea {
                        id: offMouse
                        anchors.fill: parent
                        enabled: !root.service.busy
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.service.stopDaemon()
                    }
                }
            }
        }
    }
}
