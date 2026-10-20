#!/usr/bin/env bash

window_id=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | awk '{print $5}')
wm_class=$(xprop -id "$window_id" WM_CLASS 2>/dev/null | awk -F '"' '{print $4}')

# Cek kosong ATAU 0x0
if [ -z "$window_id" ] || [ "$window_id" = "0x0" ]; then
    echo "Desktop"
    exit 0
fi

# Cek WM_CLASS kosong (window hilang, override-redirect, dsb)
if [ -z "$wm_class" ]; then
    echo "Unknown"
    exit 0
fi

case "$wm_class" in
    com.microsoft.VSCode)
        echo "Visual Studio Code"
        ;;
    *)
        echo "$wm_class" |
            sed 's/-/ /g' |
            awk '{
                for (i = 1; i <= NF; i++)
                    $i = toupper(substr($i,1,1)) substr($i,2)
                print
            }'
        ;;
esac