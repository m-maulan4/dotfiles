# Setup Sway 

## Install Sway dan Package yang di perlukan

```bash
sudo apt install sway waybar xwayland \
xdg-desktop-portal-wlr grim \
slurp wl-clipboard thunar \
pipewire pipewire-pulse wireplumber \
pipewire-alsa alsa-utils pavucontrol\
greetd tuigreet
```
## Config
### Sway, waybar, fuzzel
Salin folder **sway**, **waybar**, dan **fuzzel** ke folder `~/.config`
### greetd + TUI greeter
`sudo systemctl enable greetd`
`sudo nano /etc/greetd/config.toml`
```bash
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --asterisks --user-menu --cmd sway"
user = "_greetd"
```