// GlassTextField.qml - glass input field used for the network search box and
// the password dialog. Supports a leading icon, password echo mode and a
// smooth focus state: the border warms to the accent color while a soft halo
// blooms behind the field and the glass brightens.

import QtQuick 6.10
import QtQuick.Controls 6.10 as QQC

Item {
    id: root

    signal accepted()
    signal textEdited(string text)

    // Writable alias so callers can read AND clear the input (e.g. after a
    // password submit, or the search clear button).
    property alias text: field.text
    property string placeholderText: ""
    property string leadingIcon: ""
    property bool password: false
    property bool readOnly: false
    property bool enabled: true
    property color textColor: "white"
    property color accentColor: Qt.rgba(0.51, 0.72, 0.69, 1)

    implicitHeight: GlassTheme.controlSize

    readonly property bool activeFocusField: field.activeFocus

    // Programmatic focus (used by the password dialog on open).
    function forceFocus(): void {
        field.forceActiveFocus()
    }

    // Focus halo: a soft accent bloom just outside the field. Sits behind the
    // body so it reads as light bleeding around the focused glass.
    Rectangle {
        anchors.fill: parent
        anchors.margins: -1
        radius: GlassTheme.radiusControl + 1
        color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.22)
        opacity: field.activeFocus ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
        }
    }

    // Glass field body
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: GlassTheme.radiusControl
        color: Qt.rgba(1, 1, 1, field.activeFocus ? 0.12 : field.hovered ? 0.06 : 0.03)
        border.width: 1
        border.color: field.activeFocus
            ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.65)
            : Qt.rgba(1, 1, 1, field.hovered ? GlassTheme.borderHover : GlassTheme.borderStandard)

        // Slower than the default hover speed so focusing feels considered.
        Behavior on color {
            ColorAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
        }
        Behavior on border.color {
            ColorAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
        }

        // Faint top-down light falloff, matching the panel's glass sheen.
        Rectangle {
            anchors.fill: parent
            radius: GlassTheme.radiusControl
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.055) }
                GradientStop { position: 0.45; color: Qt.rgba(1, 1, 1, 0.02) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        // Top edge catch-light, echoing the panel rim highlight.
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            height: 1
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
                GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.10) }
                GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0) }
            }
        }
    }

    // Leading icon (search glyph / lock)
    Text {
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        visible: root.leadingIcon.length > 0
        text: root.leadingIcon
        font.family: GlassTheme.iconFont
        font.pixelSize: 14
        color: root.activeFocusField
            ? root.accentColor
            : Qt.rgba(1, 1, 1, 0.52)

        Behavior on color {
            ColorAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
        }
    }

    QQC.TextField {
        id: field
        anchors.fill: parent
        anchors.leftMargin: root.leadingIcon.length > 0 ? 38 : 14
        anchors.rightMargin: 14
        placeholderText: root.placeholderText
        placeholderTextColor: Qt.rgba(1, 1, 1, 0.52)
        echoMode: root.password ? QQC.TextField.Password : QQC.TextField.Normal
        readOnly: root.readOnly
        enabled: root.enabled
        selectByMouse: true
        color: root.textColor
        selectionColor: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.35)
        selectedTextColor: "#ffffff"
        background: Item {}
        font.family: GlassTheme.fontFamily
        font.pixelSize: 13
        verticalAlignment: Text.AlignVCenter

        onAccepted: root.accepted()
        onTextEdited: root.textEdited(text)
    }
}
