#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Main Build Script for ClarityOS
###############################################################################
# This script follows the @ublue-os/bluefin pattern for build scripts.
# It uses set -eoux pipefail for strict error handling and debugging.
###############################################################################

echo "::group:: Copy Custom Files"

# Copy Brewfiles to standard location (if they exist)
if [ -d /ctx/custom/brew ]; then
    mkdir -p /usr/share/ublue-os/homebrew/
    if ls /ctx/custom/brew/*.Brewfile 1> /dev/null 2>&1; then
        cp /ctx/custom/brew/*.Brewfile /usr/share/ublue-os/homebrew/
    fi
fi

# Consolidate Just Files (if they exist)
if [ -d /ctx/custom/ujust ]; then
    mkdir -p /usr/share/ublue-os/just/
    find /ctx/custom/ujust -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just || true
fi

# Copy Flatpak preinstall files
mkdir -p /etc/flatpak/preinstall.d/
if [ -d /ctx/custom/flatpaks ]; then
    cp /ctx/custom/flatpaks/*.preinstall /etc/flatpak/preinstall.d/
fi

# Copy custom branding files
if [ -d /ctx/custom/usr/etc ]; then
    cp -r /ctx/custom/usr/etc/* /usr/etc/ || true
fi
if [ -d /ctx/custom/usr/share ]; then
    cp -r /ctx/custom/usr/share/* /usr/share/ || true
fi

echo "::endgroup::"

echo "::group:: Install Essential CLI Tools"

# Install essential CLI tools for ClarityOS
dnf5 install -y \
    btop \
    curl \
    fish \
    git \
    htop \
    kitty \
    neovim \
    ripgrep \
    starship \
    tmux \
    wget \
    zoxide

echo "::endgroup::"

echo "::group:: System Configuration"

# Enable/disable systemd services
systemctl enable podman.socket

echo "::endgroup::"

echo "ClarityOS base build complete!"
