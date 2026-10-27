pragma Singleton
import QtQuick
import Quickshell

// asteroid: minimal replacement for Ryoku's I18n singleton. English source
// strings are the keys, and with no catalog they pass straight through. Extra
// arguments substitute %1, %2, ... like QString::arg.
Singleton {
    function tr(s) {
        if (s === undefined || s === null || s === "")
            return s;
        var out = "" + s;
        for (var i = 1; i < arguments.length; i++)
            out = out.split("%" + i).join("" + arguments[i]);
        return out;
    }
}
