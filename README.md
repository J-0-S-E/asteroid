# asteroid

A fast screenshot and annotation tool for Hyprland, written in Quickshell (QML).
Select a region, a window or a whole monitor, annotate it (arrows, shapes, text,
blur, redaction, spotlight, zoom, step counters), then copy it or save it.
Colours follow your Caelestia scheme. No network access, no Ryoku dependency.

![asteroid overlay on Caelestia with the Dracula scheme](docs/overlay.png)

![Region selected with the annotation toolbar, Caelestia darkgreen scheme](docs/annotate.png)

## Features

- Freeze-on-press: all monitors are grabbed the instant the key is pressed.
- Standby instance for a near-instant overlay (about 180 ms after the key press).
- Shot and Edit modes, annotation toolbar, delay timer, colour picker.
- Copy to clipboard, save to `$(xdg-user-dir PICTURES)/Screenshots`
  (fallback `~/Pictures/Screenshots`).
- Settings stored in `~/.config/asteroid/`.

## Requirements

`quickshell` (`qs`), `grim`, `jq`, `wl-clipboard` (`wl-copy`), Hyprland (`hyprctl`).
Optional: ImageMagick (`magick`), `zenity` or `kdialog` for file dialogs.

## Install

```sh
./install.sh            # copies quickshell/ to ~/.config/quickshell/asteroid and bin/* to ~/.local/bin
./install.sh uninstall
```

The installer does not edit any config. Add this to your Hyprland Lua config:

```lua
hl.bind("Print", hl.dsp.exec_cmd("asteroid"))
hl.exec_cmd("asteroid-standby")
hl.layer_rule({ match = { namespace = "asteroid" }, no_anim = true })
```

Without `asteroid-standby` the tool still works, it just starts slower on each press.
You can also run the config directly: `qs -p quickshell`, or `ASTEROID_DIR=$PWD/quickshell bin/asteroid`.

## Colours

Read from `~/.local/state/caelestia/scheme.json` and followed live:
accent from `primary`, background from `surface`, text from `onSurface` and
`onSurfaceVariant`, danger from `error`. Without the file, upstream defaults apply.

## Credits

Forked from ryoshot in Ryoku by ryoku-dev, GPL-3.0. See `NOTICE` for the changes.

## License

GPL-3.0, see `LICENSE`.
