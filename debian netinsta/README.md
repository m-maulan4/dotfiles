# Debian Netinstall + i3 Minimal Setup

Panduan singkat instalasi Debian Netinstall dengan tiling window manager **i3** dan konfigurasi dasar yang ringan serta fungsional.

## Paket yang Diinstall

```bash
# Tiling WM + Xorg
i3 xorg

# File manager
thunar thunar-archive-plugin

# Terminal
xfce4-terminal

# Audio (PipeWire)
pipewire pipewire-audio-client-libraries pipewire-pulse

# Network
network-manager

# Notifikasi
libnotify-bin dunst

# Screenshot
scrot

#Clipboard CLI
xclip
```

## Perbaikan / Fix yang Diperlukan

### 1. Audio (PipeWire)
Karena menggunakan **PipeWire**, tombol volume multimedia harus diarahkan ke `wpctl` (bukan `amixer` atau `pactl`).

**Lokasi konfigurasi**:  
`~/.config/i3/config`

**Tambahkan/ganti baris berikut**:
```bash
# Volume control (PipeWire)
bindsym XF86AudioRaiseVolume exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ && $refresh_i3status
bindsym XF86AudioLowerVolume exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05- && $refresh_i3status
bindsym XF86AudioMute exec --no-startup-id wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && $refresh_i3status
bindsym XF86AudioMicMute exec --no-startup-id wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && $refresh_i3status
```

> Catatan: `--no-startup-id` ditambahkan agar tidak muncul notifikasi berulang.

### 2. Network Manager
Agar **NetworkManager** dapat mengatur Wi-Fi dengan benar, nonaktifkan konfigurasi manual di `interfaces`.

**Lokasi konfigurasi**:  
`/etc/network/interfaces`

**Komentari (tambahkan `#`) baris berikut**:
```bash
allow-hotplug wlp3s0
iface wlp3s0 inet dhcp
wpa-ssid NamaWifiKamu
wpa-psk PasswordWifiKamu
```

Setelah itu, restart NetworkManager:
```bash
sudo systemctl restart NetworkManager
```

Sekarang Wi-Fi bisa dikelola lewat `nmtui`.

### 3. Merubah format input pada terminal

**Lokasi konfigurasi**: 
`.bashrc`


**Tambah atau ganti kode ini**:
```bash
# untuk user
PS1="\[\e[01;32m\][\u]\[\e[0m\] \[\e[01;34m\]\w\[\e[0m\]\n=> "
# untuk root 
PS1="\[\e[01;31m\][\u]\[\e[0m\] \[\e[01;34m\]\w\[\e[0m\]\n=> "
alias ls='ls --color=auto'
```

## Selesai!
Setup Debian + i3 kamu sekarang sudah ringan, stabil, dan fungsional.