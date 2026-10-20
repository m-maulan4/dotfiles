
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

# Deteksi interface aktif dengan IPv4 global
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

# Tampilkan status koneksi
if [[ -z "$interface" ]]; then
    echo "%{F${ALERT}} Internet%{F-}"

elif [[ "$interface" =~ ^wl ]]; then
    # Ambil SSID Wi-Fi aktif dari NetworkManager
    SSID=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null |
           awk -F: '$1 == "yes" {sub(/^[^:]*:/, ""); print; exit}')

    # Batasi SSID maksimal 10 karakter + ...
    if [[ ${#SSID} -gt 10 ]]; then
        SSID="$(printf '%s' "$SSID" | cut -c1-10)..."
    fi

    # Tampilkan nama Wi-Fi
    if [[ -n "$SSID" ]]; then
        echo "%{F${PRIMARY}} ${SSID}%{F-}"
    else
        echo "%{F${ALERT}} Wi-Fi%{F-}"
    fi

else
    echo "%{F${PRIMARY}} Ethernet%{F-}"
fi
