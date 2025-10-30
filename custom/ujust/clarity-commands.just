# ClarityOS Custom Commands
# This file contains custom ujust commands for ClarityOS users

# Install Homebrew packages from Brewfile
brew-bundle:
    #!/usr/bin/bash
    if command -v brew &> /dev/null; then
        echo "Installing packages from Brewfile..."
        brew bundle --file=/usr/share/ublue-os/homebrew/default.Brewfile
    else
        echo "Homebrew not installed. Install it first with:"
        echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    fi

# Update system
update:
    #!/usr/bin/bash
    echo "Updating ClarityOS..."
    sudo bootc upgrade
    echo "Update complete. Reboot to apply changes."

# Switch to latest build
switch-to-latest:
    #!/usr/bin/bash
    echo "Switching to latest ClarityOS build..."
    sudo bootc switch ghcr.io/ctsdownloads/clarity-os:stable
    echo "Switch complete. Reboot to apply changes."

# Show system information
info:
    #!/usr/bin/bash
    echo "=== ClarityOS System Information ==="
    echo ""
    echo "Bootc Status:"
    bootc status
    echo ""
    echo "OS Release:"
    cat /etc/os-release
    echo ""
    echo "Desktop Session:"
    echo $XDG_CURRENT_DESKTOP

# Regenerate initramfs (if needed)
regenerate-initramfs:
    #!/usr/bin/bash
    echo "Regenerating initramfs..."
    sudo bootc upgrade --touch
    echo "Initramfs will be regenerated on next boot."

# Clean up old bootc deployments
cleanup:
    #!/usr/bin/bash
    echo "Cleaning up old deployments..."
    sudo bootc upgrade --clean
    echo "Cleanup complete."
