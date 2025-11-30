#!/usr/bin/env bash

# ----------------------------
# CONFIG PATHS
# ----------------------------
DOTFILES="$HOME/i3-Dotfiles"
BACKUP="$HOME/Dotfiles-Backup"

# Check if the dotfiles repo exists
if [ ! -d "$DOTFILES" ]; then
    echo "Error: $DOTFILES does not exist. Please clone the repo first."
    exit 1
fi

# ----------------------------
# CREATE CONFIG AND BACKUP DIRS
# ----------------------------
mkdir -p ~/.config/i3
mkdir -p ~/.config/polybar
mkdir -p ~/.config/rofi
mkdir -p ~/.config/alacritty
mkdir -p ~/Documents/Ascii-Art
mkdir -p "$BACKUP"

# ----------------------------
# FUNCTION TO BACKUP FILES
# ----------------------------
backup_file() {
    if [ -e "$1" ]; then
        mv "$1" "$BACKUP/$(basename "$1").backup"
        echo "Backed up $1 to $BACKUP/$(basename "$1").backup"
    fi
}

# Backup existing configs
backup_file ~/.bashrc
backup_file ~/.config/i3/config
backup_file ~/.config/polybar/config.ini
backup_file ~/.config/polybar/launch.sh
backup_file ~/.config/rofi/config.rasi
backup_file ~/.config/alacritty/alacritty.toml
backup_file ~/Documents/Ascii-Art/terminal.txt
backup_file ~/.config/i3/lock.sh

# ----------------------------
# PACMAN PACKAGES
# ----------------------------
pacman_packages=(
    fakeroot
    base-devel
    picom
    nitrogen
    rofi
    polybar
    alacritty
    pv
    htop
    gnome-terminal
    imagemagick
    scrot
    zathura
    zathura-pdf-mupdf
)

echo "Installing missing pacman packages..."
for pkg in "${pacman_packages[@]}"; do
    if ! pacman -Qi $pkg &> /dev/null; then
        echo "Installing $pkg..."
        sudo pacman -S --needed --noconfirm $pkg
    else
        echo "$pkg is already installed."
    fi
done

# ----------------------------
# AUR PACKAGES VIA YAY
# ----------------------------
aur_packages=(
    "yay"
    "i3lock-color"               # Pixelated lockscreen
    "ttf-jetbrains-mono-nerd"    # Nerd Font for i3/polybar/rofi
)

# Install yay if missing
if ! command -v yay &> /dev/null; then
    echo "Installing yay from AUR..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay || exit
    makepkg -si --noconfirm
    cd ~ || exit
fi

echo "Installing AUR packages..."
for pkg in "${aur_packages[@]}"; do
    if ! pacman -Qi $pkg &> /dev/null; then
        echo "Installing $pkg via yay..."
        yay -S --needed --noconfirm $pkg
    else
        echo "$pkg is already installed."
    fi
done

# ----------------------------
# SYMLINK CONFIGS
# ----------------------------
ln -sf "$DOTFILES/Bash Config/bashrc" ~/.bashrc
ln -sf "$DOTFILES/Bash Config/terminal.txt" ~/Documents/Ascii-Art/terminal.txt
ln -sf "$DOTFILES/i3-Config/config" ~/.config/i3/config
ln -sf "$DOTFILES/i3-Config/lock.sh" ~/.config/i3/lock.sh
ln -sf "$DOTFILES/Polybar Config/config.ini" ~/.config/polybar/config.ini
ln -sf "$DOTFILES/Polybar Config/launch.sh" ~/.config/polybar/launch.sh
ln -sf "$DOTFILES/Rofi Config/config.rasi" ~/.config/rofi/config.rasi
ln -sf "$DOTFILES/Alacritty Config/alacritty.toml" ~/.config/alacritty/alacritty.toml
ln -sf "$DOTFILES/Zathura Config/zathurarc" ~/.config/zathura/zathurarc

# Make launch and lock scripts executable
chmod +x ~/.config/polybar/launch.sh
chmod +x ~/.config/i3/lock.sh

# ----------------------------
# FINAL CHECKS
# ----------------------------
for cmd in i3 polybar rofi alacritty i3lock; do
    if ! command -v $cmd &> /dev/null; then
        echo "Warning: $cmd is not installed. Please install it."
    fi
done

echo "------------------------------------------------"
echo "✅ Dotfiles installed and symlinked successfully!"
echo "Backups of previous configs are in $BACKUP"
echo "------------------------------------------------"
