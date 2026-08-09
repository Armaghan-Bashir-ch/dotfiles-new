pragma Singleton

import QtQuick 6.10
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import "." as QsServices

// Notification state authority for the standalone notification daemon
// (quickshell-notify). Single source of truth: owns org.freedesktop.Notifications
// via NotificationServer, tracks all notification state, shows popup toasts and
// persists a JSON snapshot to ~/.cache/quickshell-notify-state.json so the
// ephemeral Control Center can render the same list without duplicating state.
//
// Event-driven throughout: notifications arrive over D-Bus and every mutation
// writes the state file (atomic writes). No polling timers.
Singleton {
    id: root

    // Use a JS array so Array helpers (filter/slice/etc) work reliably.
    property var notifications: []
    readonly property var activeNotifications: notifications.filter(n => !!n && !n.closed)

    // Maximum notifications to keep in memory (lowercase to comply with QML naming rules)
    readonly property int maxNotifications: 100

    // Show all notifications from past 24 hours (including closed ones)
    readonly property var recentNotifications: notifications.filter(n => {
        if (!n || !n.timestamp)
            return false
        const hoursSinceNotif = (new Date().getTime() - n.timestamp.getTime()) / (1000 * 60 * 60)
        return hoursSinceNotif < 24
    }).sort((a, b) => b.timestamp.getTime() - a.timestamp.getTime())
    readonly property var unreadNotifications: recentNotifications.filter(n => !n.read)
    readonly property int unreadCount: unreadNotifications.length

    property bool dnd: false
    property double lastReadAt: 0

    // True while the Control Center panel is open: its list shows the
    // notification live, so the daemon suppresses popup toasts (like swaync).
    // Pushed by the CC via `qs ipc call notifs setPanelOpen` on open/close.
    property bool panelOpen: false

    PersistentProperties {
        id: persist
        property alias dnd: root.dnd
        property alias lastReadAt: root.lastReadAt
        reloadableId: "notifications-state"
    }

    readonly property string statePath: {
        const home = Quickshell.env("HOME")
        return `${home}/.cache/quickshell-notify-state.json`
    }

    // State snapshot consumed by the Control Center. Written atomically on
    // every change (add/close/read/dnd/clear) - see persist().
    FileView {
        id: stateFile
        path: root.statePath
        atomicWrites: true
    }

    // Cleanup timer to prevent memory leaks
    Timer {
        interval: 3600000  // Clean up every hour
        repeat: true
        running: true
        triggeredOnStart: false

        onTriggered: {
            const oneDayAgo = new Date().getTime() - (24 * 60 * 60 * 1000)
            const oldCount = root.notifications.length
            root.notifications = root.notifications.filter(n => n && n.timestamp && n.timestamp.getTime() > oneDayAgo)
            const cleaned = oldCount - root.notifications.length
            if (cleaned > 0) {
                QsServices.Logger.debug("Notifs", `Cleaned up ${cleaned} old notifications`)
                root.persist()
            }
        }
    }

    // Serialize the current state so the Control Center can render it.
    // Only the fields the CC's NotificationCard consumes are exported.
    function serialize() {
        return JSON.stringify({
            dnd: root.dnd,
            unreadCount: root.unreadCount,
            notifications: root.notifications.map(n => ({
                id: n.notifId,
                summary: n.summary,
                body: n.body,
                appName: n.appName,
                appIcon: n.appIcon,
                image: n.image,
                urgency: n.urgency,
                timestamp: n.timestamp.getTime(),
                read: n.read,
                closed: n.closed,
                actions: (n.actions ?? []).map(a => ({ identifier: a.identifier, text: a.text }))
            }))
        })
    }

    // Write the JSON snapshot to disk (atomic). The CC watches this file via
    // FileView (watchChanges) and reloads on change - no polling involved.
    function persist() {
        stateFile.setText(root.serialize())
    }

    // Add notification from NotificationServer
    function addNotification(notif) {
        // Check DND mode
        if (dnd && notif.urgency !== NotificationUrgency.Critical) {
            QsServices.Logger.debug("Notifs", `DND active - suppressing: ${notif.summary}`)
            return;
        }

        QsServices.Logger.debug("Notifs", `Adding notification: ${notif.summary}`)

        const notifWrapper = notifComponent.createObject(root, {
            notification: notif
        })

        if (!notifWrapper) {
            QsServices.Logger.error("Notifs", "Failed to create notification wrapper")
            return
        }

        // Cap maximum notifications to prevent memory leaks
        var capped = [notifWrapper, ...root.notifications]
        var dropped = capped.slice(root.maxNotifications)
        for (var i = 0; i < dropped.length; i++) {
            if (dropped[i]) dropped[i].destroy()
        }
        root.notifications = capped.slice(0, root.maxNotifications)
        QsServices.Logger.debug("Notifs", `Total notifications: ${root.notifications.length}`)
        QsServices.Logger.debug("Notifs", `Queued: ${notifWrapper.appName ?? ""} ${notifWrapper.summary ?? ""}`)
        root.persist()
    }

    function markAllRead() {
        const stamp = Date.now()
        lastReadAt = stamp
        notifications.forEach(notification => {
            if (notification)
                notification.read = true
        })
        root.persist()
    }

    function _actionsToArray(actionList) {
        const out = []
        if (!actionList)
            return out

        const len = actionList.length ?? 0
        for (let i = 0; i < len; i++) {
            const a = actionList[i]
            if (!a)
                continue
            out.push({
                identifier: a.identifier,
                text: a.text,
                invoke: () => a.invoke()
            })
        }
        return out
    }

    // Toggle DND mode
    function toggleDnd() {
        dnd = !dnd;
        QsServices.Logger.info("Notifs", `DND mode: ${dnd ? "enabled" : "disabled"}`)
        root.persist()
    }

    // Set DND explicitly (used by Focus Mode / Gaming Mode from the CC)
    function setDnd(value) {
        if (dnd !== value) {
            dnd = value
            QsServices.Logger.info("Notifs", `DND mode: ${dnd ? "enabled" : "disabled"}`)
            root.persist()
        }
    }

    // Set panel-open state (pushed by the CC so popups are suppressed while
    // its list is showing the notification live)
    function setPanelOpen(value) {
        panelOpen = value
    }

    // Clear all notifications
    function clearAll() {
        notifications.forEach(n => n.close());
        markAllRead()
        QsServices.Logger.info("Notifs", "All notifications cleared")
    }

    // Clear notifications from specific app
    function clearApp(appName) {
        notifications.filter(n => n.appName === appName).forEach(n => n.close());
        QsServices.Logger.info("Notifs", `Cleared notifications from: ${appName}`)
    }

    // Close a single notification by id (called from the CC via IPC)
    function closeById(id) {
        const notif = notifications.find(n => n.notifId === id)
        if (notif) {
            notif.close()
            root.persist()
        }
    }

    // Invoke an action on a notification by id (called from the CC via IPC)
    function invokeActionById(id, actionId) {
        const notif = notifications.find(n => n.notifId === id)
        if (notif) {
            notif.invokeAction(actionId)
            root.persist()
        }
    }

    // Notification wrapper component
    component Notif: QtObject {
        id: notifWrapper

        property var notification
        property date timestamp: new Date()
        property bool closed: false
        property bool hasAnimated: false  // Track if popup animation has played
        property bool read: false

        // Notification properties
        property string notifId: ""
        property string summary: ""
        property string body: ""
        property string appName: ""
        property string appIcon: ""
        property string image: ""
        property int urgency: NotificationUrgency.Normal

        // Normalize the daemon's image URL into something Image.source can
        // load. Quickshell wraps an absolute `image-path` hint (notify-send
        // -i /path/to.png) as `image://icon//path/to.png`, but its icon image
        // provider only resolves theme-icon names - an absolute path in the
        // name slot makes it return the pink/black "missing icon" checkerboard
        // instead of the file. Unwrap it back to a plain path so the file is
        // loaded directly (this is also what the control center receives via
        // the serialized state). Theme-icon URLs and raw image-data handles
        // pass through untouched.
        function normalizeImage(src) {
            if (!src) return ""
            const prefix = "image://icon/"
            if (src.startsWith(prefix)) {
                const rest = src.slice(prefix.length)
                if (rest.startsWith("/")) return rest
            }
            return src
        }
        // Use a JS array so `.length`/indexing and helpers work reliably.
        property var actions: []

        // Time formatting
        readonly property string timeString: {
            const diff = new Date().getTime() - timestamp.getTime();
            const minutes = Math.floor(diff / 60000);
            const hours = Math.floor(minutes / 60);
            const days = Math.floor(hours / 24);

            if (days > 0) return days + "d ago";
            if (hours > 0) return hours + "h ago";
            if (minutes > 0) return minutes + "m ago";
            return "Just now";
        }

        // Connections to notification object
        readonly property Connections conn: Connections {
            target: notifWrapper.notification

            function onClosed() {
                notifWrapper.close();
            }

            function onSummaryChanged() {
                notifWrapper.summary = notifWrapper.notification.summary;
            }

            function onBodyChanged() {
                notifWrapper.body = notifWrapper.notification.body;
            }

            function onAppNameChanged() {
                notifWrapper.appName = notifWrapper.notification.appName;
            }

            function onAppIconChanged() {
                notifWrapper.appIcon = notifWrapper.notification.appIcon;
            }

            function onImageChanged() {
                notifWrapper.image = notifWrapper.normalizeImage(notifWrapper.notification.image);
            }

            function onUrgencyChanged() {
                notifWrapper.urgency = notifWrapper.notification.urgency;
            }

            function onActionsChanged() {
                notifWrapper.actions = root._actionsToArray(notifWrapper.notification.actions)
            }
        }

        function close() {
            if (closed) return;

            // Mark as closed but keep in history for notification center
            closed = true;

            // Only dismiss from the notification daemon, don't remove from list
            if (notification) {
                notification.dismiss();
            }

            QsServices.Logger.debug("Notifs", `Notification closed (kept in history): ${summary}`)
            root.persist()
        }

        function invokeAction(actionId) {
            const action = actions.find(a => a.identifier === actionId);
            if (action && action.invoke) {
                action.invoke();
            }
            root.persist()
        }

        Component.onCompleted: {
            if (!notification)
                return;

            notifId = `${notification.id}`
            summary = notification.summary
            body = notification.body
            appName = notification.appName
            appIcon = notification.appIcon
            image = normalizeImage(notification.image)
            urgency = notification.urgency
            actions = root._actionsToArray(notification.actions)
            read = timestamp.getTime() <= root.lastReadAt
        }
    }

    Component {
        id: notifComponent

        Notif {}
    }

    // Delete a specific notification (permanently remove from history)
    function deleteNotification(notif) {
        if (root.notifications.includes(notif)) {
            root.notifications = root.notifications.filter(n => n !== notif);
            if (notif.notification) {
                notif.notification.dismiss();
            }
            notif.destroy();
            QsServices.Logger.debug("Notifs", "Notification permanently deleted")
            root.persist()
        }
    }
}
