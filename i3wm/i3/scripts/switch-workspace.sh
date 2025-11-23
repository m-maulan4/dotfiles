#!/bin/bash

# Ambil daftar workspace
workspaces=$(i3-msg -t get_workspaces | jq -r '.[].name')

# Tampilkan workspace di rofi
selected=$(echo "$workspaces" | rofi -dmenu -p "Workspace")

# Pindah ke workspace yang dipilih
if [ -n "$selected" ]; then
    i3-msg workspace "$selected"
fi
