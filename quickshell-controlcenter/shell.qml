import Quickshell
import Quickshell.Io
import "services" as QsServices
import "modules/controlcenter"
import "modules/controlcenter/components"

ShellRoot {
    id: root

    readonly property var notifs: QsServices.Notifs
    readonly property string daemonPath: notifs.daemonPath

    // Control center window. Ephemeral: launched on demand from waybar/notify
    // daemon, and quits when closed (see ControlCenterWindow close handling).
    // Notification state lives in the standalone quickshell-notify daemon;
    // this window only renders the daemon's serialized snapshot.
    ControlCenterWindow {
        id: ccWindow
        shouldShow: false
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
