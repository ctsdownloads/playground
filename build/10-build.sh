#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# ClarityOS Build Script
###############################################################################
# This script installs COSMIC Desktop from Fedora 43 repositories
# and configures the ClarityOS environment
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Copy Custom Files"

# Copy Brewfiles to standard location
mkdir -p /usr/share/ublue-os/homebrew/
if [ -d /ctx/custom/brew ] && [ "$(ls -A /ctx/custom/brew/*.Brewfile 2>/dev/null)" ]; then
    cp /ctx/custom/brew/*.Brewfile /usr/share/ublue-os/homebrew/
fi

# Consolidate Just Files
mkdir -p /usr/share/ublue-os/just/
if [ -d /ctx/custom/ujust ]; then
    find /ctx/custom/ujust -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just
fi

# Copy Flatpak preinstall files
mkdir -p /etc/flatpak/preinstall.d/
if [ -d /ctx/custom/flatpaks ] && [ "$(ls -A /ctx/custom/flatpaks/*.preinstall 2>/dev/null)" ]; then
    cp /ctx/custom/flatpaks/*.preinstall /etc/flatpak/preinstall.d/
fi

# Copy custom branding files
if [ -d /ctx/usr/etc ]; then
    cp -r /ctx/usr/etc/* /etc/ 2>/dev/null || true
fi
if [ -d /ctx/usr/share ]; then
    cp -r /ctx/usr/share/* /usr/share/ 2>/dev/null || true
fi

echo "::endgroup::"

echo "::group:: Install COSMIC Desktop from Fedora 43"

# Install COSMIC Desktop Environment from Fedora 43 repositories
# COSMIC is System76's new desktop written in Rust
dnf5 install -y \
    cosmic-session \
    cosmic-greeter \
    cosmic-comp \
    cosmic-panel \
    cosmic-launcher \
    cosmic-applets \
    cosmic-settings \
    cosmic-files \
    cosmic-edit \
    cosmic-term \
    cosmic-workspaces \
    cosmic-bg \
    cosmic-osd \
    cosmic-screenshot \
    cosmic-notifications \
    xdg-desktop-portal-cosmic

echo "COSMIC Desktop installed successfully"
echo "::endgroup::"

echo "::group:: Install CLI Tools"

# Install essential CLI tools for ClarityOS
dnf5 install -y \
    git \
    vim \
    neovim \
    tmux \
    htop \
    btop \
    ripgrep \
    fd-find \
    fzf \
    bat \
    eza \
    zoxide \
    starship \
    curl \
    wget \
    rsync \
    tree \
    jq \
    yq \
    ncdu \
    tldr \
    fish \
    zsh \
    util-linux-user

echo "CLI tools installed successfully"
echo "::endgroup::"

echo "::group:: System Configuration"

# Enable COSMIC greeter (display manager)
systemctl enable cosmic-greeter

# Enable podman socket for container management
systemctl enable podman.socket

# Set COSMIC as default session
mkdir -p /etc/X11/sessions
cat > /etc/X11/sessions/cosmic.desktop << 'COSMICDESKTOP'
[Desktop Entry]
Name=COSMIC
Comment=COSMIC Desktop Environment
Exec=cosmic-session
Type=Application
DesktopNames=COSMIC
COSMICDESKTOP

# Create wayland session entry
mkdir -p /usr/share/wayland-sessions
cat > /usr/share/wayland-sessions/cosmic.desktop << 'COSMICWAYLAND'
[Desktop Entry]
Name=COSMIC
Comment=COSMIC Desktop Environment
Exec=cosmic-session
Type=Application
DesktopNames=COSMIC
COSMICWAYLAND

echo "System configuration complete"
echo "::endgroup::"

echo "ClarityOS build complete!"
echo "COSMIC Desktop has been installed and configured"
