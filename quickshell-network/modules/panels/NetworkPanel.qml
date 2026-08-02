// NetworkPanel.qml - Wi-Fi menu, Liquid Glass edition.
//
// Pure presentation-layer redesign. Every piece of networking behavior is
// preserved bit-for-bit from the original:
//   - connect/disconnect flow (saved / secure / open)
//   - password dialog flow
//   - wifi toggle + rescan
//   - hover-out close timer
//   - Escape / settings-button close
//
// New (UI-only):
//   - frosted glass surface (Hyprland compositor blur behind the window)
//   - search filter for networks
//   - right-click context menu (Connect / Disconnect / Rescan)
//   - animated connected state and signal-strength pulse

import Quickshell
import QtQuick 6.10
import QtQuick.Layouts 6.10
import Quickshell.Io
import "../../services" as QsServices
import "../../components"

FocusScope {
    id: popupPanel

    property bool shouldShow: false
    signal closeRequested()

    readonly property var pywal: QsServices.Pywal
    readonly property var network: QsServices.Network
    property string searchText: ""

    // === Colors =============================================================
    readonly property color cPrimary: pywal.primary
    readonly property color cOnSurface: pywal.foreground
    readonly property color cOnSurfaceVariant: pywal.onSurfaceMuted
    // Connected-state accent (kept identical to the original menu).
    readonly property color cActive: "#82b7b0"

    // === Networks (preserved ordering: active first, then by strength) ======
    readonly property var sortedNetworks: [...network.networks].sort((a, b) => {
        if (a.active !== b.active) return b.active - a.active
        return b.strength - a.strength
    })

    readonly property var visibleNetworks: searchText.length === 0
        ? sortedNetworks
        : sortedNetworks.filter(n => n.ssid.toLowerCase().includes(searchText.toLowerCase()))

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
        command: ["nm-connection-editor"]
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
        } else if (!passwordDialog.isOpen) {
            closeRequested()
        }
    }

    // === Shared connect logic (identical to the original) ===================
    function connectNetwork(net): void {
        const isSaved = network.savedNetworks.includes(net.ssid)
        if (isSaved) {
            network.connectToNetwork(net.ssid, "")
        } else if (net.isSecure) {
            passwordDialog.networkSSID = net.ssid
            passwordDialog.open()
        } else {
            network.connectToNetwork(net.ssid, "")
        }
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
                        text: "󰖩"
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
                        text: "WiFi Networks"
                        font.family: GlassTheme.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: cOnSurface
                    }

                    Text {
                        text: network.active ? network.active.ssid : "Not connected"
                        font.family: GlassTheme.fontFamily
                        font.pixelSize: 11
                        color: cOnSurfaceVariant
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                GlassToggle {
                    Layout.alignment: Qt.AlignVCenter
                    checked: network.wifiEnabled
                    accentColor: cActive
                    onToggled: network.toggleWifi()
                }

                GlassIconButton {
                    Layout.alignment: Qt.AlignVCenter
                    size: 36
                    icon: "󰑓"
                    busy: network.scanning
                    iconColor: cOnSurface
                    baseColor: Qt.rgba(cPrimary.r, cPrimary.g, cPrimary.b, 0.12)
                    enabled: network.wifiEnabled
                    onClicked: network.rescanWifi()
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
                    placeholderText: "Search networks"
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

            // ---- Network list ------------------------------------------------
            // A whisper of a recessed surface: the list sits in a subtle well
            // on the glass, giving the floating rows somewhere to live.
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: visibleNetworks.length > 0
                    ? Math.min(networkList.contentHeight + 8, 280)
                    : 140
                radius: GlassTheme.radiusItem
                color: Qt.rgba(1, 1, 1, 0.02)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, GlassTheme.borderSubtle)
                clip: true

                ListView {
                    id: networkList
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 4
                    model: visibleNetworks
                    clip: true

                    // New rows (search filtering) fade in gently instead of
                    // snapping into place.
                    add: Transition {
                        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: GlassTheme.durNormal; easing.type: GlassTheme.easeStandard }
                    }

                    delegate: NetworkListItem {
                        id: listItem
                        width: networkList.width
                        // This Quickshell/Qt build does NOT expose the `model` /
                        // `modelData` context properties to custom-component
                        // delegates (only `index`). Reach the element through the
                        // ListView's own model property instead.
                        modelData: networkList.model[index]
                        textColor: cOnSurface
                        textMutedColor: cOnSurfaceVariant
                        accentColor: cActive
                        interactiveColor: cPrimary

                        onActionClicked: {
                            if (listItem.isActive)
                                network.disconnectFromNetwork()
                            else
                                popupPanel.connectNetwork(listItem.modelData)
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
                    visible: visibleNetworks.length === 0
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
                            text: "󰖪"
                            font.family: GlassTheme.iconFont
                            font.pixelSize: 26
                            color: Qt.rgba(cOnSurface.r, cOnSurface.g, cOnSurface.b, 0.28)
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: {
                            if (searchText.length > 0) return "No matching networks"
                            if (!network.wifiEnabled) return "WiFi disabled"
                            return "No networks found"
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

            property var targetNetwork: null

            textColor: cOnSurface
            x: 0
            y: 0
            visible: false

            function show(mx, my, net): void {
                targetNetwork = net
                const items = []
                if (net.active)
                    items.push({ label: "Disconnect", icon: "󰌊" })
                else
                    items.push({ label: "Connect", icon: "󰌘" })
                items.push({ label: "Rescan Wi-Fi", icon: "󰑓" })
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
                const net = contextMenu.targetNetwork
                if (index === 0) {
                    if (net.active)
                        network.disconnectFromNetwork()
                    else
                        popupPanel.connectNetwork(net)
                } else {
                    network.rescanWifi()
                }
                contextMenu.hide()
            }
        }
    }

    // ========================================================================
    // PASSWORD DIALOG
    // ========================================================================
    Item {
        id: passwordDialog
        anchors.fill: parent
        visible: opacity > 0
        z: 200

        property string networkSSID: ""
        property bool isOpen: false

        opacity: 0

        function open() { isOpen = true; passwordInput.forceFocus() }
        function close() {
            isOpen = false
            passwordInput.text = ""
            popupPanel.focus = true
        }

        states: State {
            name: "open"; when: passwordDialog.isOpen
            PropertyChanges { target: passwordDialog; opacity: 1 }
            PropertyChanges { target: dialogCard; scale: 1.0 }
        }

        transitions: [
            Transition { to: "open"
                ParallelAnimation {
                    NumberAnimation { target: passwordDialog; property: "opacity"; duration: 150; easing.type: GlassTheme.easeStandard }
                    NumberAnimation { target: dialogCard; property: "scale"; duration: 220; easing.type: GlassTheme.easeSpring }
                }
            },
            Transition { from: "open"
                ParallelAnimation {
                    NumberAnimation { target: passwordDialog; property: "opacity"; duration: 110; easing.type: GlassTheme.easeSharp }
                    NumberAnimation { target: dialogCard; property: "scale"; to: 0.94; duration: 110; easing.type: GlassTheme.easeSharp }
                }
            }
        ]

        // Frosted scrim
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.35)
            radius: GlassTheme.radiusPanel
            MouseArea {
                anchors.fill: parent
                onClicked: passwordDialog.close()
            }
        }

        // Glass card
        Item {
            id: dialogCard
            anchors.centerIn: parent
            width: 300
            height: dialogColumn.implicitHeight + 32
            scale: 0.94

            GlassSurface {
                anchors.fill: parent
                radius: GlassTheme.radiusCard
                fillColor: pywal.background
                fillOpacity: GlassTheme.glassDialogOpacity
                shadowDepth: 6

                ColumnLayout {
                    id: dialogColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 14

                    Text {
                        text: "Enter Password"
                        font.family: GlassTheme.fontFamily
                        font.pixelSize: 15
                        font.weight: Font.DemiBold
                        color: cOnSurface
                    }

                    Text {
                        text: passwordDialog.networkSSID
                        font.family: GlassTheme.fontFamily
                        font.pixelSize: 11
                        color: cOnSurfaceVariant
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    GlassTextField {
                        id: passwordInput
                        Layout.fillWidth: true
                        password: true
                        placeholderText: "Password"
                        textColor: cOnSurface
                        accentColor: cPrimary

                        onAccepted: {
                            if (text.length > 0) {
                                network.connectToNetwork(passwordDialog.networkSSID, text)
                                passwordDialog.close()
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Item { Layout.fillWidth: true }

                        GlassButton {
                            text: "Cancel"
                            textColor: cOnSurface
                            onClicked: passwordDialog.close()
                        }

                        GlassButton {
                            text: "Connect"
                            primary: true
                            accentColor: cPrimary
                            enabled: passwordInput.text.length > 0
                            onClicked: {
                                network.connectToNetwork(passwordDialog.networkSSID, passwordInput.text)
                                passwordDialog.close()
                            }
                        }
                    }
                }
            }
        }
    }
}
