#!/usr/bin/env bash
# Polybar Brightness Module - scroll naik/turun kecerahan ±5%

MIN=5
MAX=100

get_brightness() {
    if command -v brightnessctl &>/dev/null; then
        brightnessctl -m | awk -F, '{print $4}' | tr -d '%'
    elif command -v xbacklight &>/dev/null; then
        xbacklight -get | awk '{printf "%d", $1}'
    elif command -v light &>/dev/null; then
        light -G | awk '{printf "%d", $1}'
    else
        local dev=$(ls /sys/class/backlight/ 2>/dev/null | head -1)
        local cur=$(cat "/sys/class/backlight/$dev/brightness")
        local max=$(cat "/sys/class/backlight/$dev/max_brightness")
        echo $(( cur * 100 / max ))
    fi
}

set_brightness() {
    local value=$1
    (( value < MIN )) && value=$MIN
    (( value > MAX )) && value=$MAX

    if command -v brightnessctl &>/dev/null; then
        brightnessctl set "${value}%" -q
    elif command -v xbacklight &>/dev/null; then
        xbacklight -set "$value"
    elif command -v light &>/dev/null; then
        light -S "$value"
    else
        local dev=$(ls /sys/class/backlight/ | head -1)
        local max=$(cat "/sys/class/backlight/$dev/max_brightness")
        echo $(( value * max / 100 )) | sudo tee "/sys/class/backlight/$dev/brightness" > /dev/null
    fi
}

get_icon() {
    local b=$1
    if   (( b >= 75 )); then echo "󰃠"
    elif (( b >= 50 )); then echo "󰃟"
    elif (( b >= 25 )); then echo "󰃞"
    else                     echo "󰃝"
    fi
}

current=$(get_brightness)

case "$1" in
    up)
        set_brightness $(( current + 5 ))
        ;;
    down)
        set_brightness $(( current - 5 ))
        ;;
    *)
        icon=$(get_icon "$current")
        echo "${icon} ${current}%"
        ;;
esac