#!/usr/bin/env bash

theme="$HOME/.config/polybar/forest/scripts/rofi/launcher.rasi"

options="
  Lock
  Suspend
  Logout
  Reboot
  Shutdown
"

chosen=$(echo "$options" | rofi -dmenu -theme "$theme" -p "Power")

confirm() {
	rofi -dmenu -theme "$theme" -p "Confirm: $1? [y/N]" <<<""
}

alert() {
	notify-send "Power Menu" "$1 action triggered."
	paplay /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null &
}

case "$chosen" in
"  Lock")
	loginctl lock-session && alert "Lock"

	;;
"  Suspend")
	confirm "Suspend" | grep -iq "^y" && {
		alert "Suspend"
		systemctl suspend
	}
	;;
"  Logout")
	confirm "Logout" | grep -iq "^y" && {
		alert "Logout"
		gnome-session-quit --logout --no-prompt
	}
	;;
"  Reboot")
	confirm "Reboot" | grep -iq "^y" && {
		alert "Reboot"
		systemctl reboot
	}
	;;
"  Shutdown")
	confirm "Shutdown" | grep -iq "^y" && {
		alert "Shutdown"
		systemctl poweroff
	}
	;;
esac
