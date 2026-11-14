import Quickshell
import "modules/powerprofile"
import "services" as QsServices

ShellRoot {
    PowerProfileWindow {
        pywal: QsServices.Pywal
        fontFamily: "Inter"
        iconFont: "Material Design Icons Desktop"
    }
}
