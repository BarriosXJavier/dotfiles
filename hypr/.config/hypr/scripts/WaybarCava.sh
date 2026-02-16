#!/usr/bin/env bash
# WaybarCava.sh — safer single-instance handling, cleanup, and robustness
# Original concept by JaKooLit; this variant focuses on lifecycle hardening.

set -euo pipefail

# Ensure cava exists
if ! command -v cava >/dev/null 2>&1; then
  echo "cava not found in PATH" >&2
  exit 1
fi

# 0..7 → ▁▂▃▄▅▆▇█
bar="▁▂▃▄▅▆▇█"
dict="s/;//g"
bar_length=${#bar}
for ((i = 0; i < bar_length; i++)); do
  dict+=";s/$i/${bar:$i:1}/g"
done

RUNTIME_DIR="${XDG_RUNTIME_DIR:-/tmp}"
config_file="$RUNTIME_DIR/waybar-cava.conf"

# Kill any existing cava processes using our config pattern
# This is more robust than PID-based tracking since it catches orphans
pkill -f "cava -p $RUNTIME_DIR/waybar-cava" 2>/dev/null || true
sleep 0.1

# Also clean up any old temp config files from previous buggy versions
rm -f "$RUNTIME_DIR"/waybar-cava.*.conf 2>/dev/null || true

# Use a fixed config file path (not mktemp) for reliable cleanup
cat >"$config_file" <<EOF
[general]
framerate = 15
bars = 8

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Cleanup function - remove config file on exit
cleanup() {
  rm -f "$config_file" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

# Stream cava output and translate digits 0..7 to bar glyphs
# exec replaces this shell with cava, so when waybar kills the process, cava dies
exec cava -p "$config_file" | sed -u "$dict"
