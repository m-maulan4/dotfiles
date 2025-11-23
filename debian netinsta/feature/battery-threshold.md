## Battery charge threshold di ThinkPad (only)
---

## 1. **Cek apakah modul kernel tersedia**

ThinkPad menggunakan modul `tp_smapi` (untuk model lama) atau `thinkpad_acpi` (untuk model modern):

```bash
lsmod | grep -E 'tp_smapi|thinkpad_acpi'
```

> Beberapa ThinkPad modern hanya butuh `thinkpad_acpi`, sementara model lama juga memerlukan `tp_smapi`.

---

## 2. **Cek baterai**

Nama baterai biasanya:

```bash
ls /sys/class/power_supply/
```

Misal `BAT0`.

---

## 3. **Atur Threshold Manual**

Jika menggunakan `thinkpad_acpi`:

```bash
# Atur start charging
echo 40 | sudo tee /sys/class/power_supply/BAT0/charge_start_threshold

# Atur stop charging
echo 80 | sudo tee /sys/class/power_supply/BAT0/charge_stop_threshold
```

**Penjelasan:**

* `charge_start_threshold` → baterai mulai di-charge saat % baterai ≤ nilai ini
* `charge_stop_threshold` → baterai berhenti di-charge saat % baterai ≥ nilai ini

> Ganti `BAT0` jika baterai kamu berbeda.

---

## 4. **Buat agar permanen**

Supaya threshold tetap aktif setelah reboot, buat file systemd service misal `battery-threshold.service`:

```ini
[Unit]
Description=Set ThinkPad battery charge thresholds
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c "echo 40 > /sys/class/power_supply/BAT0/charge_start_threshold && echo 80 > /sys/class/power_supply/BAT0/charge_stop_threshold"

[Install]
WantedBy=multi-user.target
```

Simpan di `/etc/systemd/system/battery-threshold.service` lalu aktifkan:

```bash
sudo systemctl enable battery-threshold.service
sudo systemctl start battery-threshold.service
```

---

Dengan cara ini, **tidak perlu TLP** dan tetap bisa menjaga umur baterai.
