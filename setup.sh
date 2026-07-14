#!/bin/bash
#TODO: Divide installations by domain. So this scripts becomes readable
#source packages/lsps.sh
set -e  # Stop on any error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== Installing base tools from official repos ===${NC}"
sudo pacman -S --needed --noconfirm \
    base-devel \
    git \
    wget \
    neovim

echo -e "${GREEN}=== Installing AUR helper (yay) ===${NC}"
if ! command -v yay &>/dev/null; then
    echo "yay not found. Building yay from AUR..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
else
    echo "yay already installed."
fi

echo -e "${GREEN}=== Core graphical environment & utilities (via pacman/yay) ===${NC}"
sudo pacman -S --needed --noconfirm \
    kitty \
    fastfetch \
    fish \
    rofi \
    xorg-xwayland \
    swaybg \
    waybar \
    swaylock \
    swayidle \
    wlr-randr \
    wl-clipboard \
    blueman \
    network-manager-applet \
    nodejs \
    npm \
    lua-language-server \
    gopls \
    rust-analyzer \
    zls \
    typescript-language-server \
    bash-language-server \
    marksman \
    pyright \
    taplo-cli \
    wiremix \
    erlang \
    elixir \
    odin \
    grim \
    slurp \
    playerctl \
    pamixer \
    pavucontrol \
    brightnessctl \
    sox \
    jq \
    xdg-desktop-portal-wlr \
    xdg-user-dirs \
    swaync \
    cliphist \
    swayosd \
    wlsunset \
    minicom \
    transmission-gtk \
    yazi \
    flatpak \
    raylib \
    gamemode \
    gnome-software \
    bottom \
    polkit-gnome \
    papirus-icon-theme \
    qt5ct \
    qt6ct \
    xorg-xhost \
    nautilus \
    gnome-calculator \
    gnome-calendar \
    gnome-text-editor \
    gnome-sound-recorder \
    gnome-clocks \
    gnome-font-viewer \
    gnome-online-accounts \
    gnome-online-accounts-gtk \
    gnome-keyring \
    decibels \
    loupe \
    file-roller \
    ffmpegthumbnailer \
    noto-fonts-emoji \
    gvfs \
    gvfs-dnssd \
    gvfs-gphoto2 \
    gvfs-nfs \
    gvfs-smb \
    gvfs-afc \
    gvfs-goa \
    gvfs-mtp \
    gvfs-onedrive \
    gvfs-wsdd \
    unrar \
    unzip \
    papers \
    calibre \
    snapshot \
    gimp \
    krita \
    libreoffice-fresh \
    libreoffice-fresh-es \
    libreoffice-fresh-zh-cn \
    hunspell \
    hunspell-es_any \
    hunspell-en_us \
    celluloid \
    baobab \
    onboard \
    bespokesynth \
    ardour \
    odin2-synthesizer-vst3 \
    surge-xt-vst3 \
    plymouth \
    gcc-fortran \
    gparted \
    steam \
    krita \
    freecad \
    kicad \
    kicad-library \
    kicad-demos \
    gnuchess \
    gnome-boxes \
    wine \
    winetricks \
    wine-mono \
    wine-gecko \
    vulkan-radeon \
    vkd3d

echo -e "${GREEN}=== AUR Packages ===${NC}"
yay -S --needed --noconfirm \
    vscode-langservers-extracted \
    mangowc \
    xfce-polkit \
    sway-audio-idle-inhibit-git \
    dimland \
    fortls \
    fish-lsp \
    fortran-fpm \
    wlogout \
    zen-browser-bin \
    asm-lsp \
    sql-language-server \
    elixir-ls \
    erlang_ls \
    flutter-bin \
    android-sdk \
    android-sdk-platform-tools \
    numix-cursor-theme-git \
    dimland-git \
    ttf-google-sans-code-vf \
    lidm-systemd \
    fingwit \
    tal-noisemaker-vst3-bin \
    pico-sdk \
    arduino-ide-bin \
    gapless \
    plymouth-theme-arch-charge \
    tuxguitar \
    localsend-bin \
    stockfish \
    heroic-games-launcher-bin \
    pixieditor-bin \
    esp-idf \
    xboxdrv \
    defold-bin

echo "Install astro language server from NPM"
sudo npm i -g @astrojs/language-server


echo -e "${YELLOW}=== All done! ===${NC}"
echo "Everything your configuration expects should now be installed."
echo "You may want to reboot or restart your session to start all services cleanly."

# Make all scripts executable
chmod +x mango/scripts/*.sh
chmod +x fish/*.fish

# Set fish as the default shell
chsh -s /usr/bin/fish

# Create user directories
xdg-user-dirs-update --force
xdg-user-dirs-gtk-update --force

# Add user to flutter group
sudo usermod -a -G flutter $(whoami)

sudo plymouth-set-default-theme -R arch-charge

# sudo systemctl enable plymouth.service

#NOTE: For plymouth to work append these options: (splash quiet loglevel=3) at the end of the options line
#of the .conf file in /boot/loader/entries/

sudo rm /etc/lidm.ini && sudo cp lidm.ini /etc/lidm.ini

# Enable display manager
sudo systemctl enable lidm

