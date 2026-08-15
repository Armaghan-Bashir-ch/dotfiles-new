import QtQuick 6.10
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../services" as QsServices
import "../config" as QsConfig

// Notification card used by the popup toasts (quickshell-notify daemon).
//
// The card is fully category-driven. NotificationClassifier (see services/)
// tags each notification as screenshot / system / download / success / default,
// and this component renders the matching contextual chrome on top of the
// shared glass base:
//
//   screenshot -> green accent, "✓ Saved to <dir>", image preview, Open/Copy path
//   system     -> purple accent, system icon, Hyprland brand logo on the right
//   download   -> amber accent, download icon, progress/completion indicator
//   success    -> green accent for completed actions
//   default    -> normal appearance, app icon, no contextual chrome
//
// Every type shares the same corner radius, glass background, header
// structure, icon-container size, timestamp and close placement - only the
// accent and the contextual content change. New categories can be added by
// extending the classifier and adding a presentation branch here.
//
// ── Sizing contract ─────────────────────────────────────────────────────────
// The card is sized by its content. The popup measures the widest line of
// text with FontMetrics to pick the card width (min 280 / max 400), and the
// card's natural column height IS its height - no minimum and no internal
// padding. The glass frame in the popup adds the 12px breathing room around
// this card, so any padding here would double it.
Item {
    id: root

    required property var notification

    // Feature flags
    property bool showCloseButton: true
    property bool showTimestamp: false
    property bool showUnreadDot: false
    property bool showActions: true
    property bool showBody: true
    property bool showAppIcon: true
    // Contextual smart actions (Open / Copy path, ...) - independent of the
    // D-Bus action buttons above; shown whenever the category warrants it.
    property bool showContextualActions: true

    // Color tokens (overridable by consumer)
    property color primaryColor: pywal?.primary ?? "#88cc88"
    property color onSurfaceColor: pywal?.foreground ?? "#dddddd"
    property color onSurfaceVariantColor: pywal?.onSurfaceMuted ?? "#999999"
    property color errorColor: pywal?.error ?? "#ff4444"
    property color surfaceContainerHighColor: pywal?.surfaceContainerHigh ?? "#1a1a1a"

    property var pywal: null

    // ── Explicit geometry (content-driven) ──────────────────────────────────
    // No fixed width, no minimum height and no internal padding: the popup
    // measures the widest line of text (FontMetrics, see cardWidth()) and
    // frames this card at that width (min 280 / max 400). Vertical breathing
    // room comes from the glass frame around the card, so any padding here
    // would double it.
    // Image preview area: a fixed-height, full-width box. The image covers
    // the whole box (object-fit: cover), so the source image's resolution or
    // aspect ratio never decides the displayed size and never leaves empty
    // space around the image.
    readonly property int imagePreviewHeight: 150

    implicitHeight: contentLayout.implicitHeight

    // ── Category-driven presentation ────────────────────────────────────────
    readonly property string category: notification?.category ?? "default"
    readonly property color accentColor: notification?.accentColor ?? primaryColor

    readonly property bool isScreenshot: root.category === "screenshot"
    readonly property bool isSystem: root.category === "system"
    readonly property bool isDownload: root.category === "download"

    readonly property string screenshotPath: notification?.screenshotPath ?? ""
    readonly property string screenshotDirLabel: notification?.screenshotDirLabel ?? ""
    readonly property int downloadProgress: notification?.downloadProgress ?? -1
    readonly property bool downloadComplete: notification?.downloadComplete ?? false
    readonly property bool hasPreviewImage: (notification?.hasPreviewImage ?? false)
        || ((notification?.image?.length ?? 0) > 0)

    // Shown progress: the real hint value, else 100 for completed downloads.
    readonly property int progressValue: root.isDownload
        ? (root.downloadProgress >= 0 ? root.downloadProgress : (root.downloadComplete ? 100 : -1))
        : -1

    // Left icon glyph per category (Material Design Icons).
    // Glyphs are code points (U+F02F9 etc.); Material Design Icons Desktop
    // maps these Private Use Area codepoints to the actual icons, so the
    // Text must always be rendered with the icon font, never the UI font.
    readonly property string categoryGlyph: {
        switch (root.category) {
        case "screenshot": return "\u{F02F9}" // image-multiple
        case "success":    return "\u{F05E1}" // check-circle-outline
        case "system":     return "\u{F009A}" // bell-outline
        case "download":   return "\u{F01DA}" // download
        default:           return ""
        }
    }

    // Per-app glyph override: some apps are known by name and get a dedicated
    // icon before any category glyph (e.g. Hyprland's  nf-custom glyph in
    // place of the generic bell). Keyed the same way the classifier's app
    // lists are - lowercase appName.
    readonly property var appGlyphs: ({
        "hyprland": "\u{F359}" // (nf custom - Hyprland)
    })
    readonly property string appKey: (notification?.appName ?? "").trim().toLowerCase()
    readonly property bool hasAppGlyph: root.appGlyphs[root.appKey] !== undefined
    readonly property string resolvedGlyph: root.hasAppGlyph
        ? root.appGlyphs[root.appKey]
        : root.categoryGlyph
    readonly property string resolvedGlyphFont: root.hasAppGlyph
        ? QsConfig.Config.appearance.nerdFontFamily
        : root.materialIconFont

    readonly property string materialIconFont: QsConfig.Config.appearance.materialIconFont ?? "Material Design Icons Desktop"
    readonly property string fontFamily: QsConfig.Config.appearance.fontFamily ?? "Inter"

    function iconSource(icon) {
        if (!icon) return ""
        // Quickshell wraps absolute `image-path` hints as image://icon//abs/path,
        // but its icon provider only resolves theme-icon names - an absolute path
        // in the name slot renders as a pink/black missing-icon checkerboard.
        // Unwrap to a plain path so the file loads directly.
        if (icon.startsWith("image://icon/")) {
            const rest = icon.slice("image://icon/".length)
            if (rest.startsWith("/")) return rest
            return icon
        }
        // Already a provider URL (theme icon or raw image-data handle).
        if (icon.startsWith("image://")) return icon
        if (icon.startsWith("/") || icon.startsWith("file://")) return icon
        return "image://icon/" + icon
    }

    function accentTint(alpha) {
        return Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, alpha)
    }

    readonly property bool hasAppIcon: notification?.appIcon && notification.appIcon.length > 0
    readonly property bool hasInlineImage: (notification?.image?.length ?? 0) > 0
    // A notification can supply its own visual as EITHER appIcon or image
    // (notify-send -i <path> surfaces on the image field, other senders on
    // appIcon). A system notification that supplies one gets its own icon
    // shown once in the icon slot - the decorative brand chip and the
    // full-width image banner are both suppressed so it is never duplicated.
    readonly property bool hasSuppliedIcon: root.hasAppIcon || root.hasInlineImage
    readonly property string suppliedIcon: root.hasAppIcon
        ? (notification?.appIcon ?? "")
        : (notification?.image ?? "")

    // Contextual actions spawn their own processes (Open / Delete).
    Process { id: openProc }
    Process { id: deleteProc }

    ColumnLayout {
        id: contentLayout
        // Only horizontal anchoring matters here - the vertical breathing room
        // comes from the glass frame (anchors.margins: 12) in the popup, so
        // the layout's implicitHeight IS the card height.
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 8

        // --- Header Row: icon + summary + brand + timestamp + close ----------
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            // Category/app icon container - same size for every notification
            // type, tinted and bordered with the notification accent.
            Rectangle {
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                Layout.alignment: Qt.AlignTop
                radius: 12
                visible: showAppIcon
                color: root.accentTint(0.12)
                border.width: 1
                border.color: root.accentTint(0.22)

                Text {
                    id: notifGlyph
                    anchors.centerIn: parent
                    // Category glyph for non-default notifications, except when
                    // a system notification already brings its own icon - then
                    // the supplied icon fills the slot instead (one logo only).
                    // Isolated by resolving an app-name override first (e.g.
                    // Hyprland's nf glyph) before the category glyph.
                    visible: root.category !== "default"
                        && !(root.isSystem && root.hasSuppliedIcon && notifIcon.status !== Image.Error)
                    text: root.resolvedGlyph
                    font.family: root.resolvedGlyphFont
                    font.pixelSize: 18
                    color: root.accentColor
                    opacity: 0.9
                }

                Image {
                    id: notifIcon
                    anchors.centerIn: parent
                    width: 20; height: 15
                    // Shown for default notifications, and for system
                    // notifications that supply their own icon (e.g. the
                    // Hyprland logo via notify-send -i) - the supplied icon is
                    // used as-is, never duplicated on the right side.
                    visible: root.hasSuppliedIcon && notifIcon.status !== Image.Error
                        && (root.category === "default" || root.isSystem)
                    source: root.iconSource(root.suppliedIcon)
                    fillMode: Image.PreserveAspectFit
                    smooth: true; cache: true; asynchronous: true
                }

                Text {
                    anchors.centerIn: parent
                    visible: root.category === "default" && (!root.hasSuppliedIcon || notifIcon.status === Image.Error)
                    text: "\u{F009A}" // bell-outline
                    font.family: root.materialIconFont
                    font.pixelSize: 18
                    color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.8)
                }
            }

            // Summary + app name
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    Layout.fillWidth: true
                    text: notification?.summary ?? "Notification"
                    font.family: root.fontFamily
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    color: onSurfaceColor
                    elide: Text.ElideRight
                    font.letterSpacing: -0.15
                }

                Text {
                    Layout.fillWidth: true
                    text: notification?.appName ?? ""
                    font.family: root.fontFamily
                    font.pixelSize: 11
                    color: onSurfaceVariantColor
                    elide: Text.ElideRight
                    wrapMode: Text.NoWrap
                    visible: text.length > 0
                }
            }

            // Brand logo chip (Hyprland/system notifications) - right side,
            // visually balanced against the left icon, never over the text.
            // Suppressed when the notification already has a dedicated icon:
            // either it supplies its own icon/image (shown once in the icon
            // slot instead), or its app name maps to a per-app glyph like
            // Hyprland's  - then the left slot already identifies it and a
            // second chip would be redundant.
            Rectangle {
                Layout.preferredWidth: 36
                Layout.preferredHeight: 36
                Layout.alignment: Qt.AlignTop
                radius: 12
                visible: root.isSystem && !root.hasSuppliedIcon && !root.hasAppGlyph
                color: root.accentTint(0.12)
                border.width: 1
                border.color: root.accentTint(0.22)

                Text {
                    anchors.centerIn: parent
                    text: "\u{F0499}" // shield-outline
                    font.family: root.materialIconFont
                    font.pixelSize: 18
                    color: root.accentColor
                    opacity: 0.9
                }
            }

            // Unread dot
            Rectangle {
                Layout.preferredWidth: 8
                Layout.preferredHeight: 8
                Layout.alignment: Qt.AlignTop
                radius: 4
                visible: showUnreadDot && notification && !notification.read
                color: primaryColor
                Layout.topMargin: 4
            }

            // Timestamp - own line width, never squeezed by the summary.
            Text {
                visible: showTimestamp
                text: notification?.timeString ?? ""
                font.family: root.fontFamily
                font.pixelSize: 10
                color: onSurfaceVariantColor
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 2
            }

            // Close button
            Rectangle {
                Layout.preferredWidth: 26
                Layout.preferredHeight: 26
                Layout.alignment: Qt.AlignTop
                radius: 13
                visible: showCloseButton
                color: closeMouse.containsMouse
                    ? Qt.rgba(errorColor.r, errorColor.g, errorColor.b, 0.12)
                    : "transparent"
                Behavior on color { ColorAnimation { duration: 120 } }

                Text {
                    anchors.centerIn: parent
                    text: "\u{F0156}" // close
                    font.family: root.materialIconFont
                    font.pixelSize: 13
                    color: closeMouse.containsMouse ? errorColor : Qt.rgba(onSurfaceColor.r, onSurfaceColor.g, onSurfaceColor.b, 0.45)
                    Behavior on color { ColorAnimation { duration: 120 } }
                }

                MouseArea {
                    id: closeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.notification && root.notification.close)
                            root.notification.close()
                    }
                }
            }
        }

        // --- Body text ---
        // Hidden for screenshots: their verbose "Image saved in ... and copied
        // to the clipboard" body is replaced by the clean status line below.
        Text {
            Layout.fillWidth: true
            text: notification?.body ?? ""
            font.family: root.fontFamily
            font.pixelSize: 12
            color: onSurfaceVariantColor
            wrapMode: Text.WordWrap
            maximumLineCount: 3
            elide: Text.ElideRight
            lineHeight: 1.4
            visible: showBody && text.length > 0 && !root.isScreenshot
        }

        // --- Screenshot status line: "✓ Saved to <dir>" ---
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            visible: root.isScreenshot && root.screenshotDirLabel.length > 0

            Text {
                Layout.alignment: Qt.AlignVCenter
                text: "\u{F05E0}" // check-circle
                font.family: root.materialIconFont
                font.pixelSize: 13
                color: root.accentColor
            }

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                text: `Saved to ${root.screenshotDirLabel}`
                font.family: root.fontFamily
                font.pixelSize: 11
                font.weight: Font.Medium
                color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.9)
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
            }
        }

        // --- Image preview ---
        // Full-width, fixed-height box that the image covers completely
        // (object-fit: cover) with overflow cropped via clip. Transparent (no
        // glassy panel), corners rounded via radius. Screenshots render the
        // actual saved file; other notifications render their image hint.
        // The preview NEVER affects the card's width or height - it always
        // occupies exactly this fixed area.
