# Sesudah Install Debian Netinst

## Package yang perlu di install

### 1. Update sistem dulu

```bash
sudo apt update
sudo apt upgrade
```

### 2. Paket dasar

```bash
sudo apt install sudo git htop unzip zip \
network-manager pipewire-audio
```

Kegunaan:

* `sudo` → menjalankan perintah sebagai admin
* `git` → version control
* `htop` → melihat proses
* `network-manager` → untuk koneksi jaringan
* `pipewire-audio` → paket komponen audio PipeWire

### 3. konfigurasi

#### Sudo
Masuk sebagai root: `su -`
Perintahnya `usermod -aG sudo username` 

Ganti username sesuai user untuk login (bukan root), lalu login ulang

#### NetworkManager

1. Pastikan config NetworkManager :
```bash
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true
```
konfigurasi : `/etc/NetworkManager/NetworkManager.conf`

2. Mengghindari Konflik dengan /etc/network/interfaces
Ubah config dengan mengubah :
``` bash
auto lo
iface lo inet loopback
```
3. Git

Perintah :

```bash
git config --global user.name "Nama Kamu"
git config --global user.email "emailkamu@example.com"
git config --global init.defaultBranch main
```
* Masukan sesuai nama kamu
* Masukan sesuai email kamu
* Untuk branch biarkan `main`

