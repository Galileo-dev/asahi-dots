#!/bin/bash

# List of packages to install
packages=(
    "fish"
    "starship"
    "helix"
    "nushell"
    "kitty"
    "btop"
    "cava"
    "rofi"
    "thunar"
    "qt5-qtstyleplugins"
    "bat"
    "hyprland"
)

# Update system before installing packages
echo "Updating system..."
sudo dnf update -y

# Install packages
echo "Installing packages..."
for package in "${packages[@]}"; do
    if ! dnf list installed "$package" &>/dev/null; then
        echo "Installing $package..."
        sudo dnf install -y "$package"
    else
        echo "$package is already installed."
    fi
done

# Set fish as the default shell if installed
if command -v fish &>/dev/null; then
    echo "Setting fish as the default shell..."
    chsh -s "$(command -v fish)"
else
    echo "Fish shell not found, skipping default shell setup."
fi

echo "Installation complete!"
