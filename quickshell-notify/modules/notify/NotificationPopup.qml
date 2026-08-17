import QtQuick 6.10
import QtQuick.Layouts 6.10
import QtQuick.Controls 6.10
import Quickshell
import Quickshell.Wayland
import "../../components"
import "../../config" as QsConfig

// Notification popup toasts: shown by the notification daemon (this config)
// whenever a notification arrives, using the exact same NotificationCard UI
// as the control center list. Stored notifications are still shown in the
// control center when it is opened.
PanelWindow {
    id: root

    property var notifs: null
    property var pywal: null

    // True while the control center panel is open - then the list already
    // shows the notification live, so popups are suppressed (like swaync).
    property bool panelOpen: false

    // Called when a popup is clicked; opens the control center to the list.
    property var openControlCenter: null

    // M3 color tokens, mirrored from the control center window.
    readonly property color cSurface: pywal?.surface ?? "#14141a"
    readonly property color cPrimary: pywal?.primary ?? "#88cc88"
    readonly property color cOnSurface: pywal?.foreground ?? "#e6e6e6"
    readonly property color cOnSurfaceVariant: pywal?.onSurfaceMuted ?? "#9a9a9a"
    readonly property color cError: pywal?.error ?? "#ff4444"

    // --- Content-driven sizing -------------------------------------------------
    // The card grows/shrinks with the widest line of text so a one-word
    // notification stays compact while long messages expand (up to maxWidth).
    readonly property string fontFamily: QsConfig.Config.appearance.fontFamily ?? "Inter"
    readonly property int minWidth: 280
    readonly property int maxWidth: 400
    // Fixed chrome: card margins 24 + icon 36 + header spacings 20 + close 26 + timestamp reserve 50
    readonly property int chrome: 156

    FontMetrics { id: fmSummary; font.family: root.fontFamily; font.pixelSize: 13; font.weight: Font.DemiBold }
    FontMetrics { id: fmApp; font.family: root.fontFamily; font.pixelSize: 11 }
    FontMetrics { id: fmBody; font.family: root.fontFamily; font.pixelSize: 12 }

    function cardWidth(wrapper) {
        const summary = wrapper?.summary ?? "Notification"
        const body = wrapper?.body ?? ""
        const app = wrapper?.appName ?? ""
        const widest = Math.max(fmSummary.advanceWidth(summary),
                                fmApp.advanceWidth(app),
                                fmBody.advanceWidth(body))
        return Math.min(root.maxWidth, Math.max(root.minWidth, Math.ceil(widest + root.chrome)))
    }

    // Window width = widest popup currently stacked (or minWidth when empty).
    readonly property int windowWidth: {
        let w = root.minWidth
        for (const p of root.popups) w = Math.max(w, root.cardWidth(p))
        return w
    }

    // Wrappers currently shown as popups (newest first, max 3).
    property var popups: []
    property var _lastPopped: null

    readonly property int normalTimeout: 2500
    readonly property int criticalTimeout: 9000

    screen: Quickshell.screens[0]
    anchors { top: true; right: true }
    margins { right: 12; top: 12 }
    implicitWidth: windowWidth
    implicitHeight: popupColumn.height
    color: "transparent"
    visible: popups.length > 0

    WlrLayershell.namespace: "quickshell:notifpopup"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.exclusiveZone: 0

    function enqueue(wrapper) {
        popups = [wrapper].concat(popups.filter(p => p !== wrapper)).slice(0, 3)
        _lastPopped = wrapper
    }

    function removePopup(wrapper) {
        popups = popups.filter(p => p !== wrapper)
    }

    Connections {
        target: root.notifs
        function onNotificationsChanged() {
            if (!root.notifs) return

            // Drop popups whose notification was closed or cleared.
            const active = root.notifs.activeNotifications
            for (const p of root.popups) {
                if (p.closed || !active.includes(p)) root.removePopup(p)
            }

            // Pop the newest arrival (if any). The service already suppresses
            // non-critical notifications while DND is on.
            const list = root.notifs.notifications
            if (list.length === 0) return
            const newest = list[0]
            if (newest === root._lastPopped) return
            if (root.panelOpen) return
            if (root.notifs.dnd && newest.urgency !== 2) return
            root.enqueue(newest)
        }
    }

    ColumnLayout {
        id: popupColumn
        anchors.top: parent.top
        anchors.right: parent.right
        width: root.windowWidth
        spacing: 8

        Repeater {
            model: root.popups

            delegate: Rectangle {
                required property var modelData

                Layout.preferredWidth: root.cardWidth(modelData)
                Layout.alignment: Qt.AlignRight
                height: popupContent.implicitHeight + 24
                radius: 20
                // Same glass recipe as the control center panel (see
                // ControlCenterWindow.qml): dark pywal surface at 0.2 alpha,
                // which sits above hyprland's `blur on, ignore_alpha 0.15`
                // layerrule so the blur actually kicks in and it reads glassy.
                // The border is tinted with the notification's category accent
                // (green success / purple system / amber download) so the
                // accent reads through without flooding the surface.
                color: popupMouse.containsMouse
                    ? Qt.rgba(root.cSurface.r, root.cSurface.g, root.cSurface.b, 0.25)
                    : Qt.rgba(root.cSurface.r, root.cSurface.g, root.cSurface.b, 0.2)
                border.width: 1
                border.color: {
                    const accent = modelData?.accentColor ?? root.cPrimary
                    const a = popupMouse.containsMouse ? 0.40 : 0.28
                    return Qt.rgba(accent.r, accent.g, accent.b, a)
                }
                Behavior on color { ColorAnimation { duration: 150 } }
                Behavior on border.color { ColorAnimation { duration: 150 } }

                // Experimental accent wash: faint category-accent tint over
                // the glass on EVERY card (blue default, green screenshot,
                // purple system, amber download, red critical) so the whole
                // stack carries its color, not just the thin border. Sits
                // behind the card content - popupContent is the last child
                // and paints above it.
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: {
                        const accent = modelData?.accentColor ?? root.cPrimary
                        return Qt.rgba(accent.r, accent.g, accent.b, 0.05)
                    }
                }

                // Subtle top accent line - a faint indicator, not a fill.
                Rectangle {
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        topMargin: 1
                        leftMargin: 24
                        rightMargin: 24
                    }
                    height: 2
                    radius: 1
                    visible: modelData?.category && modelData.category !== "default"
                    color: {
                        const accent = modelData?.accentColor ?? root.cPrimary
                        return Qt.rgba(accent.r, accent.g, accent.b, 0.45)
                    }
                }

                // Entrance animation
                scale: 0.94
                opacity: 0
                Behavior on scale { NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
                Behavior on opacity { NumberAnimation { duration: 200 } }
                Component.onCompleted: { scale = 1.0; opacity = 1.0 }

                // Auto-dismiss (paused while hovered). Critical lasts longer.
                Timer {
                    id: dismissTimer
                    interval: modelData.urgency === 2 ? root.criticalTimeout : root.normalTimeout
                    running: true
                    onTriggered: root.removePopup(modelData)
                }

                // Remove from the popup stack as soon as the notification closes
                // (close button, app dismissal, or clearing from the list).
                Connections {
                    target: modelData
                    function onClosedChanged() {
                        if (modelData.closed) root.removePopup(modelData)
                    }
                }

                MouseArea {
                    id: popupMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: dismissTimer.stop()
                    onExited: dismissTimer.restart()
                    onClicked: {
                        root.removePopup(modelData)
                        if (root.openControlCenter) root.openControlCenter()
                    }
                }

                NotificationCard {
                    id: popupContent
                    anchors.fill: parent
                    anchors.margins: 12
                    notification: modelData
                    pywal: root.pywal
                    showCloseButton: true
                    showTimestamp: true
                    showActions: false
                    showBody: true
                    showAppIcon: true

                    primaryColor: root.cPrimary
                    onSurfaceColor: root.cOnSurface
                    onSurfaceVariantColor: root.cOnSurfaceVariant
                    errorColor: root.cError
                    surfaceContainerHighColor: Qt.rgba(root.cOnSurface.r, root.cOnSurface.g, root.cOnSurface.b, 0.08)
                }
            }
        }
    }
}
