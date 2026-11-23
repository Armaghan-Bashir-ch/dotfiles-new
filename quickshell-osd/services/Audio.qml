pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root

    // ─────────────────────────────────────────────
    // Default PipeWire nodes
    // ─────────────────────────────────────────────

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    // Audio properties are only valid while the nodes are tracked.
    PwObjectTracker {
        objects: {
            const nodes = []
            if (root.sink)
                nodes.push(root.sink)
            if (root.source)
                nodes.push(root.source)
            return nodes
        }
    }

    // ─────────────────────────────────────────────
    // Output
    // ─────────────────────────────────────────────

    readonly property bool ready:
        root.sink !== null &&
        root.sink.ready &&
        root.sink.audio !== null

    readonly property bool muted:
        root.ready ? root.sink.audio.muted : false

    readonly property real volume:
        root.ready ? root.sink.audio.volume : 0

    readonly property int percentage:
        Math.round(root.volume * 100)

    // ─────────────────────────────────────────────
    // Input
    // ─────────────────────────────────────────────

    readonly property bool sourceReady:
        root.source !== null &&
        root.source.ready &&
        root.source.audio !== null

    readonly property bool sourceMuted:
        root.sourceReady ? root.source.audio.muted : false

    readonly property real sourceVolume:
        root.sourceReady ? root.source.audio.volume : 0

    readonly property int sourcePercentage:
        Math.round(root.sourceVolume * 100)

    // ─────────────────────────────────────────────
    // Output controls
    // ─────────────────────────────────────────────

    function setVolume(newVolume) {
        if (!root.ready)
            return

        root.sink.audio.volume = Math.max(
            0,
            Math.min(1.5, newVolume)
        )
        root.sink.audio.muted = false
    }

    function increaseVolume() {
        setVolume(root.volume + 0.05)
    }

    function decreaseVolume() {
        setVolume(root.volume - 0.05)
    }

    function setMute(m) {
        if (!root.ready)
            return

        root.sink.audio.muted = m
    }

    function toggleMute() {
        if (!root.ready)
            return

        root.sink.audio.muted = !root.sink.audio.muted
    }

    // ─────────────────────────────────────────────
    // Input controls
    // ─────────────────────────────────────────────

    function setSourceVolume(newVolume) {
        if (!root.sourceReady)
            return

        root.source.audio.volume = Math.max(
            0,
            Math.min(1.5, newVolume)
        )
        root.source.audio.muted = false
    }

    function setSourceMute(m) {
        if (!root.sourceReady)
            return

        root.source.audio.muted = m
    }

    function toggleSourceMute() {
        if (!root.sourceReady)
            return

        root.source.audio.muted = !root.source.audio.muted
    }
}
