#!/usr/bin/env bash

set -euo pipefail

MIN_TEXT_CONTRAST="${MIN_TEXT_CONTRAST:-7.0}"
MIN_ACCENT_CONTRAST="${MIN_ACCENT_CONTRAST:-3.0}"

to_upper_hex() {
  printf '%s\n' "${1#\#}" | tr '[:lower:]' '[:upper:]'
}

relative_luminance() {
  local hex
  hex="$(to_upper_hex "$1")"
  awk -v hex="$hex" '
    function linearize(channel) {
      channel /= 255
      if (channel <= 0.03928) {
        return channel / 12.92
      }
      return ((channel + 0.055) / 1.055) ^ 2.4
    }
    BEGIN {
      r = strtonum("0x" substr(hex, 1, 2))
      g = strtonum("0x" substr(hex, 3, 2))
      b = strtonum("0x" substr(hex, 5, 2))
      printf "%.6f\n", 0.2126 * linearize(r) + 0.7152 * linearize(g) + 0.0722 * linearize(b)
    }
  '
}

contrast_ratio() {
  local first second
  first="$(relative_luminance "$1")"
  second="$(relative_luminance "$2")"
  awk -v a="$first" -v b="$second" '
    BEGIN {
      lighter = (a > b) ? a : b
      darker = (a > b) ? b : a
      printf "%.6f\n", (lighter + 0.05) / (darker + 0.05)
    }
  '
}

is_ratio_below() {
  local ratio threshold
  ratio="$1"
  threshold="$2"
  awk -v ratio="$ratio" -v threshold="$threshold" 'BEGIN { exit !(ratio < threshold) }'
}

preferred_text_color() {
  local background luminance
  background="$(to_upper_hex "$1")"
  luminance="$(relative_luminance "$background")"
  if awk -v value="$luminance" 'BEGIN { exit !(value < 0.35) }'; then
    printf '#F5F5F5\n'
  else
    printf '#111111\n'
  fi
}

blend_towards() {
  local source target factor
  source="$(to_upper_hex "$1")"
  target="$(to_upper_hex "$2")"
  factor="$3"
  awk -v src="$source" -v dst="$target" -v factor="$factor" '
    function clamp(value) {
      if (value < 0) {
        return 0
      }
      if (value > 255) {
        return 255
      }
      return value
    }
    function chan(hex, offset) {
      return strtonum("0x" substr(hex, offset, 2))
    }
    BEGIN {
      sr = chan(src, 1); sg = chan(src, 3); sb = chan(src, 5)
      tr = chan(dst, 1); tg = chan(dst, 3); tb = chan(dst, 5)
      rr = clamp(int(sr + (tr - sr) * factor + 0.5))
      rg = clamp(int(sg + (tg - sg) * factor + 0.5))
      rb = clamp(int(sb + (tb - sb) * factor + 0.5))
      printf "#%02X%02X%02X\n", rr, rg, rb
    }
  '
}

adjust_color_for_background() {
  local color background threshold target ratio adjusted
  color="$1"
  background="$2"
  threshold="$3"
  target="$(preferred_text_color "$background")"
  adjusted="$color"
  ratio="$(contrast_ratio "$adjusted" "$background")"

  if ! is_ratio_below "$ratio" "$threshold"; then
    printf '%s\n' "$adjusted"
    return 0
  fi

  for _ in $(seq 1 24); do
    adjusted="$(blend_towards "$adjusted" "$target" 0.22)"
    ratio="$(contrast_ratio "$adjusted" "$background")"
    if ! is_ratio_below "$ratio" "$threshold"; then
      break
    fi
  done

  printf '%s\n' "$adjusted"
}

first_match() {
  local file regex
  file="$1"
  regex="$2"
  sed -n -E "s/$regex/\\1/p" "$file" | head -n1
}

set_kitty_value() {
  local file key value
  file="$1"
  key="$2"
  value="$3"
  sed -i -E "s|^(${key}[[:space:]]+)#[0-9A-Fa-f]{6}$|\\1${value}|" "$file"
}

set_ghostty_value() {
  local file key value
  file="$1"
  key="$2"
  value="$3"
  sed -i -E "s|^(${key}[[:space:]]*=[[:space:]]*)#[0-9A-Fa-f]{6}$|\\1${value}|" "$file"
}

set_rofi_value() {
  local file key value
  file="$1"
  key="$2"
  value="$3"
  sed -i -E "s|^([[:space:]]*${key}:[[:space:]]*)#[0-9A-Fa-f]{6}(;.*)$|\\1${value}\\2|" "$file"
}

