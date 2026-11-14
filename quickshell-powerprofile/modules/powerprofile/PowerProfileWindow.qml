import QtQuick 6.10
import Quickshell
import Quickshell.Wayland
import "../../services" as QsServices

PanelWindow {
    id: root

    property var pywal: null
    property string fontFamily: "Inter"
    property string iconFont: "Material Design Icons Desktop"
    property bool shouldShow: true
    property bool closing: false

    screen: Quickshell.screens[0]

    anchors {
        top: true
        left: true
    }

    margins {
        top: 0
        left: 150
    }

    implicitWidth: panel.implicitWidth + 44
    implicitHeight: panel.implicitHeight + 44
    color: "transparent"
    visible: root.shouldShow || root.closing

    WlrLayershell.namespace: "quickshell:powerprofile"
    WlrLayershell.keyboardFocus:
        root.shouldShow ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

    PowerProfilePanel {
        id: panel
        anchors.fill: parent
        anchors.margins: 22
        pywal: root.pywal
        fontFamily: root.fontFamily
        iconFont: root.iconFont

        onCloseRequested: root.closeAnimated()
    }

    Connections {
        target: QsServices.PowerProfiles

        function onDaemonStopped() {
            root.closeAnimated()
        }
    }

    function closeAnimated() {
        if (root.closing || !root.shouldShow) return

        root.closing = true
        closeAnimation.start()
    }

    onShouldShowChanged: {
        if (!root.shouldShow) {
            quitTimer.restart()
            return
        }

        root.closing = false
        panel.opacity = 0
        panel.scale = 0.94
        openAnimation.start()
    }

    Component.onCompleted: Qt.callLater(() => {
        panel.opacity = 0
        panel.scale = 0.94
        openAnimation.start()
    })

    Timer {
        id: quitTimer
        interval: 220
        onTriggered: Qt.quit()
    }

    ParallelAnimation {
        id: openAnimation

        NumberAnimation {
            target: panel
            property: "opacity"
            to: 1
            duration: 180
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: panel
            property: "scale"
            to: 1
            duration: 220
            easing.type: Easing.OutCubic
        }
    }

    ParallelAnimation {
        id: closeAnimation

        NumberAnimation {
            target: panel
            property: "opacity"
            to: 0
            duration: 150
            easing.type: Easing.InCubic
        }

        NumberAnimation {
            target: panel
            property: "scale"
            to: 0.97
            duration: 150
            easing.type: Easing.InCubic
        }

        onFinished: {
            root.closing = false
            root.shouldShow = false
        }
    }
}
