# Battery Low Notification Script

Sebuah script shell untuk memantau status baterai di Linux dan memberikan notifikasi jika baterai rendah (<20%). Script ini dijalankan secara otomatis menggunakan `systemd user` timer setiap beberapa menit dan saat boot.

---

## Fitur

- Memeriksa status baterai (`Discharging`) dan persentase baterai.
- Memberikan notifikasi desktop menggunakan `notify-send` jika baterai kurang dari 20%.
- Dijalankan secara otomatis saat boot dan setiap interval tertentu (default: setiap 5 menit).
- Mendukung setup `systemd user`, sehingga berjalan tanpa hak root.
- Otomatis mendeteksi `DISPLAY` dan `DBUS_SESSION_BUS_ADDRESS` untuk notifikasi.

---

## Struktur File



~/scripts/battery_check.sh      # Script utama
~/.config/systemd/user/         # Folder systemd user
battery_check.service       # Systemd service
battery_check.timer         # Systemd timer

---

## Instalasi

1. **Buat direktori scripts** (jika belum ada):

```bash
mkdir -p ~/scripts
````

2. **Simpan script** `battery_check.sh` ke folder `~/scripts/` dan buat executable:

```bash
chmod +x ~/scripts/battery_check.sh
```

3. **Buat folder systemd user** (jika belum ada):

```bash
mkdir -p ~/.config/systemd/user
```

4. **Buat service** `battery_check.service`:

```ini
[Unit]
Description=Cek baterai dan beri notifikasi

[Service]
Type=oneshot
ExecStart=/home/username/scripts/battery_check.sh
```

> Ganti `/home/username/scripts/battery_check.sh` sesuai path script Anda.

5. **Buat timer** `battery_check.timer`:

```ini
[Unit]
Description=Timer untuk cek baterai setiap 5 menit

[Timer]
OnBootSec=1min
OnUnitActiveSec=5min
Unit=battery_check.service

[Install]
WantedBy=default.target
```

6. **Reload systemd user, aktifkan dan jalankan timer**:

```bash
systemctl --user daemon-reload
systemctl --user enable --now battery_check.timer
systemctl --user status battery_check.timer
```

---

## Cara Kerja

1. Script dijalankan oleh `systemd` setiap 5 menit dan saat boot.
2. Script memeriksa status baterai menggunakan `acpi`.
3. Jika status adalah `Discharging` dan persentase baterai < 20%, maka `notify-send` akan menampilkan peringatan.

---

## Tips

* Pastikan `acpi` dan `libnotify-bin` sudah terinstall:

```bash
sudo apt install acpi libnotify-bin
```

* Script otomatis mendeteksi session untuk notifikasi. Tidak perlu menjalankan dengan root.

* Untuk menyesuaikan interval cek, ubah `OnUnitActiveSec` di file `battery_check.timer`.

---

