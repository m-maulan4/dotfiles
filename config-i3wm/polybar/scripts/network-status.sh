
#!/usr/bin/env bash

CONFIG="$HOME/.config/polybar/colors.ini"

# Ambil warna dari bagian [colors]
get_color() {
    awk -F '=' -v key="$1" '
        /^\[colors\]/ { section=1; next }
        /^\[/ { section=0 }
        section && $1 ~ "^[[:space:]]*" key "[[:space:]]*$" {
            gsub(/[[:space:]]/, "", $2)
            print $2
            exit
        }
    ' "$CONFIG"
}

PRIMARY=$(get_color primary)
ALERT=$(get_color alert)

interface=$(
    ip -o link show up |
    awk -F': ' '{print $2}' |
    sed 's/@.*//' |
    grep -v '^lo$' |
    while read -r iface; do
        if ip -4 addr show dev "$iface" scope global 2>/dev/null |
           grep -q 'inet '; then
            echo "$iface"
            break
        fi
    done
)

if [[ -z "$interface" ]]; then
    echo "%{F${ALERT}} Internet%{F-}"
elif [[ "$interface" =~ ^wl ]]; then
    echo "%{F${PRIMARY}} Internet%{F-}"
else
    echo "%{F${PRIMARY}} Internet%{F-}"
fi
