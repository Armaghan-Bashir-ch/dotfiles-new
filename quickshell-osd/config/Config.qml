pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import "../services" as QsServices

Singleton {
    id: root

    Component.onCompleted: file.reload()

    property var data: ({})

    function _expandHome(p) {
        if (!p || typeof p !== "string") return p
        if (p.startsWith("~/")) return `${Quickshell.env("HOME")}/${p.slice(2)}`
        return p
    }

    readonly property var appearance: ({
        fontFamily: data.appearance?.fontFamily ?? "Inter",
        materialIconFont: data.appearance?.materialIconFont ?? "Material Design Icons"
    })

    readonly property var paths: ({
        pywalColors: _expandHome(data.paths?.pywalColors ?? "~/.cache/wal/colors.json"),
        screenshotsDir: _expandHome(data.paths?.screenshotsDir ?? "~/Pictures/Screenshots")
    })

    readonly property var osd: ({
        volumeTimeoutMs: data.osd?.volumeTimeoutMs ?? 1000,
        brightnessTimeoutMs: data.osd?.brightnessTimeoutMs ?? 2000
    })

    FileView {
        id: file
        path: {
            const home = Quickshell.env("HOME")
            const xdg = Quickshell.env("XDG_CONFIG_HOME")
            const cfgHome = (xdg && xdg.length > 0) ? xdg : `${home}/.config`
            return `${cfgHome}/quickshell-osd/shell.json`
        }
        watchChanges: true

        onLoaded: {
            try {
                const parsed = JSON.parse(text())
                root.data = parsed
                QsServices.Logger.debug("Config", "shell.json loaded")
            } catch (e) {
                QsServices.Logger.warn("Config", `Failed to parse shell.json: ${e?.message ?? e}`)
            }
        }

        onFileChanged: {
            file.reload()
        }

        onLoadFailed: err => {
            if (err !== FileViewError.FileNotFound)
                QsServices.Logger.warn("Config", `Failed to read shell.json: ${FileViewError.toString(err)}`)
        }
    }

}