Rectangle {
                id: imagePreview
                Layout.fillWidth: true
                Layout.preferredHeight: root.imagePreviewHeight
                radius: 10
                clip: true
                // Suppressed for system notifications that supply their own
                // icon/image: the logo is shown once in the icon slot, never
                // blown up full-width again (notify-send -i Hyprland_logo.png).
                visible: root.hasPreviewImage && !(root.isSystem && root.hasSuppliedIcon)
                color: "transparent"

            Image {
                id: previewImage
                anchors.fill: parent
                source: root.iconSource(root.isScreenshot && root.screenshotPath ? root.screenshotPath : (notification?.image ?? ""))
                fillMode: Image.PreserveAspectCrop
                smooth: true; cache: true; asynchronous: true
                // Cap the decode size so giant screenshots don't blow up memory
                // or force the icon provider to render at useless resolution.
                sourceSize: Qt.size(640, 640)
            }
        }

        // --- Contextual smart actions (screenshots: Open / Copy path) ---
        Flow {
            Layout.fillWidth: true
            spacing: 6
            visible: root.showContextualActions && root.isScreenshot && root.screenshotPath.length > 0

            Repeater {
                model: [
                    { label: "Open", glyph: "\u{F03CC}", // open-in-new
                      action: "open" },
                    { label: "Copy path", glyph: "\u{F018F}", // content-copy
                      action: "copy" },
                    { label: "Delete Screenshot", glyph: "\u{F0199}", // delete
                      action: "delete" }
                ]

                delegate: Rectangle {
                    required property var modelData
                    width: chipRow.implicitWidth + 24
                    height: 28
                    radius: 8
                    color: chipMouse.containsMouse
                        ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.18)
                        : Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.10)
                    Behavior on color { ColorAnimation { duration: 120 } }
                    scale: chipMouse.pressed ? 0.94 : 1.0
                    Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }

                    Row {
                        id: chipRow
                        anchors.centerIn: parent
                        spacing: 6

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.glyph
                            font.family: root.materialIconFont
                            font.pixelSize: 12
                            color: root.accentColor
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: modelData.label
                            font.family: root.fontFamily
                            font.pixelSize: 11
                            font.weight: Font.Medium
                            font.letterSpacing: 0.3
                            color: root.accentColor
                        }
                    }

                    MouseArea {
                        id: chipMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.action === "copy") {
                                // Native clipboard singleton - writes the
                                // screenshot path directly (wl-copy daemonizes
                                // a child that Process.exec reaps, so nothing
                                // lands in the clipboard).
                                Quickshell.clipboardText = root.screenshotPath
                            } else if (modelData.action === "open") {
                                // Launched through bash so the `&` detaches it:
                                // imv keeps running after the card (and its
                                // Process) is destroyed. Same pattern the
                                // control center uses (shell.qml). Bare-id
                                // Process access - root.PROC is undefined in
                                // the delegate scope.
                                openProc.exec(["/bin/bash", "-c",
                                    `imv "${root.screenshotPath}" >/dev/null 2>&1 &`])
                            } else if (modelData.action === "delete") {
                                // Delete the screenshot file from disk. Runs
                                // backgrounded like imv above: close() destroys
                                // this card immediately, and Process's
                                // destructor kills its child - a foreground rm
                                // would die before it finishes. Detached bash
                                // exits instantly, rm survives as an orphan.
                                deleteProc.exec(["/bin/bash", "-c",
                                    `rm -f -- "${root.screenshotPath}" >/dev/null 2>&1 &`])
                            }
                            // Clicking any smart action closes the notification.
                            root.notification.close()
                        }
                    }
                }
            }
        }

        // --- Download progress / completion indicator ---
        // Subtle amber bar + percentage. Only shown when the notification
        // actually carries progress information (or is a completed download).
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            visible: root.isDownload && root.progressValue >= 0

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 5
                radius: 3
                color: Qt.rgba(onSurfaceColor.r, onSurfaceColor.g, onSurfaceColor.b, 0.08)
                clip: true

                Rectangle {
                    anchors { left: parent.left; top: parent.top; bottom: parent.bottom }
                    width: parent.width * (root.progressValue / 100)
                    radius: 3
                    color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.85)
                    Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
                }
            }

            Text {
                text: root.downloadComplete ? "100%" : root.progressValue + "%"
                font.family: root.fontFamily
                font.pixelSize: 11
                font.weight: Font.DemiBold
                color: root.accentColor
                Layout.alignment: Qt.AlignVCenter
            }
        }

        // --- D-Bus action buttons ---
        Flow {
            Layout.fillWidth: true
            spacing: 6
            visible: showActions && notification?.actions && notification.actions.length > 0

            Repeater {
                model: notification?.actions ?? []

                Rectangle {
                    required property var modelData
                    width: actionLabel.implicitWidth + 22
                    height: 28
                    radius: 14
                    color: actionMouse.containsMouse
                        ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.18)
                        : Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.10)
                    Behavior on color { ColorAnimation { duration: 120 } }
                    scale: actionMouse.pressed ? 0.94 : 1.0
                    Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }

                    Text {
                        id: actionLabel
                        anchors.centerIn: parent
                        text: modelData.text ?? modelData.identifier ?? ""
                        font.pixelSize: 11
                        font.weight: Font.Medium
                        font.family: root.fontFamily
                        font.letterSpacing: 0.3
                        color: root.accentColor
                    }

                    MouseArea {
                        id: actionMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.invoke)
                                modelData.invoke()
                            if (root.notification && root.notification.close)
                                root.notification.close()
                        }
                    }
                }
            }
        }
    }
}