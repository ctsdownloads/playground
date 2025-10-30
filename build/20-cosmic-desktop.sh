#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# COSMIC Desktop Installation for ClarityOS
###############################################################################
# This script installs System76's COSMIC desktop environment.
# COSMIC is a new desktop environment built in Rust by System76.
# https://github.com/pop-os/cosmic-epoch
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Install COSMIC Desktop"

# COSMIC Desktop can be installed from Fedora 43+ repos or from COPR
# First, try to install from system repos (Fedora 43+)
# If that fails, fall back to COPR

if dnf5 info cosmic-desktop &>/dev/null; then
    echo "Installing COSMIC from Fedora repositories..."
    dnf5 install -y \
        cosmic-desktop \
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
        xdg-desktop-portal-cosmic
else
    echo "COSMIC not found in system repos, installing from COPR..."
    # Using isolated pattern to prevent COPR from persisting
    copr_install_isolated "ryanabx/cosmic-epoch" \
        cosmic-desktop \
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
        xdg-desktop-portal-cosmic
fi

echo "COSMIC desktop installed successfully"
echo "::endgroup::"

echo "::group:: Configure Display Manager"

# Enable cosmic-greeter (COSMIC's display manager)
systemctl enable cosmic-greeter

echo "Display manager configured"
echo "::endgroup::"

echo "::group:: Install Additional Utilities"

# Install additional utilities that work well with COSMIC
dnf5 install -y \
    flatpak \
    xdg-utils \
    xdg-user-dirs

echo "Additional utilities installed"
echo "::endgroup::"

echo "COSMIC desktop installation complete!"
echo "After booting, COSMIC session will be available at the login screen"
