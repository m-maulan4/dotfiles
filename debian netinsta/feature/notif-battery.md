# Battery Low Notification Script
skrip baterai ini **jalan otomatis di systemd user session** setiap beberapa menit, tanpa perlu cron.

---

## 1️. Buat skrip notifikasi baterai

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
    notify-send -u critical -t 5000 "Baterai Lemah" "Sisa baterai: ${percent}%"
fi
```

Jangan lupa beri executable:

```bash
chmod +x ~/.local/bin/battery-alert.sh
```

---

## 2️. Buat systemd service user

Buat folder jika belum ada

`mkdir -p ~/.config/systemd/user/`

File: `~/.config/systemd/user/battery-alert.service`

```ini
[Unit]
Description=Notifikasi baterai lemah

[Service]
Type=oneshot
EnvironmentFile=%h/.config/systemd/user/battery-env.conf
ExecStart=%h/.local/bin/battery-alert.sh
```

* `Type=oneshot` karena skrip cuma jalan sekali tiap pemanggilan.

---
## 3️. Buat file environment otomatis

File: `~/.config/systemd/user/battery-env.conf`

Isi file ini bisa dibuat otomatis saat login i3wm:

```bash
DISPLAY=:0
DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
```

Kita bisa **otomatiskan pengisiannya**. Tambahkan ini di `.xprofile` atau `.xinitrc`:

path (jika tidak ada buat dulu filenya):
`~/.xinitrc`

```bash
echo "DISPLAY=$DISPLAY" > ~/.config/systemd/user/battery-env.conf
echo "DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" >> ~/.config/systemd/user/battery-env.conf
```
> Pastikan dalam file `.xinitrc` ada baris perintah `exec i3` supaya bisa login lewat startx di terminal tty.

* Jadi setiap login X session, `battery-env.conf` diperbarui otomatis.
* Service systemd membaca environment ini, jadi tidak perlu hardcode.
---

## 4. Buat systemd timer

File: `~/.config/systemd/user/battery-alert.timer`

```ini
[Unit]
Description=Timer untuk notifikasi baterai lemah

[Timer]
OnBootSec=2min
OnUnitActiveSec=1min
Persistent=true

[Install]
WantedBy=default.target
```

* `OnBootSec=2min` → jalankan 2 menit setelah login.
* `OnUnitActiveSec=1min` → jalankan ulang setiap 1 menit.
* `Persistent=true` → kalau komputer mati/hibernasi, jalankan segera saat kembali.

---

## 5. Aktifkan service & timer

Jalankan perintah berikut:

```bash
systemctl --user daemon-reload
systemctl --user enable --now battery-alert.timer
```

* `enable` → supaya otomatis jalan tiap login.
* `--now` → langsung mulai timer sekarang juga.

---

## 6. Cek dunst pada config I3WM

tambahakan perintah `exec_always --no-startup-id pkill dunst; dunst &` di file `~/.config/i3/config` supaya notify-send berlajan.

----

✅ Sekarang, skrip akan **otomatis mengecek baterai setiap 1 menit** dan menampilkan notifikasi jika kurang dari 20%.