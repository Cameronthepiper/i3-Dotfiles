#!/usr/bin/env bash
DOTFILES="$HOME/i3-Dotfiles"

# Create config directories if missing
mkdir -p ~/.config/i3
mkdir -p ~/.config/polybar
mkdir -p ~/.config/rofi
mkdir -p ~/.config/alacritty
mkdir -p ~/Documents/Ascii-Art

# Symlink configs
ln -sf $DOTFILES/Bash Config/bashrc ~/.bashrc
ln -sf $DOTFILES/Bash Config/terminal.txt ~/Documents/Ascii-Art/terminal.txt
ln -sf $DOTFILES/i3-Config/config ~/.config/i3/config
ln -sf $DOTFILES/Polybar Config/config.ini ~/.config/polybar/config.ini
ln -sf $DOTFILES/Polybar Config/launch.sh ~/.config/polybar/launch.sh
ln -sf $DOTFILES/Rofi Config/config.rasi ~/.config/rofi/config.rasi
ln -sf $DOTFILES/Alacritty Config/alacritty.toml ~/.config/alacritty/alacritty.toml

echo "Dotfiles symlinked successfully!"
