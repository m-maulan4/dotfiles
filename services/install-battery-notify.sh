#!/bin/bash

set -e

SCRIPT="/usr/local/bin/battery-notify.sh"
SERVICE="/etc/systemd/system/battery-notify.service"
TIMER="/etc/systemd/system/battery-notify.timer"

echo "=========================================="
echo " Battery Notify"
echo " Root + X11 + Wayland"
echo "=========================================="
echo

# ----------------------------------------------------------
# Root check
# ----------------------------------------------------------

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Jalankan menggunakan sudo:"
    echo
    echo "  sudo ./install-battery-notify.sh"
    exit 1
fi

# ----------------------------------------------------------
# Check apt
# ----------------------------------------------------------

if ! command -v apt >/dev/null 2>&1; then
    echo "ERROR: Script ini membutuhkan apt."
    exit 1
fi

# ----------------------------------------------------------
# Install dependency
# ----------------------------------------------------------

echo "[1/4] Installing libnotify-bin..."

apt update
apt install -y libnotify-bin

# ----------------------------------------------------------
# Create battery notification script
# ----------------------------------------------------------

echo "[2/4] Creating battery script..."

cat > "$SCRIPT" <<'EOF'
#!/bin/bash

THRESHOLD=10

BATTERY=""
STATUS=""

for dir in /sys/class/power_supply/BAT*; do
    [ -d "$dir" ] || continue

    if [ -f "$dir/capacity" ]; then
        BATTERY=$(cat "$dir/capacity")
    fi

    if [ -f "$dir/status" ]; then
        STATUS=$(cat "$dir/status")
    fi

    break
done

# Tidak ada informasi baterai
[ -z "$BATTERY" ] && exit 0

# Jika sedang charging/full, jangan kirim notifikasi
case "$STATUS" in
    Charging|Full)
        exit 0
        ;;
esac

# Baterai masih di atas threshold
[ "$BATTERY" -gt "$THRESHOLD" ] && exit 0

# Kirim ke semua session graphical yang aktif
while read -r SESSION; do

    [ -z "$SESSION" ] && continue

    ACTIVE=$(loginctl show-session "$SESSION" \
        -p Active --value 2>/dev/null)

    TYPE=$(loginctl show-session "$SESSION" \
        -p Type --value 2>/dev/null)

    USER_ID=$(loginctl show-session "$SESSION" \
        -p User --value 2>/dev/null)

    USER_NAME=$(loginctl show-session "$SESSION" \
        -p Name --value 2>/dev/null)

    [ "$ACTIVE" = "yes" ] || continue
    [ "$TYPE" = "x11" ] || [ "$TYPE" = "wayland" ] || continue
    [ -n "$USER_ID" ] || continue
    [ -n "$USER_NAME" ] || continue

    RUNTIME="/run/user/$USER_ID"
    BUS="unix:path=$RUNTIME/bus"

    runuser -u "$USER_NAME" -- \
        env \
        XDG_RUNTIME_DIR="$RUNTIME" \
        DBUS_SESSION_BUS_ADDRESS="$BUS" \
        notify-send \
        -u critical \
        -t 3000 \
        -i battery-caution \
        "⚠️ Baterai Rendah" \
        "Baterai laptop tinggal ${BATTERY}%!" \
        >/dev/null 2>&1 || true

done < <(
    loginctl list-sessions --no-legend 2>/dev/null |
    awk '{print $1}'
)
EOF

chmod 755 "$SCRIPT"

# ----------------------------------------------------------
# Create systemd service
# ----------------------------------------------------------

echo "[3/4] Creating systemd service..."

cat > "$SERVICE" <<EOF
[Unit]
Description=Battery Low Notification
After=graphical.target
Wants=graphical.target

[Service]
Type=oneshot
ExecStart=$SCRIPT
EOF

# ----------------------------------------------------------
# Create timer
# ----------------------------------------------------------

echo "[4/4] Creating systemd timer..."

cat > "$TIMER" <<'EOF'
[Unit]
Description=Check battery every minute

[Timer]
OnBootSec=30s
OnUnitActiveSec=1min
Unit=battery-notify.service

[Install]
WantedBy=timers.target
EOF

# ----------------------------------------------------------
# Enable
# ----------------------------------------------------------

systemctl daemon-reload
systemctl enable --now battery-notify.timer

echo
echo "=========================================="
echo " Installation selesai!"
echo "=========================================="
echo

echo "Battery:"
cat /sys/class/power_supply/BAT*/capacity 2>/dev/null |
    head -n1 |
    sed 's/$/%/'

echo
echo "Timer:"
systemctl status battery-notify.timer --no-pager

echo
echo "Notification:"
echo "  Akan muncul setiap 1 menit jika baterai <= 10%."

echo
echo "Test manual:"
echo "  sudo $SCRIPT"

echo
echo "Log:"
echo "  journalctl -u battery-notify.service"
echo
