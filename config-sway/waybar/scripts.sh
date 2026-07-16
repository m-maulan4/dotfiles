#!/bin/bash

output=""

# Battery check
if [ -f /sys/class/power_supply/BAT0/capacity ]; then
    BAT=$(cat /sys/class/power_supply/BAT0/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT0/status)

    if [ "$STATUS" != "Charging" ] && [ "$BAT" -le 20 ]; then
        output+="󰂃 LOW BATTERY ${BAT}% "
    fi
fi

# Tambahkan notifikasi lain di sini nanti
# contoh:
# if kondisi; then
#     output+="󰀂 Update tersedia "
# fi

echo "$output"