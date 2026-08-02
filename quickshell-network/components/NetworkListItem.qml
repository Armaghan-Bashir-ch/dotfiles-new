// NetworkListItem.qml - a single Wi-Fi row with the liquid glass treatment.
//
// Layout: [signal chip] [ssid + status] [connected badge | connect button]
//
// - Hover  : soft white overlay + faint halo shadow (the row lifts slightly)
// - Press  : stronger overlay
// - Active : accent gradient surface + soft glow + inner top highlight, with a
//            "Connected" glass pill that crossfades in on state changes
// - Signal : icon pulses briefly when the strength tier changes
//
// The click logic lives in the panel (so the original connect/disconnect
// behavior is preserved); this component only reports what the user wants.

import QtQuick 6.10
import QtQuick.Layouts 6.10

Item {
    id: root

    signal actionClicked()
    signal contextMenuRequested(real x, real y)

    // Bound explicitly by the ListView delegate (modelData: modelData).
    property var modelData: null
    property bool isActive: root.modelData ? root.modelData.active : false
    property color textColor: "white"
    property color textMutedColor: Qt.rgba(1, 1, 1, 0.6)
    property color accentColor: Qt.rgba(0.51, 0.72, 0.69, 1)
    property color interactiveColor: Qt.rgba(0.8, 0.4, 0.29, 1)

    // Strength tier 1..4 used for both the glyph and the pulse trigger.
    readonly property int strengthLevel: {
        const s = root.modelData ? root.modelData.strength : 0
        if (s >= 75) return 4
        if (s >= 50) return 3
        if (s >= 25) return 2
        return 1
    }
    property int _prevLevel: -1

    implicitHeight: 58

    // NOTE on the lift: the hover/active "floating" feel comes entirely from
    // the halo shadow below. The row itself must stay at its layout size -
    // the delegate width equals the list viewport width, so ANY scale > 1.0
    // would push the card past the list edge and get clipped by the panel.

    // --- Interaction (declared FIRST so every later binding can safely
    // reference it - mouse areas still receive events while visually behind
    // plain Rectangles, exactly like the original delegate). ----------------
    MouseArea {
        id: mouseArea
        anchors.fill: root
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton) {
                root.contextMenuRequested(mouse.x, mouse.y)
            } else {
                root.actionClicked()
            }
        }
    }

    // --- Card container ------------------------------------------------------
    // The card is inset 3px on every side so the halo shadow (anchors.margins:
    // -3 below) renders fully inside the list viewport instead of overflowing
    // and being clipped. All four margins stay equal -> the row is centered.
    Item {
        id: card
        anchors.fill: parent
        anchors.topMargin: 3
        anchors.bottomMargin: 3
        anchors.leftMargin: 3
        anchors.rightMargin: 3

    // --- Halo shadow (perceived depth for hover + active) -------------------
    Rectangle {
        anchors.fill: parent
        anchors.margins: -3
        radius: GlassTheme.radiusItem + 3
        color: Qt.rgba(0, 0, 0, 0.10)
        opacity: root.isActive ? 1.0 : (mouseArea.containsMouse ? 0.8 : 0.0)
        Behavior on opacity {
            NumberAnimation { duration: GlassTheme.durHover; easing.type: GlassTheme.easeStandard }
        }
    }

    // --- Active surface: accent gradient + rim ------------------------------
    // Opacity-faded so the connected state breathes in instead of popping.
    // Three-stop gradient (brighter at the top, gentle roll-off in the middle)
    // reads as light catching the row without a hard banding line.
    Rectangle {
        id: activeGlow
        anchors.fill: parent
        radius: GlassTheme.radiusItem
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.22) }
            GradientStop { position: 0.45; color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.13) }
            GradientStop { position: 1.0; color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.09) }
        }
        border.width: 1
        border.color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.38)
        opacity: root.isActive ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
        }

        // Bottom internal reflection: a whisper of light caught by the lower
        // edge of the selected row, matching the panel's glass material.
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

    // --- Row background (hover / press overlay) -----------------------------
    Rectangle {
        id: rowBg
        anchors.fill: parent
        radius: GlassTheme.radiusItem
        color: mouseArea.pressed
            ? Qt.rgba(1, 1, 1, GlassTheme.overlayPressed)
            : mouseArea.containsMouse
                ? Qt.rgba(1, 1, 1, GlassTheme.overlayHover)
                : "transparent"

        Behavior on color {
            ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard }
        }
    }

    // --- Inner top highlight on the active surface --------------------------
    // A whisper of light along the upper edge of the connected row.
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 1
        height: 1
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
            GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.09) }
            GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0) }
        }
        opacity: root.isActive ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
        }
    }

    // --- Hairline divider (skipped on the active row) ------------------------
    // Left edge aligns with the SSID text column (10 margin + 36 chip + 12
    // spacing); right edge aligns with the row's content margin (10).
    Rectangle {
        visible: !root.isActive
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.leftMargin: 58
        anchors.rightMargin: 10
        height: 1
        color: Qt.rgba(1, 1, 1, 0.05)
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 12

        // --- Signal chip -----------------------------------------------------
        Item {
            width: 36
            height: 36

            Rectangle {
                anchors.fill: parent
                radius: 10
                color: root.isActive
                    ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.20)
                    : Qt.rgba(1, 1, 1, 0.06)
                Behavior on color {
                    ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard }
                }
            }

            Text {
                id: sigIcon
                anchors.centerIn: parent
                text: {
                    const s = root.strengthLevel
                    if (s >= 4) return "󰤨"
                    if (s === 3) return "󰤥"
                    if (s === 2) return "󰤢"
                    return "󰤟"
                }
                font.family: GlassTheme.iconFont
                font.pixelSize: 16
                color: root.isActive ? root.accentColor : root.textColor
                Behavior on color {
                    ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard }
                }
            }
        }

        // --- SSID + status ---------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Text {
                    text: root.modelData ? root.modelData.ssid : ""
                    font.family: GlassTheme.fontFamily
                    font.pixelSize: 13
                    font.weight: root.isActive ? Font.DemiBold : Font.Medium
                    color: root.isActive ? root.accentColor : root.textColor
                    elide: Text.ElideRight
                    Layout.fillWidth: true

                    Behavior on color {
                        ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard }
                    }
                }

                Text {
                    visible: root.modelData ? root.modelData.isSecure : false
                    text: "󰌾"
                    font.family: GlassTheme.iconFont
                    font.pixelSize: 10
                    color: root.textMutedColor
                }
            }

            Text {
                text: root.isActive ? "Connected" : `${root.modelData ? root.modelData.strength : 0}%`
                font.family: GlassTheme.fontFamily
                font.pixelSize: 10
                // Weak signals pick up a restrained warm tint so quality reads
                // at a glance; strong signals stay neutral.
                color: root.isActive
                    ? root.accentColor
                    : root.strengthLevel <= 2
                        ? Qt.rgba(1, 0.78, 0.52, 0.62)
                        : root.textMutedColor

                Behavior on color {
                    ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard }
                }
            }
        }

        // --- Right side ------------------------------------------------------
        // Crossfades between the connect affordance and the "Connected" pill
        // whenever the row's active state changes; the width breathes with it.
        Item {
            Layout.preferredWidth: root.isActive ? 98 : 30
            Layout.preferredHeight: 30

            Behavior on Layout.preferredWidth {
                NumberAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
            }

            // Connected pill badge (gradient glass, crossfades in)
            Rectangle {
                id: badge
                anchors.fill: parent
                radius: 15
                opacity: root.isActive ? 1.0 : 0.0
                scale: root.isActive ? 1.0 : 0.92

                // Accent glass base (brighter at the top, like the row).
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.24) }
                    GradientStop { position: 0.45; color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.14) }
                    GradientStop { position: 1.0; color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.10) }
                }
                border.width: 1
                border.color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.42)

                // Hover -> disconnect affordance (red glass, fades in).
                Rectangle {
                    anchors.fill: parent
                    radius: 15
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(0.82, 0.3, 0.3, 0.26) }
                        GradientStop { position: 1.0; color: Qt.rgba(0.82, 0.3, 0.3, 0.14) }
                    }
                    border.width: 1
                    border.color: Qt.rgba(0.92, 0.45, 0.45, 0.55)
                    opacity: mouseArea.containsMouse ? 1.0 : 0.0
                    Behavior on opacity {
                        NumberAnimation { duration: GlassTheme.durHover; easing.type: GlassTheme.easeStandard }
                    }
                }

                // Soft glow behind the pill (hover only).
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: -3
                    radius: 18
                    color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.12)
                    z: -1
                    opacity: mouseArea.containsMouse ? 1.0 : 0.0
                    Behavior on opacity {
                        NumberAnimation { duration: GlassTheme.durHover; easing.type: GlassTheme.easeStandard }
                    }
                }

                // Inner top catch-light.
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    anchors.topMargin: 1
                    height: 1
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
                        GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.10) }
                        GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0) }
                    }
                }

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        text: "󰁔"
                        font.family: GlassTheme.iconFont
                        font.pixelSize: 11
                        color: mouseArea.containsMouse ? Qt.rgba(1, 0.62, 0.62, 1) : root.accentColor
                        Behavior on color {
                            ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard }
                        }
                    }

                    Text {
                        text: "Connected"
                        font.family: GlassTheme.fontFamily
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        color: mouseArea.containsMouse ? Qt.rgba(1, 0.66, 0.66, 1) : root.accentColor
                        Behavior on color {
                            ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard }
                        }
                    }
                }

                Behavior on opacity {
                    NumberAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
                }
                Behavior on scale {
                    NumberAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
                }
            }

            // Connect button (inactive rows, crossfades out when connected)
            Rectangle {
                anchors.centerIn: parent
                width: 30
                height: 30
                radius: 15
                opacity: root.isActive ? 0.0 : 1.0
                scale: root.isActive ? 0.85 : 1.0
                color: mouseArea.containsMouse
                    ? Qt.rgba(root.interactiveColor.r, root.interactiveColor.g, root.interactiveColor.b, 0.22)
                    : "transparent"
                Behavior on color {
                    ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard }
                }
                Behavior on opacity {
                    NumberAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
                }
                Behavior on scale {
                    NumberAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
                }

                Text {
                    anchors.centerIn: parent
                    text: "󰌘"
                    font.family: GlassTheme.iconFont
                    font.pixelSize: 15
                    color: mouseArea.containsMouse ? root.interactiveColor : Qt.rgba(1, 1, 1, 0.72)
                    Behavior on color {
                        ColorAnimation { duration: GlassTheme.durFast; easing.type: GlassTheme.easeStandard }
                    }
                }
            }
        }
    }
    } // end card

    // --- Signal strength pulse ------------------------------------------------
    onStrengthLevelChanged: {
        if (root._prevLevel >= 0 && root._prevLevel !== root.strengthLevel) {
            pulseAnim.restart()
        }
        root._prevLevel = root.strengthLevel
    }

    SequentialAnimation {
        id: pulseAnim
        NumberAnimation { target: sigIcon; property: "scale"; to: 1.18; duration: 110; easing.type: Easing.OutQuad }
        NumberAnimation { target: sigIcon; property: "scale"; to: 1.0; duration: 200; easing.type: Easing.InOutQuad }
    }
}
