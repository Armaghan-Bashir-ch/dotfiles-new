pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import "../services" as QsServices

// Trimmed config for the notification daemon. Reads the same shared
// ~/.config/quickshell/shell.json as the main shell so the popup toasts
// keep the exact same font family as the rest of the desktop.
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
        // The installed MDI font registers its family as "Material Design Icons
        // Desktop"; the bare "Material Design Icons" name matches nothing and
        // silently falls back, so icon codepoints render as garbage glyphs.
        materialIconFont: data.appearance?.materialIconFont ?? "Material Design Icons Desktop",
        // Nerd Font for app-name glyph overrides (e.g. Hyprland's nf glyph),
        // which do not exist in Material Design Icons.
        nerdFontFamily: "CaskaydiaCove Nerd Font"
    })

    readonly property var paths: ({
        pywalColors: _expandHome(data.paths?.pywalColors ?? "~/.cache/wal/colors.json")
    })

    readonly property var notifications: ({
        popupWidth: data.notifications?.popupWidth ?? 340,
        maxVisible: data.notifications?.maxVisible ?? 5,
        timeoutMs: data.notifications?.timeoutMs ?? 7000,
        spacing: data.notifications?.spacing ?? 8,
        margin: data.notifications?.margin ?? 8
    })

    FileView {
        id: file
        path: {
            const home = Quickshell.env("HOME")
            const xdg = Quickshell.env("XDG_CONFIG_HOME")
            const cfgHome = (xdg && xdg.length > 0) ? xdg : `${home}/.config`
            return `${cfgHome}/quickshell/shell.json`
        }
        watchChanges: true

        onLoaded: {
            try {
                const parsed = JSON.parse(text())
                root.data = parsed
                QsServices.Logger.debug("Config", "shell.json loaded")
            } catch (e) {
                QsServices.Logger.error("Config", `Failed to parse shell.json: ${e?.message ?? e}`)
            }
        }

        onFileChanged: reload()

        onLoadFailed: err => {
            if (err !== FileViewError.FileNotFound)
                QsServices.Logger.warn("Config", `Failed to read shell.json: ${FileViewError.toString(err)}`)
        }
    }
}
