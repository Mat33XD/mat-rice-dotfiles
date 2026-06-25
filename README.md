# Hyprland Dotfiles

### Minimalist Wayland desktop environment built around Hyprland, Eww and Wallust, with dynamic theming and modular components.

![preview](./screenshots/main.webp)

## Stack

- Hyprland (Wayland compositor)
- Eww (widgets / dashboard)
- Wofi (launcher)
- Kitty (terminal)
- Mako (notifications)
- Cava (audio visualizer)
- Fastfetch (system info)
- MPD + MPC + rmpc (music system)
- Starship (shell prompt)
- Wallust (dynamic color generation)

## Dependencies

```
-Core system

hyprland
eww
kitty
wofi
mako
wallust

- Utilities

cava
fastfetch
mpd
mpc
rmpc
starship
brightnessctl
grim
slurp
wl-clipboard
nmcli
bluez
blueman
pavucontrol
```
![preview](./screenshots/kitty.webp)

## Installation

#### 1. Clone dotfiles

```
git clone <repo-url>
cd dotfiles
```

#### 2. Copy settings

```
cp -r hypr ~/.config/
cp -r eww ~/.config/
cp -r kitty ~/.config/
cp -r wofi ~/.config/
cp -r mako ~/.config/
cp -r cava ~/.config/
cp -r fastfetch ~/.config/
cp -r rmpc ~/.config/
cp -r wallust ~/.config/
cp starship.toml ~/.config/
```

#### 3. Environment variables for wallpapers

For the folder:
```
export WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
```

For the default wallpaper:
```
export DEFAULT_WALLPAPER="$WALLPAPER_DIR/default.jpg"
```

#### 4. Script permissions

```
chmod +x ~/.config/eww/scripts/*.sh
chmod +x ~/.config/hypr/scripts/*.sh
```

#### 5. Services required

```
systemctl --user enable mpd
systemctl enable bluetooth
```

## Notes

Wallpapers are not included.
Some themes/fonts must be installed manually.
Bluetooth widgets require BlueZ service enabled.
