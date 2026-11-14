import QtQuick 6.10

Item {
    id: root

    property real radius: 20
    property color color: Qt.rgba(0, 0, 0, 0.45)
    property real depth: 9
    property real offsetY: 2.5
    property int layerCount: 7

    anchors.fill: parent
    z: -1

    Repeater {
        model: root.layerCount

        Rectangle {
            required property int index

            readonly property real t: (index + 1) / root.layerCount
            readonly property real m: root.depth * t
            readonly property real layerAlpha: 0.08 * t

            anchors.fill: parent
            anchors.margins: -m
            anchors.topMargin: -m + root.offsetY * (1 - t)
            radius: root.radius + m
            color: Qt.rgba(root.color.r, root.color.g, root.color.b,
                           root.color.a * layerAlpha)
        }
    }
}
