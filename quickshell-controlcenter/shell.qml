import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import "services" as QsServices
import "modules/controlcenter"
import "modules/controlcenter/components"

ShellRoot {
    id: root

    readonly property var notifs: QsServices.Notifs

    // Own org.freedesktop.Notifications so the Control Center can display
    // real notification content. Event-driven: notifications arrive over
    // D-Bus and are pushed straight into QsServices.Notifs (no polling,
    // no swaync-client). NOTE: swaync must NOT be running as the daemon
    // (its exec-once was removed from hyprland.conf) or this server cannot
    // claim the well-known name.
    NotificationServer {
        keepOnReload: false
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        persistenceSupported: true

        onNotification: notif => {
            notif.tracked = true
            QsServices.Logger.debug("Notifs", `Received: ${notif.appName ?? ""} ${notif.summary ?? ""}`)
            notifs.addNotification(notif)
        }
    }

    // Control center window. Autostarted at login as the persistent
    // notification daemon, so it starts hidden and is opened/closed
    // externally via `qs ipc ... call controlcenter toggle`.
    ControlCenterWindow {
        id: ccWindow
        shouldShow: false
    }

    // Popup toasts: the same NotificationCard UI shown on screen when a
    // notification arrives, so notify-send is always visible even when the
    // control center panel is closed. Suppressed while the panel is open
    // (the list shows the notification live instead).
    NotificationPopup {
        notifs: root.notifs
        pywal: root.pywal
        panelOpen: ccWindow.shouldShow
        openControlCenter: () => { ccWindow.shouldShow = true }
    }

    // External control surface (quickshell IPC):
    //   qs ipc -p /home/armaghan/.config/quickshell-controlcenter call controlcenter toggle
    //   qs ipc -p /home/armaghan/.config/quickshell-controlcenter prop get controlcenter unreadCount
    // NOTE: the function is named `open` (not `show`) because `show` is a
    // reserved `qs ipc` subcommand and would be misparsed by the CLI.
    IpcHandler {
        target: "controlcenter"

        readonly property bool visible: ccWindow.shouldShow
        readonly property int unreadCount: notifs.unreadCount
        readonly property bool dnd: notifs.dnd

        function toggle() { ccWindow.shouldShow = !ccWindow.shouldShow }
        function open() { ccWindow.shouldShow = true }
        function hide() { ccWindow.shouldShow = false }
        function toggleDnd() { notifs.toggleDnd() }
    }
}
