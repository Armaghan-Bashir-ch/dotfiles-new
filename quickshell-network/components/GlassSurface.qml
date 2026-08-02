// GlassSurface.qml - the core frosted-glass surface.
//
// Composed (bottom to top):
//   1. GlassShadow      - cheap layered drop shadow
//   2. Tinted fill      - semi-transparent pywal-derived color; Hyprland blurs
//                         the desktop behind it (compositor-side blur, free GPU)
//   3. Sheen overlay    - faint top-down light falloff (static gradient)
//   4. Content          - clipped to the rounded corners
//   5. Light border     - thin 1px white rim (glass edge)
//
// Everything except the drop shadow is a child of the clipped surface so the
// rounded corners never show artifacts.

import QtQuick 6.10

Item {
    id: root

    default property alias content: contentItem.data

    // Corner radius of the whole surface.
    property real radius: GlassTheme.radiusPanel
    // Base tint. Pass a pywal color; alpha is controlled by fillOpacity.
    property color fillColor: Qt.rgba(0, 0, 0, 1)
    property real fillOpacity: GlassTheme.glassFillOpacity
    property real borderOpacity: GlassTheme.glassBorderOpacity
    property real sheenOpacity: GlassTheme.glassSheenOpacity
    property real shadowDepth: GlassTheme.shadowDepth
    property bool shadowVisible: true
    property bool clipContent: true

    // Effective fill: tint color multiplied by fillOpacity.
    readonly property color resolvedFill: Qt.rgba(fillColor.r, fillColor.g,
                                                  fillColor.b,
                                                  fillColor.a * fillOpacity)
    readonly property color borderColor: Qt.rgba(1, 1, 1, borderOpacity)

    implicitWidth: 340
    implicitHeight: 480

    // --- Drop shadow -------------------------------------------------------
    GlassShadow {
        visible: root.shadowVisible
        radius: root.radius
        depth: root.shadowDepth
        color: GlassTheme.shadowColor
        anchors.fill: parent
        z: -1
    }

    // --- Tinted glass body -------------------------------------------------
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

        // Faint top-down light falloff (liquid glass sheen). Static gradient,
        // rasterized once - no per-frame cost. Four stops give a smoother,
        // longer light diffusion than the previous three-stop ramp.
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

        // Bottom internal reflection: a whisper of light caught by the lower
        // edge of the slab. Fades upward so the panel keeps its depth without
        // looking milky or flat.
        Rectangle {
            anchors.fill: parent
            radius: root.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.82; color: "transparent" }
                GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.045) }
            }
        }

        // Subtle bottom vignette for depth (glass thickness illusion).
        Rectangle {
            anchors.fill: parent
            radius: root.radius
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.88; color: "transparent" }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.05) }
            }
        }

        // Content, clipped to the rounded shape.
        Item {
            id: contentItem
            anchors.fill: parent
        }
    }

    // --- 1px glass rim (light border) --------------------------------------
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