normalize_kitty() {
  local file background foreground selection index color adjusted
  file="$HOME/.config/kitty/kitty-themes/01-Wallust.conf"
  [ -f "$file" ] || return 0

  background="$(first_match "$file" '^background[[:space:]]+(#[0-9A-Fa-f]{6})$')"
  foreground="$(first_match "$file" '^foreground[[:space:]]+(#[0-9A-Fa-f]{6})$')"
  selection="$(first_match "$file" '^active_tab_background[[:space:]]+(#[0-9A-Fa-f]{6})$')"
  [ -n "$background" ] || return 0

  if [ -n "$foreground" ]; then
    adjusted="$(adjust_color_for_background "$foreground" "$background" "$MIN_TEXT_CONTRAST")"
    set_kitty_value "$file" "foreground" "$adjusted"
    set_kitty_value "$file" "inactive_tab_foreground" "$adjusted"
    set_kitty_value "$file" "active_border_color" "$adjusted"
  fi

  if [ -n "$selection" ]; then
    adjusted="$(adjust_color_for_background "#111111" "$selection" 4.5)"
    if is_ratio_below "$(contrast_ratio "$adjusted" "$selection")" 4.5; then
      adjusted="$(adjust_color_for_background "#F5F5F5" "$selection" 4.5)"
    fi
    set_kitty_value "$file" "active_tab_foreground" "$adjusted"
  fi

  for index in $(seq 0 15); do
    color="$(first_match "$file" "^color${index}[[:space:]]+(#[0-9A-Fa-f]{6})$")"
    [ -n "$color" ] || continue
    adjusted="$(adjust_color_for_background "$color" "$background" "$MIN_ACCENT_CONTRAST")"
    set_kitty_value "$file" "color${index}" "$adjusted"
  done
}

normalize_ghostty() {
  local file background foreground selection index color adjusted
  file="$HOME/.config/ghostty/wallust.conf"
  [ -f "$file" ] || return 0

  background="$(first_match "$file" '^background[[:space:]]*=[[:space:]]*(#[0-9A-Fa-f]{6})$')"
  foreground="$(first_match "$file" '^foreground[[:space:]]*=[[:space:]]*(#[0-9A-Fa-f]{6})$')"
  selection="$(first_match "$file" '^selection-background[[:space:]]*=[[:space:]]*(#[0-9A-Fa-f]{6})$')"
  [ -n "$background" ] || return 0

  if [ -n "$foreground" ]; then
    adjusted="$(adjust_color_for_background "$foreground" "$background" "$MIN_TEXT_CONTRAST")"
    set_ghostty_value "$file" "foreground" "$adjusted"
  fi

  if [ -n "$selection" ]; then
    adjusted="$(adjust_color_for_background "#111111" "$selection" 4.5)"
    if is_ratio_below "$(contrast_ratio "$adjusted" "$selection")" 4.5; then
      adjusted="$(adjust_color_for_background "#F5F5F5" "$selection" 4.5)"
    fi
    set_ghostty_value "$file" "selection-foreground" "$adjusted"
  fi

  for index in $(seq 0 15); do
    color="$(first_match "$file" "^palette[[:space:]]*=[[:space:]]*${index}=(#[0-9A-Fa-f]{6})$")"
    [ -n "$color" ] || continue
    adjusted="$(adjust_color_for_background "$color" "$background" "$MIN_ACCENT_CONTRAST")"
    sed -i -E "s|^(palette[[:space:]]*=[[:space:]]*${index}=)#[0-9A-Fa-f]{6}$|\\1${adjusted}|" "$file"
  done
}

normalize_rofi() {
  local file normal_bg alternate_bg active_bg urgent_bg selected_bg value adjusted
  file="$HOME/.config/rofi/wallust/colors-rofi.rasi"
  [ -f "$file" ] || return 0

  normal_bg="$(first_match "$file" '^[[:space:]]*normal-background:[[:space:]]*(#[0-9A-Fa-f]{6});$')"
  alternate_bg="$(first_match "$file" '^[[:space:]]*alternate-normal-background:[[:space:]]*(#[0-9A-Fa-f]{6});$')"
  active_bg="$(first_match "$file" '^[[:space:]]*active-background:[[:space:]]*(#[0-9A-Fa-f]{6});$')"
  urgent_bg="$(first_match "$file" '^[[:space:]]*urgent-background:[[:space:]]*(#[0-9A-Fa-f]{6});$')"
  selected_bg="$(first_match "$file" '^[[:space:]]*selected-normal-background:[[:space:]]*(#[0-9A-Fa-f]{6});$')"

  value="$(first_match "$file" '^[[:space:]]*normal-foreground:[[:space:]]*(#[0-9A-Fa-f]{6});$')"
  [ -n "$value" ] && [ -n "$normal_bg" ] && set_rofi_value "$file" "normal-foreground" "$(adjust_color_for_background "$value" "$normal_bg" 4.5)"

  value="$(first_match "$file" '^[[:space:]]*alternate-normal-foreground:[[:space:]]*(#[0-9A-Fa-f]{6});$')"
  [ -n "$value" ] && [ -n "$alternate_bg" ] && set_rofi_value "$file" "alternate-normal-foreground" "$(adjust_color_for_background "$value" "$alternate_bg" 4.5)"

  value="$(first_match "$file" '^[[:space:]]*active-foreground:[[:space:]]*(#[0-9A-Fa-f]{6});$')"
  [ -n "$value" ] && [ -n "$active_bg" ] && set_rofi_value "$file" "active-foreground" "$(adjust_color_for_background "$value" "$active_bg" 4.5)"

  value="$(first_match "$file" '^[[:space:]]*urgent-foreground:[[:space:]]*(#[0-9A-Fa-f]{6});$')"
  [ -n "$value" ] && [ -n "$urgent_bg" ] && set_rofi_value "$file" "urgent-foreground" "$(adjust_color_for_background "$value" "$urgent_bg" 4.5)"

  if [ -n "$selected_bg" ]; then
    adjusted="$(adjust_color_for_background "#111111" "$selected_bg" 4.5)"
    if is_ratio_below "$(contrast_ratio "$adjusted" "$selected_bg")" 4.5; then
      adjusted="$(adjust_color_for_background "#F5F5F5" "$selected_bg" 4.5)"
    fi
    set_rofi_value "$file" "selected-normal-foreground" "$adjusted"
    set_rofi_value "$file" "selected-active-foreground" "$adjusted"
    set_rofi_value "$file" "selected-urgent-foreground" "$adjusted"
  fi
}

normalize_kitty
normalize_ghostty
normalize_rofi
