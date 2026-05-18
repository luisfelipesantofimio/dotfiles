# Mango Configuration

This folder contains Mango compositor configuration and helper scripts for the Wayland session.

## What is here

- `config.conf` — Mango settings and key bindings
- `waybar/` — Waybar config and style for the top bar
- `wlogout/` — logout screen layout and styling
- `scripts/` — helper scripts for brightness, volume, screenshots, player control, suspend/restore, and more

## Common key bindings

### General
- `SUPER + r` — reload Mango config
- `Alt + Space` — launch `rofi`
- `Alt + Return` — launch `kitty`
- `SUPER + m` — quit Mango
- `Alt + q` — close the focused window

### Window focus / movement
- `SUPER + Tab` — cycle window focus
- `Alt + Arrow` — move focus between windows
- `SUPER + Shift + Arrow` — swap windows

### Window state
- `Alt + backslash` — toggle floating
- `Alt + a` — maximize window
- `Alt + f` — toggle fullscreen
- `Alt + Shift + f` — toggle fake fullscreen
- `Alt + z` — toggle scratchpad

### Tags / workspaces
- `Ctrl + 1..9` — switch to tag 1..9
- `Alt + 1..9` — move current window to tag 1..9
- `SUPER + Left/Right` — switch workspace
- `CTRL + Left/Right` — switch workspace and keep client
- `SUPER + ALT + Left/Right` — move current window to another monitor

### Screenshots
- `ImprPant` — full-screen screenshot
- `Shift + ImprPant` — area screenshot

### Volume / brightness
- `XF86AudioRaiseVolume` — increase volume
- `XF86AudioLowerVolume` — decrease volume
- `XF86AudioMute` — toggle mute
- `XF86MonBrightnessUp` — increase brightness
- `XF86MonBrightnessDown` — decrease brightness

### Misc
- `SUPER + h` — toggle Waybar on/off
- `SUPER + l` — lock screen with `swaylock`
- `SUPER + SHIFT + p` — swap primary display between internal and external when an external monitor is connected
- `SUPER + SHIFT + m` — enable mirror mode for internal and external screens when a common resolution is available

## Waybar features

- `tray` — system tray icons
- `wireplumber` — volume widget with scroll control
- `battery` — battery status
- `clock` — clock and calendar
- `custom/notification` — notification indicator
- `custom/power` — power menu and profile actions
- `custom/playerctl` — media controls

## Helper scripts

- `brightness.sh` — volume brightness notifications for `XF86MonBrightnessUp` / `XF86MonBrightnessDown`
- `volume.sh` — volume control and OSD via `swayosd-client`
- `screenshot.sh` — captures screenshots using `grim` and `slurp`
- `power-profile` — switches profile via `powerprofilesctl` or CPU governor
- `playerctl-waybar.sh` — supplies metadata to Waybar and handles media clicks
- `restart_wlsunset.sh` — restart `wlsunset` when display wakes
- `idle.sh` — idle/resume actions for `swayidle`
- `exitdim.sh` — called when display returns from dimming
- `hide_waybar_mango.sh` — toggles Waybar on/off
- `monitor.sh` — toggle the internal screen with `wlr-randr`
- `swap_screens.sh` — swap primary display between internal and external
- `mirror_screens.sh` — set both screens to mirror mode when possible

## Install / use

1. Link this folder to `~/.config/mango` using `simlink.sh` from the repo root.
2. Install required packages with `setup.sh` (Arch-based system).
3. Restart Mango or your Wayland session.
4. Launch `waybar` with `waybar -c ~/.config/mango/waybar/config.jsonc -s ~/.config/mango/waybar/style.css` if not started automatically.

## Notes

- `screenshot.sh` saves into `~/Imágenes/Screenshots`.
- `playerctl-waybar.sh` returns empty output when no player is active, so the media widget disappears cleanly.
- If a key binding does not work, make sure the script is executable and Mango is using the expected config path.
