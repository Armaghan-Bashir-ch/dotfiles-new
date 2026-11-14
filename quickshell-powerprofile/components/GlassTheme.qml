pragma Singleton

import QtQuick 6.10

QtObject {
    readonly property int durInstant: 0
    readonly property int durFast: 120
    readonly property int durHover: 160
    readonly property int durNormal: 200
    readonly property int durSlow: 300
    readonly property int durSlower: 420

    readonly property int easeStandard: Easing.OutCubic
    readonly property int easeGentle: Easing.OutQuint
    readonly property int easeSharp: Easing.InOutQuad
    readonly property int easeSpring: Easing.OutBack
    readonly property int easeLinear: Easing.Linear

    readonly property real radiusPanel: 22
    readonly property real radiusCard: 18
    readonly property real radiusItem: 13
    readonly property real radiusControl: 10
    readonly property real radiusFull: 9999

    readonly property real glassFillOpacity: 0.60
    readonly property real glassDialogOpacity: 0.78
    readonly property real glassBorderOpacity: 0.14
    readonly property real glassSheenOpacity: 0.12

    readonly property real borderSubtle: 0.05
    readonly property real borderStandard: 0.12
    readonly property real borderHover: 0.22

    readonly property real shadowDepth: 10
    readonly property color shadowColor: Qt.rgba(0, 0, 0, 0.45)

    readonly property real overlayHover: 0.07
    readonly property real overlayPressed: 0.13
    readonly property real overlayDisabled: 0.03

    readonly property string fontFamily: "Inter"
    readonly property string iconFont: "Material Design Icons"
    readonly property real controlSize: 36
    readonly property real chipSize: 40
}
