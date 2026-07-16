# Setup Sway

## Package yang perlu di install

### 1. Paket dasar

```bash
sudo apt install sway wayabr mako-notifier grim nwg_look \
xdg-desktop-portal-wlr fonts-jetbrains-mono
```

Kegunaan:

* `sway` → Window manager Wayland
* `waybar` → Status bar
* `mako-notifier` → Notification daemon
* `grim` → Screenshot
* `slurp` → Area selection screenshot
* `wl-clipboard` Clipboard Wayland
* `brightnessctl` Kontrol brightness
* `pavucontrol` → Mengontrol audio pipewire
* `nwg_look` → Aplikasi untuk pengaturan antarmuka 
* `xdg-desktop-portal-wlr` → Menangani fitur khusus Wayland/wlroots seperti screen sharing, screencast, dan screenshot melalui portal
* `fonts-jetbrains-mono` → font

### 2. konfigurasi
#### Install font awesome
1. Unduh paket Font Awesome versi "Free for Desktop" [visit](https://fontawesome.com/download)
2. Ekstrak file zip tersebut
3. Buat folder baru untuk Font Awesome
```bash
sudo mkdir -p /usr/share/fonts/truetype/fontawesome
```
4. Salin semua font
```bash
sudo cp path/ke/folder/extrak/otfs/*.otf /usr/share/fonts/truetype/fontawesome/
```
5. Pastikan font sudah terpasang
```bash
sudo fc-cache -f -v
```
#### konfigurasi style sway, waybar, fuzzel
Salin folder **sway**, **waybar**, dan **fuzzel** ke folder `~/.config`
