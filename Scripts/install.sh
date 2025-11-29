#!/usr/bin/env bash

DOTFILES="$HOME/i3-Dotfiles"
BACKUP="$HOME/Dotfiles-Backup"

# Check if the dotfiles repo exists
if [ ! -d "$DOTFILES" ]; then
    echo "Error: $DOTFILES does not exist. Please clone the repo first."
    exit 1
fi

# Create config and backup directories
mkdir -p ~/.config/i3
mkdir -p ~/.config/polybar
mkdir -p ~/.config/rofi
mkdir -p ~/.config/alacritty
mkdir -p ~/Documents/Ascii-Art
mkdir -p "$BACKUP"

# Function to backup existing files
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

# ----------------------------
# Install dependencies (Arch/Manjaro)
# ----------------------------
packages=(
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
)

echo "Checking for missing packages..."
for pkg in "${packages[@]}"; do
    if ! pacman -Qi $pkg &> /dev/null; then
        echo "Installing $pkg..."
        sudo pacman -S --needed --noconfirm $pkg
    else
        echo "$pkg is already installed."
    fi
done

# Install Nerd Fonts (e.g., FiraCode Nerd Font) via yay if available
if command -v yay &> /dev/null; then
    if ! pacman -Qi ttf-fira-code-nerd &> /dev/null; then
        echo "Installing FiraCode Nerd Font..."
        yay -S --needed --noconfirm ttf-fira-code-nerd
    else
        echo "FiraCode Nerd Font already installed."
    fi
else
    echo "Warning: 'yay' not found. Please install Nerd Fonts manually."
fi

# ----------------------------
# Symlink configs
# ----------------------------
ln -sf "$DOTFILES/Bash Config/bashrc" ~/.bashrc
ln -sf "$DOTFILES/Bash Config/terminal.txt" ~/Documents/Ascii-Art/terminal.txt
ln -sf "$DOTFILES/i3-Config/config" ~/.config/i3/config
ln -sf "$DOTFILES/Polybar Config/config.ini" ~/.config/polybar/config.ini
ln -sf "$DOTFILES/Polybar Config/launch.sh" ~/.config/polybar/launch.sh
ln -sf "$DOTFILES/Rofi Config/config.rasi" ~/.config/rofi/config.rasi
ln -sf "$DOTFILES/Alacritty Config/alacritty.toml" ~/.config/alacritty/alacritty.toml

# Make launch scripts executable
chmod +x ~/.config/polybar/launch.sh

# Check for essential programs
for cmd in i3 polybar rofi alacritty; do
    if ! command -v $cmd &> /dev/null; then
        echo "Warning: $cmd is not installed. Please install it."
    fi
done

echo "Dotfiles installed and symlinked successfully! 🚀"
echo "Backups of previous configs are in $BACKUP"
