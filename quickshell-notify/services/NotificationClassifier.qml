pragma Singleton

import QtQuick
import Quickshell

// Pure classification logic for incoming notifications.
//
// The daemon receives arbitrary notifications over D-Bus. This singleton turns
// the raw metadata (app name, desktop entry, summary, body, icon/image, hints)
// into a small set of semantic categories the UI can render contextually:
//
//   screenshot  -> green success treatment, image preview, Open / Copy path
//   system      -> purple Hyprland/system treatment, brand logo on the right
//   download    -> amber download treatment, progress / completion indicator
//   success     -> green success treatment for completed actions
//   default     -> normal appearance, no contextual chrome
//
// New categories can be added by extending `classify()` and giving the card a
// matching presentation branch. Known apps/tools are kept in the small mapping
// tables below instead of scattering hardcoded checks through the UI.
Singleton {
    id: root

    // ── Known application/tool mappings ──────────────────────────────────────
    // Keys match either the notification `appName` or its `desktop-entry` hint.

    // Screenshot tools that announce a saved capture with the image embedded.
    readonly property var screenshotApps: [
        "hyprshot", "grim", "slurp", "flameshot", "spectacle",
        "gnome-screenshot", "screenshot", "hyprpicker-screenshot"
    ]

    // Hyprland components / system-level services (branded purple).
    readonly property var systemApps: [
        "hyprland", "hyprlock", "hypridle", "hyprpaper", "hyprpicker",
        "hyprcursor", "systemd", "polkit", "polkit-kde-agent", "uwsm", "sway"
    ]

    // Download-capable applications (browsers, download managers, torrents).
    readonly property var downloadApps: [
        "firefox", "zen-browser", "zen", "chromium", "chrome", "google-chrome",
        "brave-browser", "brave", "vivaldi", "microsoft-edge", "edge", "opera",
        "thunderbird", "transmission", "transmission-gtk", "qbittorrent",
        "deluge", "ktorrent", "wget", "curl", "uget", "aria2", "dwb", "motrix"
    ]

    // File extensions that read as "a file was downloaded".
    readonly property var fileExtensions: [
        "zip", "tar", "gz", "bz2", "xz", "7z", "rar", "deb", "rpm", "apk",
        "iso", "dmg", "exe", "msi", "png", "jpg", "jpeg", "webp", "gif",
        "mp4", "mkv", "mov", "mp3", "flac", "pdf", "doc", "docx", "xls",
        "xlsx", "ppt", "pptx", "txt", "nix", "pkg.tar.zst", "pkg.tar.xz"
    ]

    // ── Classification ───────────────────────────────────────────────────────

    // Order matters: the first matching rule wins.
    function classify(appName, desktopEntry, summary, body, appIcon, image, hints) {
        const app = (appName ?? "").trim().toLowerCase()
        const entry = (desktopEntry ?? "").trim().toLowerCase()
        const summaryText = summary ?? ""
        const bodyText = body ?? ""
        const text = `${summaryText} ${bodyText}`.toLowerCase()
        const iconFile = root.localImagePath(appIcon) || root.localImagePath(image)

        // 1. Screenshots — known capture tools, or explicit screenshot wording
        //    together with an embedded image file (the captured PNG).
        if (root.screenshotApps.includes(app) || root.screenshotApps.includes(entry))
            return "screenshot"
        if (text.includes("screenshot") && iconFile)
            return "screenshot"
        if (text.includes("saved and copied to the clipboard") && iconFile)
            return "screenshot"

        // 2. Hyprland / system-level messages (branded purple).
        if (root.systemApps.includes(app) || root.systemApps.includes(entry))
            return "system"
        if (text.includes("hyprland"))
            return "system"
        if ((appIcon ?? "").toLowerCase().includes("hyprland"))
            return "system"

        // 3. Downloads — known download-capable apps, or download wording with
        //    file-info in the body, or an explicit progress hint.
        const isDownloadApp = root.downloadApps.includes(app) || root.downloadApps.includes(entry)
        const hasProgress = root.extractProgress(hints) >= 0
        if (isDownloadApp && (root._matchesDownloadWording(summaryText, bodyText) || hasProgress))
            return "download"
        if (root._matchesDownloadWording(summaryText, bodyText) && root._looksLikeFileInfo(bodyText))
            return "download"

        // 4. Success — completed/positive actions (green).
        if (root._matchesSuccessWording(text))
            return "success"

        return "default"
    }

    // True when the string refers to a real local image file (an absolute path,
    // not a theme-icon name). Used to detect embedded screenshot/preview files.
    function localImagePath(url) {
        if (!url) return ""
        let p = String(url)
        const prefix = "image://icon/"
        if (p.startsWith(prefix)) {
            const rest = p.slice(prefix.length)
            if (!rest.startsWith("/")) return "" // theme-icon name, not a file
            p = rest
        }
        if (p.startsWith("file://")) p = p.slice("file://".length)
        if (p.startsWith("/") && /\.(?:png|jpe?g|webp|gif|bmp|svg)$/i.test(p)) return p
        return ""
    }

    // The actual saved screenshot file path, when the notification carries one
    // (hyprshot passes the capture via -i, so it arrives in appIcon).
    function extractScreenshotPath(appIcon, image, body) {
        const fromIcon = root.localImagePath(appIcon) || root.localImagePath(image)
        if (fromIcon) return fromIcon
        // Fallback: the body may embed the path in markup/plain text
        // (e.g. "Image saved in <i>/home/..</i> and copied to the clipboard").
        const m = (body ?? "").match(/\/[^\s<>]*\.(?:png|jpe?g|webp|gif|bmp)/i)
        return m ? m[0] : ""
    }

    // Progress percentage from notification hints (0-100), or -1 when absent.
    function extractProgress(hints) {
        if (!hints) return -1
        let v = hints["value"]
        if (v === undefined) v = hints["x-kde-progress"]
        if (v === undefined) v = hints["percentage"]
        if (v === undefined || v === null) return -1
        const n = typeof v === "number" ? v : parseInt(String(v), 10)
        if (Number.isNaN(n)) return -1
        return Math.max(0, Math.min(100, Math.round(n)))
    }

    // Parent directory of a file path, with $HOME shortened to ~ for display.
    function formatDirLabel(path) {
        const idx = path.lastIndexOf("/")
        if (idx <= 0) return path
        let dir = path.slice(0, idx)
        const home = Quickshell.env("HOME")
        if (home) {
            if (dir === home) dir = "~"
            else if (dir.startsWith(home + "/")) dir = "~" + dir.slice(home.length)
        }
        return dir
    }

    // ── Private wording helpers ──────────────────────────────────────────────

    function _matchesDownloadWording(summary, body) {
        return /download|downloaded|downloading|downloads|progress/i.test(`${summary} ${body}`)
    }

    function _matchesSuccessWording(text) {
        // Successful/completed operations: result verbs, plus the ✓/✔ check
        // marks many apps prefix to a completed action ("✓ File saved").
        return /saved|success|successful|successfully|complete|completed|done|finished|copied|installed|updated|upgraded|switched|applied|✓|✔/i.test(text)
    }

    function _looksLikeFileInfo(body) {
        if (!body) return false
        // file extension, size unit, a bullet separator, or a Downloads path
        const extPattern = new RegExp(`(?:^|\\s)[^\\s/]+\\.(?:${root.fileExtensions.join("|")})(?:\\s|$)`, "i")
        return extPattern.test(body)
            || /(?:KB|MB|GB|TB)\b/i.test(body)
            || body.includes("•")
            || /Downloads/i.test(body)
    }
}
