#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# source https://wiki.archlinux.org/title/Hyprland#Using_a_script_to_change_wallpaper_every_X_minutes

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script uses bash (not POSIX shell) for the RANDOM variable

wallust_refresh=$HOME/.config/hypr/scripts/RefreshNoWaybar.sh

focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

if [[ $# -lt 1 ]] || [[ ! -d $1   ]]; then
	echo "Usage:
	$0 <dir containing images>"
	exit 1
fi

# Edit below to control the images transition
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_TYPE=simple

# This controls (in seconds) when to switch to the next image
INTERVAL=1800

# Minimum time (seconds) that must pass between wallpaper changes
# This prevents rapid changes after sleep/resume
MIN_CHANGE_INTERVAL=60

# Track last change time
last_change_time=0

# Check if system is preparing to sleep or just woke up
is_system_active() {
	# Check if system is inhibited for sleep
	if systemctl is-system-running 2>/dev/null | grep -q "stopping\|starting"; then
		return 1
	fi
	# Check for active sleep inhibitors that suggest imminent sleep
	if [[ -f /sys/power/state ]] && systemd-inhibit --list 2>/dev/null | grep -q "handle-suspend-key\|handle-lid-switch"; then
		return 0
	fi
	return 0
}

# Sleep-aware wrapper that won't trigger activity immediately after wake
smart_sleep() {
	local duration=$1
	local start_time=$(date +%s)
	local target_time=$((start_time + duration))
	
	while true; do
		local now=$(date +%s)
		local remaining=$((target_time - now))
		
		if [[ $remaining -le 0 ]]; then
			break
		fi
		
		# Sleep in smaller chunks to detect sleep/wake events
		# Use minimum of remaining time or 60 seconds
		local sleep_chunk=$((remaining < 60 ? remaining : 60))
		sleep "$sleep_chunk"
		
		# After waking from sleep, the elapsed time will be much greater
		# than our sleep_chunk, indicating system was suspended
		local after_sleep=$(date +%s)
		local actual_elapsed=$((after_sleep - now))
		
		# If we slept much longer than expected, system was suspended
		# Reset target to prevent immediate wallpaper change
		if [[ $actual_elapsed -gt $((sleep_chunk + 5)) ]]; then
			# System was asleep - wait the full interval from now
			target_time=$((after_sleep + duration))
			# Also wait a moment for system to stabilize after wake
			sleep 5
		fi
	done
}

while true; do
	find "$1" \
		| while read -r img; do
			echo "$((RANDOM % 1000)):$img"
		done \
		| sort -n | cut -d':' -f2- \
		| while read -r img; do
			current_time=$(date +%s)
			time_since_last=$((current_time - last_change_time))
			
			# Ensure minimum time between changes (prevents rapid changes after resume)
			if [[ $time_since_last -lt $MIN_CHANGE_INTERVAL ]] && [[ $last_change_time -ne 0 ]]; then
				sleep $((MIN_CHANGE_INTERVAL - time_since_last))
			fi
			
			# Only change wallpaper if system is fully active
			if is_system_active; then
				swww img -o $focused_monitor "$img"
				# Regenerate colors from the exact image path to avoid cache races
				$HOME/.config/hypr/scripts/WallustSwww.sh "$img"
				# Refresh UI components that depend on wallust output
				$wallust_refresh
				last_change_time=$(date +%s)
			fi
			
			smart_sleep $INTERVAL
		done
done
