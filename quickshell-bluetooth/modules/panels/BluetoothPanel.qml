// BluetoothPanel.qml - Bluetooth menu, Liquid Glass edition.
//
// Pure presentation-layer redesign. Every piece of Bluetooth behavior is
// preserved bit-for-bit from the original:
//   - device sort (connected first, then bonded, then by name)
//   - connect/disconnect flow (writes device.connected)
//   - adapter power toggle + discovering/scan toggle
//   - blueberry settings launch
//   - hover-out close timer
//   - Escape / settings-button close
//   - empty states (no devices / adapter disabled)
//
// New (UI-only, mirrors the network menu):
//   - frosted glass surface (Hyprland compositor blur behind the window)
//   - search filter for devices
//   - right-click context menu (Connect / Disconnect / Rescan)
//   - glass toggle / icon buttons / list rows with connected-state surface

import Quickshell
import QtQuick 6.10
import QtQuick.Layouts 6.10
import Quickshell.Bluetooth
import Quickshell.Io
import "../../services" as QsServices
import "../../components"

FocusScope {
    id: popupPanel

    property bool shouldShow: false
    signal closeRequested()

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var pywal: QsServices.Pywal
    property string searchText: ""

    // Preserved ordering: connected first, then bonded, then alphabetically.
    readonly property var sortedDevices: [...Bluetooth.devices.values].sort((a, b) => {
        if (a.connected !== b.connected) return b.connected - a.connected
        if (a.bonded !== b.bonded) return b.bonded - a.bonded
        return a.name.localeCompare(b.name)
    })

    readonly property var visibleDevices: searchText.length === 0
        ? sortedDevices
        : sortedDevices.filter(d => d.name.toLowerCase().includes(searchText.toLowerCase()))

    // === Colors =============================================================
    readonly property color cPrimary: pywal.primary
    readonly property color cOnSurface: pywal.foreground
    readonly property color cOnSurfaceVariant: pywal.onSurfaceMuted
    // Connected-state accent (kept identical to the original menu).
    readonly property color cActive: "#82b7b0"

    // === Hover-out close (preserved) ========================================
    HoverHandler {
        id: hoverHandler
    }

    Timer {
        id: closeTimer
        interval: 600
        onTriggered: if (!hoverHandler.hovered) popupPanel.shouldShow = false
    }

    Connections {
        target: hoverHandler

        function onHoveredChanged() {
            if (hoverHandler.hovered)
                closeTimer.stop()
            else if (popupPanel.shouldShow)
                closeTimer.restart()
        }
    }

    Process {
        id: settingsProcess
        command: ["blueberry"]
        onStarted: popupPanel.closeRequested()
    }

    implicitWidth: 352
    implicitHeight: contentColumn.implicitHeight + 30
    focus: true

    Keys.onEscapePressed: {
        if (contextMenu.visible) {
            contextMenu.hide()
        } else if (searchField.text.length > 0) {
            searchField.text = ""
            popupPanel.searchText = ""
        } else {
            closeRequested()
        }
    }

    // === Shared connect logic (identical to the original) ===================
    function toggleDevice(device): void {
        device.connected = !device.connected
    }

    // ========================================================================
    // MAIN GLASS SURFACE
    // ========================================================================
    GlassSurface {
        id: glassPanel
        anchors.fill: parent
        radius: GlassTheme.radiusPanel
        fillColor: pywal.background
        fillOpacity: GlassTheme.glassFillOpacity
        shadowDepth: GlassTheme.shadowDepth

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: 16
            spacing: 14

            // ---- Header -----------------------------------------------------
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                // Header icon chip (static)
                Rectangle {
                    Layout.alignment: Qt.AlignVCenter
                    width: 40
                    height: 40
                    radius: 12
                    color: Qt.rgba(cPrimary.r, cPrimary.g, cPrimary.b, 0.16)
                    border.width: 1
                    border.color: Qt.rgba(1, 1, 1, GlassTheme.borderStandard)

                    Text {
                        anchors.centerIn: parent
                        text: "󰂯"
                        font.family: GlassTheme.iconFont
                        font.pixelSize: 18
                        color: cPrimary
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 2

                    Text {
                        text: "Bluetooth"
                        font.family: GlassTheme.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: cOnSurface
                    }

                    Text {
                        property var connected: sortedDevices.filter(d => d.connected)
                        text: connected.length > 0 ? connected[0].name : "No device connected"
                        font.family: GlassTheme.fontFamily
                        font.pixelSize: 11
                        color: cOnSurfaceVariant
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                GlassToggle {
                    Layout.alignment: Qt.AlignVCenter
                    checked: popupPanel.adapter?.enabled ?? false
                    accentColor: cActive
                    onToggled: QsServices.Bluetooth.togglePower()
                }

                GlassIconButton {
                    Layout.alignment: Qt.AlignVCenter
                    size: 36
                    icon: "󰑓"
                    spinning: popupPanel.adapter?.discovering ?? false
                    iconColor: cOnSurface
                    baseColor: Qt.rgba(cPrimary.r, cPrimary.g, cPrimary.b, 0.12)
                    enabled: popupPanel.adapter?.enabled ?? false
                    onClicked: {
                        if (popupPanel.adapter)
                            popupPanel.adapter.discovering = !popupPanel.adapter.discovering
                    }
                }

                GlassIconButton {
                    Layout.alignment: Qt.AlignVCenter
                    size: 36
                    icon: "󰒓"
                    iconColor: cOnSurface
                    baseColor: Qt.rgba(cPrimary.r, cPrimary.g, cPrimary.b, 0.12)
                    onClicked: settingsProcess.running = true
                }
            }

            // ---- Search field ------------------------------------------------
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                GlassTextField {
                    id: searchField
                    Layout.fillWidth: true
                    leadingIcon: "󰇟"
                    placeholderText: "Search devices"
                    textColor: cOnSurface
                    accentColor: cPrimary
                    onTextEdited: text => popupPanel.searchText = text
                }

                GlassIconButton {
                    Layout.alignment: Qt.AlignVCenter
                    visible: searchField.text.length > 0
                    size: 36
                    icon: "󰅖"
                    iconColor: cOnSurfaceVariant
                    onClicked: {
                        searchField.text = ""
                        popupPanel.searchText = ""
                        searchField.forceFocus()
                    }
                }
            }

            // ---- Device list ------------------------------------------------
            // A whisper of a recessed surface: the list sits in a subtle well
            // on the glass, giving the floating rows somewhere to live.
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: visibleDevices.length > 0
                    ? Math.min(deviceList.contentHeight + 8, 280)
                    : 140
                radius: GlassTheme.radiusItem
                color: Qt.rgba(1, 1, 1, 0.02)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, GlassTheme.borderSubtle)
                clip: true

                ListView {
                    id: deviceList
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 4
                    model: visibleDevices
                    clip: true

                    // New rows (search filtering) fade in gently instead of
                    // snapping into place.
                    add: Transition {
                        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
                    }

                    delegate: BluetoothListItem {
                        id: listItem
                        width: deviceList.width
                        // This Quickshell/Qt build does NOT expose the `model` /
                        // `modelData` context properties to custom-component
                        // delegates (only `index`). Reach the element through the
                        // ListView's own model property instead.
                        modelData: deviceList.model[index]
                        textColor: cOnSurface
                        textMutedColor: cOnSurfaceVariant
                        accentColor: cActive

                        onActionClicked: {
                            if (listItem.isConnected)
                                listItem.modelData.connected = false
                            else
                                listItem.modelData.connected = true
                        }

                        onContextMenuRequested: (mx, my) => {
                            const pos = listItem.mapToItem(popupPanel, mx, my)
                            contextMenu.show(pos.x, pos.y, listItem.modelData)
                        }
                    }
                }

                // ---- Empty state -------------------------------------------
                ColumnLayout {
                    anchors.centerIn: parent
                    visible: visibleDevices.length === 0
                    spacing: 8

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 56
                        height: 56
                        radius: 18
                        color: Qt.rgba(1, 1, 1, 0.04)
                        border.width: 1
                        border.color: Qt.rgba(1, 1, 1, 0.07)

                        Text {
                            anchors.centerIn: parent
                            text: "󰂲"
                            font.family: GlassTheme.iconFont
                            font.pixelSize: 26
                            color: Qt.rgba(cOnSurface.r, cOnSurface.g, cOnSurface.b, 0.28)
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: {
                            if (searchText.length > 0) return "No matching devices"
                            if (!(popupPanel.adapter?.enabled ?? false)) return "Bluetooth disabled"
                            return "No devices found"
                        }
                        font.family: GlassTheme.fontFamily
                        font.pixelSize: 12
                        color: cOnSurfaceVariant
                    }
                }
            }
        }
    }

    // ========================================================================
    // CONTEXT MENU
    // ========================================================================
    Item {
        id: contextMenuHost
        anchors.fill: parent
        visible: false
        z: 150

        // Transparent scrim - click anywhere to dismiss.
        MouseArea {
            anchors.fill: parent
            onClicked: contextMenu.hide()
        }

        GlassContextMenu {
            id: contextMenu

            property var targetDevice: null

            textColor: cOnSurface
            x: 0
            y: 0
            visible: false

            function show(mx, my, device): void {
                targetDevice = device
                const items = []
                if (device.connected)
                    items.push({ label: "Disconnect", icon: "󰌊" })
                else
                    items.push({ label: "Connect", icon: "󰌘" })
                items.push({ label: "Rescan Devices", icon: "󰑓" })
                model = items

                x = Math.min(Math.max(6, mx), popupPanel.width - implicitWidth - 6)
                y = Math.min(Math.max(6, my), popupPanel.height - implicitHeight - 6)
                contextMenuHost.visible = true
                visible = true
            }

            function hide(): void {
                visible = false
                contextMenuHost.visible = false
            }

            onItemSelected: index => {
                const device = contextMenu.targetDevice
                if (index === 0) {
                    device.connected = !device.connected
                } else if (popupPanel.adapter) {
                    popupPanel.adapter.discovering = !popupPanel.adapter.discovering
                }
                contextMenu.hide()
            }
        }
    }
}
