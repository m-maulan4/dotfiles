# Battery Low Notification Script
skrip baterai ini **jalan otomatis di systemd user session** setiap beberapa menit, tanpa perlu cron.

---

### 1️. Buat skrip notifikasi baterai

Buat folder jika belum ada

`mkdir -p ~/.local/bin/`

Misal letakkan di `~/.local/bin/battery-alert.sh`:

```bash
#!/bin/bash

# Ambil status baterai
battery_info=$(acpi -b)
percent=$(echo "$battery_info" | grep -oP '\d+(?=%)')
status=$(echo "$battery_info" | awk '{print $3}' | tr -d ',')

# Kirim notifikasi jika baterai rendah
if [[ "$status" == "Discharging" && "$percent" -lt 20 ]]; then
    notify-send -u critical "Baterai Lemah" "Sisa baterai: ${percent}%"
fi
```

Jangan lupa beri executable:

```bash
chmod +x ~/.local/bin/battery-alert.sh
```

---

### 2️. Buat systemd service user

Buat folder jika belum ada

`mkdir -p ~/.config/systemd/user/`

File: `~/.config/systemd/user/battery-alert.service`

```ini
[Unit]
Description=Notifikasi baterai lemah

[Service]
Type=oneshot
ExecStart=%h/.local/bin/battery-alert.sh
```

* `Type=oneshot` karena skrip cuma jalan sekali tiap pemanggilan.

---

### 3️. Buat systemd timer

File: `~/.config/systemd/user/battery-alert.timer`

```ini
[Unit]
Description=Timer untuk notifikasi baterai lemah

[Timer]
OnBootSec=2min
OnUnitActiveSec=5min
Persistent=true

[Install]
WantedBy=default.target
```

* `OnBootSec=2min` → jalankan 2 menit setelah login.
* `OnUnitActiveSec=5min` → jalankan ulang setiap 5 menit.
* `Persistent=true` → kalau komputer mati/hibernasi, jalankan segera saat kembali.

---

### 4️. Aktifkan service & timer

Jalankan perintah berikut:

```bash
systemctl --user daemon-reload
systemctl --user enable --now battery-alert.timer
```

* `enable` → supaya otomatis jalan tiap login.
* `--now` → langsung mulai timer sekarang juga.

---

✅ Sekarang, skrip akan **otomatis mengecek baterai setiap 5 menit** dan menampilkan notifikasi jika kurang dari 20%.