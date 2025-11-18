Oke! Saya akan buatkan **README.md ringkas versi terbaru** yang sudah termasuk **menghubungkan Git ke GitHub menggunakan SSH**:

````markdown
# Instalasi dan Konfigurasi Git di Linux + GitHub SSH

## 1. Instal Git

### Debian/Ubuntu

```bash
sudo apt update
sudo apt install git
```

## 2. Konfigurasi Git

```bash
git config --global user.name "Nama Kamu"
git config --global user.email "emailkamu@example.com"
```

## 3. Ubah Branch Default ke `main`

```bash
git config --global init.defaultBranch main
```

## 4. Cek konfigurasi:

```bash
git config --list
```

## 5. Menghubungkan Git ke GitHub dengan SSH

### 5.1. Cek apakah sudah punya SSH key

```bash
ls ~/.ssh/id_rsa.pub
```

### 5.2. Jika belum, buat SSH key baru

```bash
ssh-keygen -t ed25519 -C "email_kamu@example.com"
```

Tekan Enter untuk menerima lokasi default, bisa juga beri passphrase.

### 5.3. Tambahkan SSH key ke ssh-agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### 5.4. Tambahkan SSH key ke GitHub

1. Salin key:

```bash
cat ~/.ssh/id_ed25519.pub
```

2. Masuk ke GitHub → Settings → SSH and GPG keys → New SSH key → Paste → Save

### 5.5. Cek koneksi

```bash
ssh -T git@github.com
```

Jika sukses, muncul pesan seperti:

```
Hi username! You've successfully authenticated.
```