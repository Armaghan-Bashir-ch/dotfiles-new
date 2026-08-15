import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import "services" as QsServices
import "modules/notify"

ShellRoot {
    id: root

    readonly property var notifs: QsServices.Notifs
    readonly property string ccPath: "/home/armaghan/.config/quickshell-controlcenter"

    // Own org.freedesktop.Notifications so notifications are always received,
    // even while the Control Center is closed. Event-driven: notifications
    // arrive over D-Bus and are pushed into QsServices.Notifs, which persists
    // a JSON snapshot to ~/.cache/quickshell-notify-state.json for the CC.
    // NOTE: swaync must NOT be running as the daemon or this server cannot
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

    // Popup toasts: the same NotificationCard UI shown on screen when a
    // notification arrives, so notify-send is always visible even when the
    // control center panel is closed. Suppressed while the panel is open
    // (the CC pushes setPanelOpen(true) via IPC; the list shows the
    // notification live instead).
    NotificationPopup {
        notifs: root.notifs
        panelOpen: root.notifs.panelOpen
        pywal: QsServices.Pywal
        // Direct function reference (NOT a closure): the popup invokes this
        // via `root.openControlCenter()` from its own file scope, and an
        // arrow-function closure stored in a property var loses its id scope
        // (ReferenceError: root is not defined on popup click).
        openControlCenter: root.openControlCenter
    }

    // Launch (or focus) the Control Center. The CC is ephemeral: it quits on
    // close, so first try to open the running instance via IPC, otherwise
    // launch it fresh (no-duplicate guard) and open once it registers.
    Process {
        id: ccProcess
    }

    function openControlCenter() {
        ccProcess.exec(["/bin/bash", "-c",
            `qs ipc -p ${root.ccPath} call controlcenter open 2>/dev/null || { qs -n -p ${root.ccPath} >/dev/null 2>&1 & sleep 0.6; qs ipc -p ${root.ccPath} call controlcenter open 2>/dev/null; }`])
    }

    // External control surface (quickshell IPC):
    //   qs ipc -p /home/armaghan/.config/quickshell-notify call notifs toggleDnd
    //   qs ipc -p /home/armaghan/.config/quickshell-notify call notifs setDnd true
    //   qs ipc -p /home/armaghan/.config/quickshell-notify call notifs markAllRead
    //   qs ipc -p /home/armaghan/.config/quickshell-notify prop get notifs unreadCount
    //   qs ipc -p /home/armaghan/.config/quickshell-notify prop get notifs dnd
    IpcHandler {
        target: "notifs"

        readonly property int unreadCount: notifs.unreadCount
        readonly property bool dnd: notifs.dnd
        readonly property bool panelOpen: notifs.panelOpen

        function toggleDnd() { notifs.toggleDnd() }
        function setDnd(value: bool) { notifs.setDnd(value) }
        function markAllRead() { notifs.markAllRead() }
        function clearAll() { notifs.clearAll() }
        function clearApp(appName: string) { notifs.clearApp(appName) }
        function closeById(id: string) { notifs.closeById(id) }
        function invokeActionById(id: string, actionId: string) { notifs.invokeActionById(id, actionId) }
        function setPanelOpen(open: bool) { notifs.setPanelOpen(open) }
    }
}
