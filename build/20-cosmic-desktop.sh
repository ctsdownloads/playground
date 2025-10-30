#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# COSMIC Desktop Installation for ClarityOS
###############################################################################
# This script installs System76's COSMIC desktop environment from Fedora 43 repositories.
# COSMIC is a new desktop environment built in Rust by System76.
# https://github.com/pop-os/cosmic-epoch
###############################################################################

echo "::group:: Install COSMIC Desktop from Fedora 43"

# COSMIC is available in Fedora 43 repositories
# Install COSMIC desktop and core components
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
    cosmic-store \
    cosmic-screenshot \
    cosmic-notifications \
    cosmic-osd \
    cosmic-bg \
    cosmic-icons \
    xdg-desktop-portal-cosmic

echo "COSMIC desktop installed successfully from Fedora 43 repositories"
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
