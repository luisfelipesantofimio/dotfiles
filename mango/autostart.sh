#!/usr/bin/env bash
set -euo pipefail

export LANG=es_CO.UTF-8
export QT_QPA_PLATFORMTHEME=qt6ct
export GTK_THEME=Adwaita-dark
export XCURSOR_THEME=Numix-Cursor-Light
export XCURSOR_SIZE=24
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$UID}"

# libadwaita / xdg-desktop-portal apps read these
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface cursor-theme 'Numix-Cursor-Light'
fi

run_bg() {
    local cmd="$1"
    if ! pgrep -f "${cmd}" >/dev/null 2>&1; then
        "$@" >/dev/null 2>&1 &
    fi
}

start_if_available() {
    local cmd="$1"
    shift
    if command -v "$cmd" >/dev/null 2>&1; then
        run_bg "$cmd" "$@"
    fi
}

# some env can't auto run the portal, so need this
systemctl --user start xdg-desktop-portal-gtk
start_if_available /usr/lib/xdg-desktop-portal-wlr

# notify
start_if_available swaync -c "$HOME/.config/mango/swaync/config.json" -s "$HOME/.config/mango/swaync/style.css"

# wallpaper
start_if_available swaybg -i "$HOME/.config/mango/wallpapers/PIA26077~orig.jpg"

# top bar
start_if_available waybar -c "$HOME/.config/mango/waybar/config.jsonc" -s "$HOME/.config/mango/waybar/style.css"

# xwayland dpi scale
if command -v xrdb >/dev/null 2>&1; then
    echo "Xft.dpi: 140" | xrdb -merge
fi

# keep clipboard content
start_if_available wl-clip-persist --clipboard regular --reconnect-tries 0

# clipboard content manager
start_if_available wl-paste --type text --watch cliphist store

# bluetooth
start_if_available blueman-applet

# network
start_if_available nm-applet

# inhibit by audio
start_if_available sway-audio-idle-inhibit

# change light value and volume value by swayosd-client in keybind
start_if_available swayosd-server

# Permission authentication
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
