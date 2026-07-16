# Setup Sway

## Package yang perlu di install

### 1. Paket dasar

```bash
sudo apt install sway waybar mako-notifier grim slurp nwg_look \
brightnessctl xdg-desktop-portal-wlr fonts-jetbrains-mono \
pavucontrol greetd tuigreet
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
* ` greetd` → Daemon login minimal
* `tuigreet` → Antarmuka login TUI 

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
#### Konfigurasi style sway, waybar, fuzzel
Salin folder **sway**, **waybar**, dan **fuzzel** ke folder `~/.config`

#### Konfigurasi Greetd dan TUIGreet
1. Edit file `sudo nano etc/greetd/config.toml` dan masukan atau ubah seperti ini :

```bash
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --remember --asterisks --theme 'container=black;border=magenta;title=lightmagenta;text=white;greet=lightmagenta;prompt=magenta;input=white;time=cyan;action=lightblue;button=yellow' --cmd sway"
user = "_greetd"
```
2. Disable agetty@1
```bash
sudo systemctl stop getty@tty1.service
sudo systemctl disable getty@tty1.service
sudo systemctl mask getty@tty1.service
```