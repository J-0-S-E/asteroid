pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// asteroid: replacement for Ryoku's Tokens singleton, keeping the property names
// asteroid's code uses. Colours follow the Caelestia scheme at
// ~/.local/state/caelestia/scheme.json (watched, so scheme changes apply live).
// When the file is missing or a role is absent, the upstream Ryoku default is used.
//
// Role mapping (Caelestia/Material -> token):
//   sun        <- primary            (accent)
//   paper      <- surface
//   paperLift  <- surfaceContainer
//   ink        <- onSurface
//   inkDim     <- onSurfaceVariant
//   alert      <- error
//   inkFaint, lineSoft, tint5/10/16 derive from ink / inkDim, as upstream.
Singleton {
    id: t

    // role name -> hex string without '#', as written by Caelestia
    property var scheme: ({})

    function role(key, base) {
        var v = scheme[key];
        if (typeof v === "string" && /^[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$/.test(v))
            return "#" + v;
        return base;
    }

    function refresh() {
        var next = ({});
        try {
            var txt = schemeFile.text();
            var o = txt && txt.length ? JSON.parse(txt) : null;
            if (o && typeof o.colours === "object" && o.colours !== null)
                next = o.colours;
        } catch (e) {
            next = ({});
        }
        t.scheme = next;
    }

    FileView {
        id: schemeFile
        path: (Quickshell.env("XDG_STATE_HOME") || (Quickshell.env("HOME") + "/.local/state")) + "/caelestia/scheme.json"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: t.refresh()
        onLoadFailed: t.scheme = ({})
    }

    // Upstream Ryoku defaults, used when no scheme is available.
    readonly property color paper: role("surface", "#000000")
    readonly property color paperLift: role("surfaceContainer", "#0a0a0a")
    readonly property color ink: role("onSurface", "#cdc4ba")
    readonly property color inkDim: role("onSurfaceVariant", "#b0a9a0")
    readonly property color inkFaint: Qt.rgba(inkDim.r, inkDim.g, inkDim.b, 0.68)

    readonly property color lineSoft: Qt.rgba(ink.r, ink.g, ink.b, 0.13)
    readonly property color tint5: Qt.rgba(ink.r, ink.g, ink.b, 0.05)
    readonly property color tint10: Qt.rgba(ink.r, ink.g, ink.b, 0.10)
    readonly property color tint16: Qt.rgba(ink.r, ink.g, ink.b, 0.16)

    readonly property color sun: role("primary", "#e2342a")
    readonly property color alert: role("error", "#e2342a")

    // Caelestia's default fonts; fontconfig falls back when they are missing.
    readonly property string ui: "Rubik"
    readonly property string mono: "CaskaydiaCove NF"
    readonly property string jp: "Noto Sans CJK JP"

    readonly property int radius: 6
    readonly property int snap: 90
    readonly property int move: 170
}
