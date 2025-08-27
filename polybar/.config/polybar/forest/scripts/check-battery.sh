#!/bin/sh

if [ -d "/sys/class/power_supply/BAT0" ] || [ -d "/sys/class/power_supply/BAT1" ]; then
    exit 0
else
    exit 1
fi
