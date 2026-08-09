pragma Singleton

import QtQuick 6.10
import Quickshell
import Quickshell.Io
import "." as QsServices

// Thin IPC client mirroring the notification authority living in the
// standalone quickshell-notify daemon. This Control Center process no longer
// owns org.freedesktop.Notifications; instead it:
//
//   1. Watches ~/.cache/quickshell-notify-state.json (written atomically by
//      the daemon on every change) via FileView + watchChanges, and rebuilds
//      its notification list from that snapshot - the serialized form of the
//      authoritative state, not a second copy.
//   2. Forwards every mutation (dismiss, action, DND, clear) to the daemon
//      via `qs ipc -p ~/.config/quickshell-notify call notifs <fn> ...`.
//
// Fully event-driven: the FileView fires on file change (no polling), and
// IPC calls happen only on explicit user action.
Singleton {
    id: root

    // Keep the exact API surface the Control Center UI consumes, so
    // NotificationList/NotificationCard/GamingMode need no changes beyond the
    // dnd write path (see setDnd below).
    property var notifications: []
    readonly property var activeNotifications: notifications.filter(n => !!n && !n.closed)

    readonly property int maxNotifications: 100

    readonly property var recentNotifications: notifications.filter(n => {
        if (!n || !n.timestamp)
            return false
        const hoursSinceNotif = (new Date().getTime() - n.timestamp.getTime()) / (1000 * 60 * 60)
        return hoursSinceNotif < 24
    }).sort((a, b) => b.timestamp.getTime() - a.timestamp.getTime())
    readonly property var unreadNotifications: recentNotifications.filter(n => !n.read)
    readonly property int unreadCount: unreadNotifications.length

    readonly property var groupedNotifications: {
        const groups = {}
        const active = activeNotifications
        for (let i = 0; i < active.length; i++) {
            const n = active[i]
            const key = n.appName || "Unknown"
            if (!groups[key]) {
                groups[key] = []
            }
            groups[key].push(n)
        }
        return groups
    }

    readonly property var notificationCounts: {
        const counts = {}
        const grouped = groupedNotifications
        for (let app in grouped) {
            counts[app] = grouped[app].length
        }
        return counts
    }

    property bool dnd: false
    property double lastReadAt: 0

    readonly property string daemonPath: {
        const home = Quickshell.env("HOME")
        return `${home}/.config/quickshell-notify`
    }

    readonly property string statePath: {
        const home = Quickshell.env("HOME")
        return `${home}/.cache/quickshell-notify-state.json`
    }

    // True while applying a state-file snapshot, so writes from the daemon
    // don't loop back into IPC calls.
    property bool _applyingState: false

    onDndChanged: {
        if (root._applyingState)
            return
        // Any `notifs.dnd = x` write (Focus/Gaming Mode) must reach the daemon.
        root._ipc("setDnd", root.dnd ? "true" : "false")
    }

    // State snapshot from the daemon, watched for changes. Written by the
    // daemon's FileView (atomicWrites) on every mutation.
    FileView {
        id: stateFile
        path: root.statePath
        watchChanges: true

        onLoaded: root._applyState(text())
        onFileChanged: reload()
        onLoadFailed: err => {
            // File simply doesn't exist yet (daemon not started / no
            // notifications). Keep the empty list; the watch stays armed.
            if (err !== FileViewError.FileNotFound)
                QsServices.Logger.warn("Notifs", `State file error: ${FileViewError.toString(err)}`)
        }
    }

    // Forward a mutation to the notification daemon.
    function _ipc(...args) {
        ipcProcess.exec(["qs", "ipc", "-p", root.daemonPath, "call", "notifs", ...args])
    }

    Process {
        id: ipcProcess
    }

    // Rebuild the notification list from the daemon's serialized state.
    function _applyState(raw) {
        if (!raw || raw.length === 0) {
            root.notifications = []
            root.dnd = false
            return
        }

        let parsed
        try {
            parsed = JSON.parse(raw)
        } catch (e) {
            QsServices.Logger.error("Notifs", `Failed to parse state file: ${e?.message ?? e}`)
            return
        }

        root._applyingState = true
        root.dnd = parsed.dnd === true

        const rebuilt = []
        const list = parsed.notifications ?? []
        for (let i = 0; i < list.length; i++) {
            const s = list[i]
            if (!s)
                continue
            const n = {
                notifId: s.id ?? "",
                summary: s.summary ?? "",
                body: s.body ?? "",
                appName: s.appName ?? "",
                appIcon: s.appIcon ?? "",
                image: s.image ?? "",
                urgency: s.urgency ?? 1,
                timestamp: new Date(s.timestamp ?? Date.now()),
                read: s.read === true,
                closed: s.closed === true,
                hasAnimated: false,
                // Rebuilt actions: only identifier/text survive serialization;
                // invoking routes through IPC back to the daemon.
                actions: (s.actions ?? []).map(a => ({
                    identifier: a.identifier,
                    text: a.text,
                    invoke: () => root._invokeAction(s.id ?? "", a.identifier)
                })),
                timeString: root._timeString(new Date(s.timestamp ?? Date.now())),
                close: () => root._close(s.id ?? ""),
                invokeAction: (actionId) => root._invokeAction(s.id ?? "", actionId)
            }
            rebuilt.push(n)
        }

        root.notifications = rebuilt
        root._applyingState = false
    }

    // Relative time label, mirroring the daemon's wrapper.
    function _timeString(timestamp) {
        const diff = new Date().getTime() - timestamp.getTime()
        const minutes = Math.floor(diff / 60000)
        const hours = Math.floor(minutes / 60)
        const days = Math.floor(hours / 24)
        if (days > 0) return days + "d ago"
        if (hours > 0) return hours + "h ago"
        if (minutes > 0) return minutes + "m ago"
        return "Just now"
    }

    function _close(id) {
        root._ipc("closeById", id)
    }

    function _invokeAction(id, actionId) {
        root._ipc("invokeActionById", id, actionId)
    }

    function markAllRead() {
        root._ipc("markAllRead")
    }

    function toggleDnd() {
        root._ipc("toggleDnd")
    }

    // Set DND explicitly (Focus Mode / Gaming Mode).
    function setDnd(value) {
        root._ipc("setDnd", value ? "true" : "false")
    }

    // Push our open/closed state so the daemon suppresses popup toasts while
    // the list shows the notification live.
    function setPanelOpen(open) {
        root._ipc("setPanelOpen", open ? "true" : "false")
    }

    function clearAll() {
        root._ipc("clearAll")
    }

    function clearApp(appName) {
        root._ipc("clearApp", appName)
    }

    function deleteNotification(notif) {
        if (notif?.notifId)
            root._ipc("closeById", notif.notifId)
    }
}
