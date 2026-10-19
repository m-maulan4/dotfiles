#!/bin/sh
# /root/wifi-failover.sh

PING_TARGET_1="1.1.1.1"
PING_TARGET_2="8.8.8.8"
PING_COUNT=3
PING_TIMEOUT=2
WIFINETS="wifinet1 wifinet2"
WAIT_AFTER_RELOAD=8

log() {
    # kirim ke syslog
    logger -t wifi-failover "$*"
    # tetap tampil di layar saat dijalankan manual
    echo "$*"
}

check_ping() {
    ping -c "$PING_COUNT" -W "$PING_TIMEOUT" "$PING_TARGET_1" >/dev/null 2>&1 && return 0
    ping -c "$PING_COUNT" -W "$PING_TIMEOUT" "$PING_TARGET_2" >/dev/null 2>&1 && return 0
    return 1
}

activate_only() {
    local target="$1"
    for w in $WIFINETS; do
        if [ "$w" = "$target" ]; then
            uci set wireless.$w.disabled='0'
        else
            uci set wireless.$w.disabled='1'
        fi
    done
    uci commit wireless
    wifi reload
    sleep "$WAIT_AFTER_RELOAD"
}

# --- Main ---
if check_ping; then
    log "Koneksi OK, tidak ada rotasi."
    exit 0
fi

log "Koneksi gagal. Mulai rotasi wifinet..."

for w in $WIFINETS; do
    log "Mencoba aktifkan $w ..."
    activate_only "$w"

    if check_ping; then
        log "BERHASIL via $w"
        exit 0
    fi
    log "$w gagal ping."
done

log "SEMUA wifinet gagal. Tidak ada koneksi."
exit 1