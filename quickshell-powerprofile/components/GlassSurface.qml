import QtQuick 6.10

Item {
    id: root

    default property alias content: contentItem.data

    property real radius: GlassTheme.radiusPanel
    property color fillColor: Qt.rgba(0, 0, 0, 1)
    property real fillOpacity: GlassTheme.glassFillOpacity
    property real borderOpacity: GlassTheme.glassBorderOpacity
    property real sheenOpacity: GlassTheme.glassSheenOpacity
    property real shadowDepth: GlassTheme.shadowDepth
    property bool shadowVisible: true
    property bool clipContent: true

    readonly property color resolvedFill: Qt.rgba(fillColor.r, fillColor.g,
                                                  fillColor.b,
                                                  fillColor.a * fillOpacity)
    readonly property color borderColor: Qt.rgba(1, 1, 1, borderOpacity)

    implicitWidth: 340
    implicitHeight: 480

    GlassShadow {
        visible: root.shadowVisible
        radius: root.radius
        depth: root.shadowDepth
        color: GlassTheme.shadowColor
        anchors.fill: parent
        z: -1
    }

    Rectangle {
        id: surface
        anchors.fill: parent
        radius: root.radius
        color: root.resolvedFill
        antialiasing: true
        clip: root.clipContent

        Behavior on color {
            ColorAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
        }

        Rectangle {
            anchors.fill: parent
            radius: root.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, root.sheenOpacity) }
                GradientStop { position: 0.28; color: Qt.rgba(1, 1, 1, root.sheenOpacity * 0.45) }
                GradientStop { position: 0.62; color: Qt.rgba(1, 1, 1, root.sheenOpacity * 0.12) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: root.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.82; color: "transparent" }
                GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.045) }
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: root.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.88; color: "transparent" }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.05) }
            }
        }

        Item {
            id: contentItem
            anchors.fill: parent
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: "transparent"
        border.width: 2
        border.color: root.borderColor
        antialiasing: true

        Behavior on border.color {
            ColorAnimation { duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
        }
    }
}
