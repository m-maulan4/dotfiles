#!/bin/bash

TAG="PING"
HOST1="1.1.1.1"
HOST2="8.8.8.8"

WAIT=5
RETRY_WAIT=2
CHECK_INTERVAL=10

cek_ping() {
    ping -c 1 -W 1 "$HOST1" >/dev/null 2>&1 ||
    ping -c 1 -W 1 "$HOST2" >/dev/null 2>&1
}

log() {
    logger -t "$TAG" "$1"
}

while true; do

    # 1. Cek koneksi internet
    if cek_ping; then
        sleep "$CHECK_INTERVAL"
        continue
    fi

    log "Internet gagal, menjalankan wifi reload"

    # 2. Reload Wi-Fi
    wifi reload
    sleep "$WAIT"

    # 3. Cek koneksi setelah reload
    if cek_ping; then
        log "Internet pulih setelah wifi reload"
        continue
    fi

    log "Masih gagal, memeriksa konfigurasi Wi-Fi"

    # 4. Pastikan kedua section tersedia
    if ! uci -q get wireless.wifinet1 >/dev/null 2>&1 ||
       ! uci -q get wireless.wifinet2 >/dev/null 2>&1; then
        log "ERROR: wireless.wifinet1 atau wifinet2 tidak ditemukan"
        sleep "$RETRY_WAIT"
        continue
    fi

    # 5. Tentukan target berdasarkan konfigurasi
    WIFI1=$(uci -q get wireless.wifinet1.disabled)
    WIFI2=$(uci -q get wireless.wifinet2.disabled)

    if [ "$WIFI1" = "1" ]; then
        TARGET="wireless.wifinet1"
        OTHER="wireless.wifinet2"
    elif [ "$WIFI2" = "1" ]; then
        TARGET="wireless.wifinet2"
        OTHER="wireless.wifinet1"
    else
        # Keduanya aktif: bergantian berdasarkan target sebelumnya
        LAST=$(uci -q get system.ping_recovery.last)

        if [ "$LAST" = "wireless.wifinet1" ]; then
            TARGET="wireless.wifinet2"
            OTHER="wireless.wifinet1"
        else
            TARGET="wireless.wifinet1"
            OTHER="wireless.wifinet2"
        fi
    fi

    # 6. Simpan target agar percobaan berikutnya bergantian
    uci set system.ping_recovery=ping_recovery
    uci set system.ping_recovery.last="$TARGET"
    uci commit system

    # 7. Aktifkan target dan nonaktifkan lainnya
    uci set "$TARGET.disabled=0"
    uci set "$OTHER.disabled=1"
    uci commit wireless

    log "Mengaktifkan $TARGET dan menonaktifkan $OTHER"

    # 8. Reload dan tunggu koneksi
    wifi reload
    sleep "$WAIT"

    # 9. Cek hasil
    if cek_ping; then
        log "Internet pulih menggunakan $TARGET"
    else
        log "Internet masih gagal, mengulang proses dari awal"
        sleep "$RETRY_WAIT"
    fi

done
