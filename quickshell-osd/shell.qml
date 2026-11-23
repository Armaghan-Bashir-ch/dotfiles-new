//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QSG_RENDER_LOOP=threaded
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import Quickshell
import QtQuick 6.10
import "services" as QsServices
import "modules/osd"
import "modules"

ShellRoot {
    id: root
    
    readonly property var pywal: QsServices.Pywal

    // OSD overlays (volume and brightness)
    Wrapper {
        pywal: root.pywal
    }

    BatteryMonitor {}

    Component.onCompleted: {
        QsServices.Logger.info("Shell", "Loaded")
    }
}
