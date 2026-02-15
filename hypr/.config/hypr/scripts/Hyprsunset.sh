#!/usr/bin/env bash
set -euo pipefail

# Hyprsunset toggle + Waybar status helper
# Supports manual toggle and automatic scheduling (9pm-7am)
# Icons:
# - Off: bright sun
# - On: sunset icon if available, otherwise a blue sun
#
# Customize via env vars:
#   HYPRSUNSET_TEMP   default 4500 (K)
#   HYPRSUNSET_ICON_MODE  sunset|blue  (default: sunset)
#   HYPRSUNSET_START_HOUR  default 21 (9pm)
#   HYPRSUNSET_END_HOUR    default 7  (7am)

STATE_FILE="$HOME/.cache/.hyprsunset_state"
MANUAL_FILE="$HOME/.cache/.hyprsunset_manual"
TARGET_TEMP="${HYPRSUNSET_TEMP:-5000}"
ICON_MODE="${HYPRSUNSET_ICON_MODE:-sunset}"
START_HOUR="${HYPRSUNSET_START_HOUR:-21}"
END_HOUR="${HYPRSUNSET_END_HOUR:-7}"

ensure_state() {
  [[ -f "$STATE_FILE" ]] || echo "off" > "$STATE_FILE"
}

# Check if current time is within night hours (START_HOUR to END_HOUR)
is_night_hours() {
  local hour
  hour=$(date +%H)
  hour=${hour#0}  # Remove leading zero
  if (( START_HOUR > END_HOUR )); then
    # Night spans midnight (e.g., 21:00 - 07:00)
    (( hour >= START_HOUR || hour < END_HOUR ))
  else
    # Night within same day (e.g., 22:00 - 23:00)
    (( hour >= START_HOUR && hour < END_HOUR ))
  fi
}

# Clear manual override flag (called at schedule boundaries)
clear_manual_override() {
  rm -f "$MANUAL_FILE"
}

# Set manual override flag (called on manual toggle)
set_manual_override() {
  touch "$MANUAL_FILE"
}

# Check if manual override is active
has_manual_override() {
  [[ -f "$MANUAL_FILE" ]]
}

# Render icons using pango markup to allow colorization
icon_off() {
  # universally available sun symbol
  printf "☀"
}

icon_on() {
  case "$ICON_MODE" in
    sunset)
      # sunset emoji (falls back to tofu if no emoji font)
      printf "🌇"
      ;;
    blue)
      # no color in text; rely on CSS .on to style if desired
      printf "☀"
      ;;
    *)
      printf "☀"
      ;;
  esac
}

cmd_toggle() {
  ensure_state
  state="$(cat "$STATE_FILE" || echo off)"

  # Always stop any running hyprsunset first to avoid CTM manager conflicts
  if pgrep -x hyprsunset >/dev/null 2>&1; then
    pkill -x hyprsunset || true
    # give it a moment to release the CTM manager
    sleep 0.2
  fi

  # Mark as manual override so scheduler respects user choice
  set_manual_override

  if [[ "$state" == "on" ]]; then
    # Turning OFF: set identity and exit
    if command -v hyprsunset >/dev/null 2>&1; then
      nohup hyprsunset -i >/dev/null 2>&1 &
      # if hyprsunset persists, stop it shortly after applying identity
      sleep 0.3 && pkill -x hyprsunset || true
    fi
    echo off > "$STATE_FILE"
    notify-send -u low "Hyprsunset: Disabled" || true
  else
    # Turning ON: start hyprsunset at target temp in background
    if command -v hyprsunset >/dev/null 2>&1; then
      nohup hyprsunset -t "$TARGET_TEMP" >/dev/null 2>&1 &
    fi
    echo on > "$STATE_FILE"
    notify-send -u low "Hyprsunset: Enabled" "${TARGET_TEMP}K" || true
  fi
}

# Force ON (used by scheduler at 9pm)
cmd_on() {
  # Clear manual override at schedule boundary
  clear_manual_override
  
  ensure_state
  
  # Stop any running instance first
  if pgrep -x hyprsunset >/dev/null 2>&1; then
    pkill -x hyprsunset || true
    sleep 0.2
  fi

  # Start hyprsunset
  if command -v hyprsunset >/dev/null 2>&1; then
    nohup hyprsunset -t "$TARGET_TEMP" >/dev/null 2>&1 &
  fi
  echo on > "$STATE_FILE"
  notify-send -u low "Hyprsunset: Auto-enabled" "${TARGET_TEMP}K (scheduled)" || true
}

# Force OFF (used by scheduler at 7am)
cmd_off() {
  # Clear manual override at schedule boundary
  clear_manual_override
  
  ensure_state
  
  # Stop any running instance
  if pgrep -x hyprsunset >/dev/null 2>&1; then
    pkill -x hyprsunset || true
    sleep 0.2
  fi

  # Reset to identity
  if command -v hyprsunset >/dev/null 2>&1; then
    nohup hyprsunset -i >/dev/null 2>&1 &
    sleep 0.3 && pkill -x hyprsunset || true
  fi
  echo off > "$STATE_FILE"
  notify-send -u low "Hyprsunset: Auto-disabled" "(scheduled)" || true
}

# Auto-check: apply state based on current time (for startup/resume)
# Respects manual override if set
cmd_auto() {
  ensure_state
  
  # If manual override is set, just restore the saved state
  if has_manual_override; then
    cmd_init
    return
  fi

  # No manual override - apply schedule
  if is_night_hours; then
    # Night time - enable if not already on
    if ! pgrep -x hyprsunset >/dev/null 2>&1; then
      if command -v hyprsunset >/dev/null 2>&1; then
        nohup hyprsunset -t "$TARGET_TEMP" >/dev/null 2>&1 &
      fi
      echo on > "$STATE_FILE"
    fi
  else
    # Day time - disable if running
    if pgrep -x hyprsunset >/dev/null 2>&1; then
      pkill -x hyprsunset || true
      sleep 0.2
      if command -v hyprsunset >/dev/null 2>&1; then
        nohup hyprsunset -i >/dev/null 2>&1 &
        sleep 0.3 && pkill -x hyprsunset || true
      fi
    fi
    echo off > "$STATE_FILE"
  fi
}

cmd_status() {
  ensure_state
  # Prefer live process detection; fall back to state file
  if pgrep -x hyprsunset >/dev/null 2>&1; then
    onoff="on"
  else
    onoff="$(cat "$STATE_FILE" || echo off)"
  fi

  if [[ "$onoff" == "on" ]]; then
    txt="<span size='18pt'>$(icon_on)</span>"
    cls="on"
    tip="Night light on @ ${TARGET_TEMP}K"
  else
    txt="<span size='16pt'>$(icon_off)</span>"
    cls="off"
    tip="Night light off"
  fi
  printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$txt" "$cls" "$tip"
}

cmd_init() {
  ensure_state
  state="$(cat "$STATE_FILE" || echo off)"

  if [[ "$state" == "on" ]]; then
    if command -v hyprsunset >/dev/null 2>&1; then
      nohup hyprsunset -t "$TARGET_TEMP" >/dev/null 2>&1 &
    fi
  fi
}

case "${1:-}" in
  toggle) cmd_toggle ;;
  status) cmd_status ;;
  init)   cmd_init ;;
  on)     cmd_on ;;
  off)    cmd_off ;;
  auto)   cmd_auto ;;
  *) echo "usage: $0 [toggle|status|init|on|off|auto]" >&2; exit 2 ;;
esac
