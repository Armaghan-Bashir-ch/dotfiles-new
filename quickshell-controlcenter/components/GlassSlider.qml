// GlassSlider.qml - liquid glass slider track + handle.
//
// Replaces the M3 slider visuals while keeping the exact same interaction
// semantics: dragging moves the handle, `onMoved` fires with the new value,
// and the handle morphs (grows) while pressed. The track is a recessed glass
// groove with an accent fill; the handle is a white glass knob with a soft
// shadow.

import QtQuick 6.10
import QtQuick.Layouts 6.10
import QtQuick.Controls 6.10 as QQC

Item {
    id: root

    signal moved(real value)

    property real from: 0
    property real to: 100
    property real value: 0
    property bool live: true
    property color accentColor: "#82b7b0"
    property color textColor: Qt.rgba(1, 1, 1, 0.9)
    property bool enabled: true

    implicitHeight: 64
    Layout.fillWidth: true

    QQC.Slider {
        id: slider
        anchors.fill: parent
        from: root.from
        to: root.to
        value: root.value
        live: root.live
        enabled: root.enabled
        onMoved: root.moved()

        // --- Recessed glass track -------------------------------------------
        background: Rectangle {
            x: slider.leftPadding; y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 200; implicitHeight: 8
            width: slider.availableWidth; height: implicitHeight
            radius: 4
            color: Qt.rgba(root.textColor.r, root.textColor.g, root.textColor.b, 0.08)

            // Inner top catch-light so it reads as a groove, not a flat bar.
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.leftMargin: 4
                anchors.rightMargin: 4
                height: 1
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
                    GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.10) }
                    GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0) }
                }
            }

            // Accent fill
            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                radius: 4
                color: root.accentColor
                opacity: 0.85
                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }

        // --- Glass handle (morphs while pressed) ----------------------------
        handle: Rectangle {
            id: handleKnob
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            property real targetHeight: slider.pressed ? 32 : 20
            width: 20
            height: targetHeight
            radius: width / 2
            color: "#ffffff"

            Behavior on height { NumberAnimation { duration: 200; easing.type: GlassTheme.easeStandard } }

            // Soft shadow under the knob.
            Rectangle {
                anchors.fill: parent
                anchors.margins: -1
                radius: width / 2
                color: Qt.rgba(0, 0, 0, 0.30)
                z: -1
                opacity: 0.5
            }

            // Thin accent rim so the knob reads on bright tracks.
            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: "transparent"
                border.width: 1
                border.color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.35)
            }
        }
    }
}
