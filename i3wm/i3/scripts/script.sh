#!/bin/bash

volume_up() {
    pactl set-sink-volume @DEFAULT_SINK@ +5%
    pkill -SIGRTMIN+10 i3blocks
}
volume_down() {
    pactl set-sink-volume @DEFAULT_SINK@ -5%
    pkill -SIGRTMIN+10 i3blocks
}
logout(){
    options="Logout\nSuspend\nReboot\nShutdown\nLock"
    chosen=$(echo -e "$options" | rofi -dmenu -p "Power Menu")
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
}
switch-workspaces(){
    workspaces=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused == false) | .name')
    if [ -z "$workspaces" ]; then
        notify-send -t 5000 "Tidak ada workspace yang aktif"
        exit 0
    fi
    selected=$(echo "$workspaces" | rofi -dmenu -p "Workspace")
    if [ -n "$selected" ]; then
        i3-msg workspace "$selected"
    fi
}
clipboard(){
    CLIPFILE="$HOME/.cache/clipboard_history.txt"
    save_clipboard() {
        local current
        current=$(xclip -o -selection clipboard 2>/dev/null)
        if [[ -n "$current" ]]; then
            grep -Fxv "$current" "$CLIPFILE" 2>/dev/null > "$CLIPFILE.tmp" 2>/dev/null || true
            echo "$current" >> "$CLIPFILE.tmp"
            mv "$CLIPFILE.tmp" "$CLIPFILE"
        fi
    }
    select_from_history() {
        local selected
        selected=$(tac "$CLIPFILE" | rofi -dmenu -i -p "Clipboard")
        if [[ -n "$selected" ]]; then
            echo -n "$selected" | xclip -selection clipboard
        fi
    }
    save_clipboard
    select_from_history
}

# printah terminal
case "$1" in
    volume_up)
        volume_up "$2"   
        ;;
    volume_down)
        volume_down "$2"   
        ;;
    logout)
        logout
        ;;
    switch-workspaces)
        switch-workspaces
        ;;
    clipboard)
        clipboard
        ;;
    *)
        exit 0
        ;;
esac
