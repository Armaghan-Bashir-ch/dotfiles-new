// GlassTheme.qml - Liquid Glass design tokens for the network menu
// Centralized source of every duration, easing curve, radius and glass
// opacity used across the menu so the whole UI shares one visual language.

pragma Singleton

import QtQuick 6.10

QtObject {
    id: root

    // === Durations (ms) ===
    // Kept short so interactions feel immediate, never sluggish on old GPUs.
    readonly property int durInstant: 0
    readonly property int durFast: 120
    readonly property int durHover: 160
    readonly property int durNormal: 200
    readonly property int durSlow: 300
    readonly property int durSlower: 420

    // === Easing curves (QtQuick Easing enums) ===
    readonly property int easeStandard: Easing.OutCubic    // general UI motion
    readonly property int easeGentle: Easing.OutQuint      // entrances, decel
    readonly property int easeSharp: Easing.InOutQuad      // exits
    readonly property int easeSpring: Easing.OutBack       // subtle toggle/knob overshoot
    readonly property int easeLinear: Easing.Linear        // loops (spinners)

    // === Radii ===
    readonly property real radiusPanel: 22                 // outer menu surface
    readonly property real radiusCard: 18                  // dialogs / menus
    readonly property real radiusItem: 13                  // list rows, chips
    readonly property real radiusControl: 10               // buttons, fields
    readonly property real radiusFull: 9999                // pills, toggles

    // === Glass surface ===
    // fillOpacity is the alpha of the tinted frosted layer. Hyprland blurs the
    // desktop behind this window (see hyprland-glass.conf); ~0.6 keeps the
    // blur clearly visible while text stays readable.
    readonly property real glassFillOpacity: 0.60
    readonly property real glassDialogOpacity: 0.78        // more opaque dialogs
    readonly property real glassBorderOpacity: 0.14
    readonly property real glassSheenOpacity: 0.12         // faint top light falloff

    // === Border system (white alpha) ===
    // One consistent ladder: subtle resting surfaces, standard chrome, hover.
    // Accent borders for active states live with their component.
    readonly property real borderSubtle: 0.05
    readonly property real borderStandard: 0.12
    readonly property real borderHover: 0.22

    // === Drop shadow ===
    readonly property real shadowDepth: 10                 // outward spread px
    readonly property color shadowColor: Qt.rgba(0, 0, 0, 0.45)

    // === Interaction overlays (white alpha) ===
    readonly property real overlayHover: 0.07
    readonly property real overlayPressed: 0.13
    readonly property real overlayDisabled: 0.03

    // === Typography ===
    readonly property string fontFamily: "Inter"
    readonly property string iconFont: "Material Design Icons"

    // === Sizes ===
    readonly property real controlSize: 36                 // icon buttons
    readonly property real chipSize: 40                    // header icon chip
}
