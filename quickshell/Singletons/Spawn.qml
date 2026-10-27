pragma Singleton

import Quickshell

// asteroid: small replacement for Ryoku's Spawn singleton. Detached children
// must not inherit Quickshell's crash-recovery handles.
Singleton {
    id: spawn

    // A null value unsets the variable for the child rather than setting it empty.
    // Process.environment takes the same map.
    readonly property var env: ({
            "__QUICKSHELL_CRASH_INFO_FD": null,
            "__QUICKSHELL_CRASH_DUMP_PID": null,
            "__QUICKSHELL_CRASH_DUMP_FD": null,
            "__QUICKSHELL_CRASH_LOG_FD": null,
            "__QUICKSHELL_CRASH_SIGNAL": null
        })

    // run(argv) launches and forgets, like Quickshell.execDetached.
    function run(command, workingDirectory) {
        if (!command || command.length === 0)
            return;
        const ctx = {
            "command": command,
            "environment": spawn.env
        };
        if (workingDirectory)
            ctx.workingDirectory = String(workingDirectory);
        Quickshell.execDetached(ctx);
    }

    // No host wrapper here: the argv runs directly.
    function runApp(argv, opts) {
        spawn.run(argv ? argv.map(String) : [], opts && opts.cwd);
    }
}
