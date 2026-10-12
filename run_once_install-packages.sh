#!/bin/bash

# Ensure this script is only running on Arch Linux systems
if ! command -v pacman &> /dev/null; then
    echo "⚠️ pacman not found. Skipping Arch Linux installation."
    exit 0
fi

echo "Arch Linux system detected. Beginning automated package setup..."

# 1. Install Official Repositories Packages via pacman
sudo pacman -Syu --needed --noconfirm \
    hyprland hyprpaper waybar wofi dunst \
    kitty zsh starship fastfetch btop neovim \
    ranger python-pillow elephant kde-connect \
    ttf-nerd-fonts-symbols ttf-jetbrains-mono-nerd \
    git base-devel

# 2. Bootstrap yay (AUR Helper) if missing
if ! command -v yay &> /dev/null; then
    echo "'yay' not found. Installing yay from AUR..."
    # Build yay in a temporary directory securely without root privileges
    SRC_DIR=$(mktemp -d)
    git clone https://archlinux.org "$SRC_DIR"
    cd "$SRC_DIR" && makepkg -si --noconfirm
    cd - && rm -rf "$SRC_DIR"
fi

# 3. Install AUR Packages via yay (Run WITHOUT sudo)
echo "Installing AUR packages..."
yay -S --needed --noconfirm \
    brave-bin \
    elephant-desktopapplications \
    elephant-providerlist \
    spotify \
    rose-pine-hyprcursor \
    rose-pine-cursor

echo "All packages installed successfully!"

