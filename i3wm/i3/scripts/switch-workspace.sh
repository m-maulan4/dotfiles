#!/bin/bash

# Ambil daftar workspace
workspaces=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused == false) | .name')
# Tampilkan workspace di rofi
selected=$(echo "$workspaces" | rofi -dmenu -p "Workspace")

# Jika tidak ada workspace non-aktif, keluar
if [ -z "$workspaces" ]; then
    notify-send -t 5000 "Tidak ada workspace yang aktif"
    exit 0
fi

# Pindah ke workspace yang dipilih
if [ -n "$selected" ]; then
    i3-msg workspace "$selected"
fi

