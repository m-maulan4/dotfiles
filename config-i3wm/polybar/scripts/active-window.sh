#!/bin/bash

window_id=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')

if [ "$window_id" != "0x0" ]; then
    xprop -id "$window_id" WM_CLASS 2>/dev/null |
        awk -F '"' '{print $4}' |
        sed 's/-/ /g' |
        awk '{
            for (i = 1; i <= NF; i++)
                $i = toupper(substr($i,1,1)) substr($i,2)
            print
        }'
else
    echo "Desktop"
fi