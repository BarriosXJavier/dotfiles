#!/usr/bin/env bash
# Cycle through predefined fonts in kitty

set -euo pipefail

STATE_FILE="$HOME/.cache/.kitty_font_index"
FONTS=(
  "Iosevka Nerd Font"
  "FantasqueSansM Nerd Font Propo"
)

# Get current index (default 0)
index=$(cat "$STATE_FILE" 2>/dev/null || echo 0)

# Cycle to next font
index=$(( (index + 1) % ${#FONTS[@]} ))
echo "$index" > "$STATE_FILE"

# Apply the new font
font="${FONTS[$index]}"
kitty @ load-config -o "font_family=$font"

# Notify user
notify-send -u low "Kitty Font" "$font" || true
