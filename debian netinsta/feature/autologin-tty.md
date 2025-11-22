# Auto login di TTY

---

### 1. Identifikasi TTY

Secara default, Debian menggunakan **systemd** untuk mengelola login di TTY. Misalnya, TTY1 biasanya ada di `/dev/tty1`.

---

### 2. Edit unit systemd untuk getty

Kamu harus mengubah konfigurasi `getty` untuk TTY tertentu.

1. **Buka terminal (sebagai root atau gunakan sudo):**

   ```bash
   sudo nano /etc/systemd/system/getty@tty1.service.d/override.conf
   ```

2. **Jika folder `override.conf` belum ada, buat strukturnya:**

   ```bash
   sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
   sudo nano /etc/systemd/system/getty@tty1.service.d/override.conf
   ```

3. **Isi file dengan konfigurasi auto-login:**
   Misalnya login sebagai user `myuser`:

   ```
   [Service]
   ExecStart=
   ExecStart=-/sbin/agetty --autologin myuser --noclear %I $TERM
   ```

   ⚠️ Penjelasan:

   * `ExecStart=` pertama untuk **menghapus command default**.
   * `--autologin myuser` untuk auto-login user `myuser`.
   * `--noclear` supaya layar TTY tidak dibersihkan saat boot.

---

### 3. Reload systemd dan restart getty

Setelah file dibuat, jalankan:

```bash
sudo systemctl daemon-reexec
sudo systemctl restart getty@tty1
```

> Sekarang saat reboot, TTY1 akan otomatis login sebagai `myuser`.

---

### 4. Tips keamanan

* **Hanya lakukan auto-login pada TTY yang aman**, jangan pada TTY yang bisa diakses publik.
* Jika PC kamu bisa diakses orang lain, **auto-login bisa menjadi risiko keamanan**.
* Untuk sistem yang terhubung ke jaringan publik, sebaiknya **gunakan auto-login hanya di TTY non-root**.

---