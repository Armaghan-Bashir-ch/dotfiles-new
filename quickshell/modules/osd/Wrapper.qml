import Quickshell
import QtQuick

Scope {
    id: root
    
    required property var pywal
    
    VolumeOSD {
        id: volumeOSD
        pywal: root.pywal
        sibling: brightnessOSD
    }
    
    BrightnessOSD {
        id: brightnessOSD
        pywal: root.pywal
        sibling: volumeOSD
    }
}
