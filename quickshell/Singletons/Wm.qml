pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// asteroid: Hyprland-only window-manager view. A single `hyprctl -j` snapshot is
// taken at load and again on refresh(). asteroid only reads caps.windowGeometry,
// outputs[].activeWorkspace and windows[] {workspace,x,y,width,height,focusOrder}.
// Based on our earlier standalone ryoshot port.
Singleton {
    id: root

    property var outputs: []
    property var windows: []
    // Hyprland reports window geometry (global logical coords).
    readonly property var caps: ({ "windowGeometry": true, "focusHistory": true })

    // New snapshot when a standby instance is opened (windows may have moved).
    function refresh(): void {
        snap.running = true;
    }

    // outputs: name + active workspace id. windows: only mapped, visible clients;
    // focusOrder = focusHistoryID (0 = most recently focused, lower wins on overlap).
    Process {
        id: snap
        running: true
        command: ["bash", "-c",
            "m=$(hyprctl -j monitors); c=$(hyprctl -j clients); " +
            "jq -n --argjson m \"$m\" --argjson c \"$c\" '{" +
            "outputs: [$m[] | {name, activeWorkspace: (.activeWorkspace.id|tostring), scale, transform}]," +
            "windows: [$c[] | select(.mapped and (.hidden|not)) | {id: .address, appId: .class, title, " +
            "workspace: (.workspace.id|tostring), output: \"\", focusOrder: .focusHistoryID, floating, " +
            "x: .at[0], y: .at[1], width: .size[0], height: .size[1]}]}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const o = JSON.parse(text);
                    root.outputs = o.outputs;
                    root.windows = o.windows;
                } catch (e) {
                    console.warn("asteroid: could not parse hyprctl snapshot: " + e);
                }
            }
        }
    }
}
