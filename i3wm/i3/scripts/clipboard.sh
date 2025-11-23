#!/bin/bash

# File history clipboard
CLIPFILE="$HOME/.cache/clipboard_history.txt"

# Fungsi: simpan clipboard saat ini
save_clipboard() {
    local current
    current=$(xclip -o -selection clipboard 2>/dev/null)
    if [[ -n "$current" ]]; then
        # Hapus duplikat sebelumnya
        grep -Fxv "$current" "$CLIPFILE" 2>/dev/null > "$CLIPFILE.tmp" 2>/dev/null || true
        echo "$current" >> "$CLIPFILE.tmp"
        mv "$CLIPFILE.tmp" "$CLIPFILE"
    fi
}

# Fungsi: tampilkan Rofi dan pilih item
select_from_history() {
    # tampilkan history terbaru di atas
    local selected
    selected=$(tac "$CLIPFILE" | rofi -dmenu -i -p "Clipboard")
    if [[ -n "$selected" ]]; then
        echo -n "$selected" | xclip -selection clipboard
        # Optional: juga output ke stdout jika mau
        echo "$selected"
    fi
}

# Simpan clipboard terbaru dulu
save_clipboard

# Tampilkan menu
select_from_history
