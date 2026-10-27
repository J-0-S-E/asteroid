#!/usr/bin/env bash
# asteroid installer (user level, no sudo).
#   ./install.sh              install
#   ./install.sh uninstall    remove
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
qs_dir="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/asteroid"
bin_dir="$HOME/.local/bin"

if [[ ${1:-install} == uninstall ]]; then
  rm -rf "$qs_dir"
  rm -f "$bin_dir/asteroid" "$bin_dir/asteroid-standby"
  echo "Removed $qs_dir, $bin_dir/asteroid and $bin_dir/asteroid-standby."
  echo "Settings in ${XDG_CONFIG_HOME:-$HOME/.config}/asteroid/ were left alone."
  exit 0
fi

missing=0
for cmd in qs grim jq wl-copy hyprctl; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing dependency: $cmd" >&2
    missing=1
  fi
done
(( missing == 0 )) || { echo "Install the missing tools and run again." >&2; exit 1; }
command -v magick >/dev/null 2>&1 || echo "Note: ImageMagick (magick) is optional, used for redaction colour sampling."

mkdir -p "$bin_dir"
rm -rf "$qs_dir"
mkdir -p "$qs_dir"
cp -r "$here/quickshell/." "$qs_dir/"
install -m 755 "$here"/bin/* "$bin_dir/"

echo "Installed to $qs_dir and $bin_dir."
case ":$PATH:" in *":$bin_dir:"*) ;; *) echo "Warning: $bin_dir is not in PATH." ;; esac
cat <<'MSG'

Add these lines to your Hyprland Lua config (nothing was edited for you):

  hl.bind("Print", hl.dsp.exec_cmd("asteroid"))
  hl.exec_cmd("asteroid-standby")
  hl.layer_rule({ match = { namespace = "asteroid" }, no_anim = true })
MSG
