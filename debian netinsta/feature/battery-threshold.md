Oke! Kalau ingin **mengatur battery threshold otomatis dengan hak akses root** tanpa harus memasukkan password di i3wm, cara paling aman adalah membuat **systemd service**. Berikut panduan lengkap:

---

## 1. Buat script untuk mengatur threshold

Buat file misal `/usr/local/bin/battery-threshold.sh`:

```bash
nano /usr/local/bin/battery-threshold.sh
```

Isi dengan:

```bash
#!/bin/bash

# Cek apakah file threshold ada
if [ -f /sys/class/power_supply/BAT0/charge_control_start_threshold ] && [ -f /sys/class/power_supply/BAT0/charge_control_end_threshold ]; then
    echo 40 > /sys/class/power_supply/BAT0/charge_control_start_threshold
    echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold
fi
```

Beri hak eksekusi:

```bash
chmod +x /usr/local/bin/battery-threshold.sh
```

---

## 2. Buat systemd service

Buat file service di `/etc/systemd/system/battery-threshold.service`:

```bash
nano /etc/systemd/system/battery-threshold.service
```

Isi dengan:

```ini
[Unit]
Description=Set battery charge thresholds
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/battery-threshold.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

---

## 3. Aktifkan dan jalankan service

```bash
systemctl daemon-reload
systemctl enable battery-threshold.service
systemctl start battery-threshold.service
```

* `enable` → otomatis jalan saat boot
* `start` → jalan sekarang tanpa reboot

---

Sekarang **setiap boot**, threshold baterai akan otomatis diset ke **40% start** dan **80% end**.