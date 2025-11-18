#!/bin/bash

# Pilihan menu
options="Logout\nSuspend\nReboot\nShutdown\nLock"

# Tampilkan rofi
chosen=$(echo -e "$options" | rofi -dmenu -p "Power Menu")

# Eksekusi berdasarkan pilihan
case "$chosen" in
    "Logout")
        i3-msg exit
        ;;
    "Suspend")
        systemctl suspend
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
    "Lock")
        i3lock -c 000000
        ;;
    *)
        exit 0
        ;;
esac
