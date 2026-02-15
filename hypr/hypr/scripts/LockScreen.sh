#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##

# For Hyprlock
# Use explicit config since this setup stores it as hyprlock-2k.conf.
LOCK_CONF="$HOME/.config/hypr/hyprlock-2k.conf"

# Ensure weather cache is up-to-date before locking (Waybar/lockscreen readers)
bash "$HOME/.config/hypr/UserScripts/WeatherWrap.sh" >/dev/null 2>&1

if pidof hyprlock >/dev/null 2>&1; then
    exit 0
fi

if [ -f "$LOCK_CONF" ]; then
    hyprlock -q -c "$LOCK_CONF" &
else
    hyprlock -q &
fi

sleep 0.2
loginctl lock-session
