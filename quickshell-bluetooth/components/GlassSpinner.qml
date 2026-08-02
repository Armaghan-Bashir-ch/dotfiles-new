// GlassSpinner.qml - thin arc loading indicator (liquid glass style).
//
// The arc is painted once onto a Canvas; RotationAnimator then rotates the
// canvas texture as a pure scene-graph transform (no repaint per frame), so
// it is nearly free on the GPU.

import QtQuick 6.10

Item {
    id: root

    property real size: 16
    property color color: "white"
    // Arc sweep in degrees - less than 360 makes the rotation visible.
    property real arcLength: 80

    implicitWidth: size
    implicitHeight: size

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            const line = Math.max(2, Math.round(width * 0.13))
            ctx.lineWidth = line
            ctx.lineCap = "round"
            ctx.strokeStyle = root.color
            ctx.beginPath()
            ctx.arc(width / 2, height / 2, Math.max(1, width / 2 - line),
                    0, root.arcLength * Math.PI / 180)
            ctx.stroke()
        }

        onWidthChanged: requestPaint()
    }

    // Repaint when the spinner's visual parameters change.
    onColorChanged: canvas.requestPaint()
    onArcLengthChanged: canvas.requestPaint()

    RotationAnimator {
        target: canvas
        from: 0
        to: 360
        duration: 900
        loops: Animation.Infinite
        running: root.visible
        easing.type: GlassTheme.easeLinear
    }
}
