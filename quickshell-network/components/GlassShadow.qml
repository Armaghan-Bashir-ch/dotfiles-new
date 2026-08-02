// GlassShadow.qml - soft drop shadow built from concentric rounded rectangles.
//
// Why not MultiEffect? On an Intel HD 4400 every `layer.effect` pass costs GPU
// fill-rate and, worse, re-renders whenever the source's content animates.
// Layered rounded rects are pure static alpha blending: one cheap draw per
// layer, zero offscreen passes, zero repaint cost on hover/list animations.
// With enough layers and a correct radius expansion (r_outer = r_inner + m)
// the result is a soft, natural-looking halo with a downward light bias.

import QtQuick 6.10

Item {
    id: root

    // Corner radius of the surface this shadow hugs.
    property real radius: 20
    // Shadow tint (alpha multiplied per layer).
    property color color: Qt.rgba(0, 0, 0, 0.45)
    // Total outward spread of the shadow in pixels.
    property real depth: 9
    // Downward bias: inner (darker) layers sit lower, faking a top-down light.
    property real offsetY: 2.5
    property int layerCount: 7

    anchors.fill: parent
    z: -1

    Repeater {
        model: root.layerCount

        Rectangle {
            required property int index

            readonly property real t: (index + 1) / root.layerCount // 1/count .. 1
    // Outward expansion for this layer, scaled with the corner radius
    // so curves stay concentric.
    readonly property real m: root.depth * t
    // Darker closer to the surface, fading outward. Deliberately faint: the
    // Hyprland rule for this namespace is `blur on, ignore_alpha 0.15`, which
    // treats pixels above 0.15 alpha as opaque and smears them into a solid
    // black border over dark wallpapers. Keeping the peak below 0.15 means the
    // compositor leaves the shadow alone and it composites as a soft halo.
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
