# Quick Start Guide

Get up and running with ClarityOS in minutes!

## For Users

### Install ClarityOS on Existing Fedora/Universal Blue System

```bash
# Switch to ClarityOS
sudo bootc switch ghcr.io/ctsdownloads/clarity-os:stable

# Reboot to apply
sudo systemctl reboot
```

After reboot, select **COSMIC** at the login screen.

### Install from ISO (Coming Soon)

1. Download ISO from [Releases](https://github.com/ctsdownloads/clarity-os/releases)
2. Flash to USB with [Fedora Media Writer](https://flathub.org/apps/org.fedoraproject.MediaWriter)
3. Boot and install

## For Developers

### Build Locally

```bash
# Clone repository
git clone https://github.com/ctsdownloads/clarity-os
cd clarity-os

# Build container image
podman build --tag localhost/clarity-os:stable .

# Build bootable ISO
just build-iso
```

### Test in VM

```bash
# Build and run in browser-based VM
just build-qcow2
just run-vm-qcow2

# Open http://localhost:8006 in your browser
```

### Customize

1. **Add packages**: Edit `build/10-build.sh`
2. **Add Flatpaks**: Edit `custom/flatpaks/default.preinstall`
3. **Add branding**: Place files in `usr/etc/` and `usr/share/`
4. **Build and test**: `just build && just run-vm-qcow2`

## Key Commands

### On ClarityOS System

```bash
ujust update               # Update system
ujust info                 # Show system info
ujust brew-bundle          # Install Homebrew packages
ujust cleanup              # Clean old deployments
```

### For Developers

```bash
just build                 # Build container image
just build-iso             # Build bootable ISO
just build-qcow2           # Build VM disk image
just run-vm-qcow2          # Test in VM
just lint                  # Check shell scripts
```

## What's Included?

- 🖥️ **COSMIC Desktop** - Modern Rust-based desktop environment
- 🛠️ **CLI Tools** - Git, Vim, Neovim, tmux, htop, btop, ripgrep, fzf, bat, and more
- 📦 **Flatpaks** - LibreOffice, Celluloid, Loupe, Papers, Warehouse, Flatseal, and more
- 🎨 **Customizable** - Easy to modify and extend
- 🔒 **Atomic** - Reliable updates with rollback capability

## Getting Help

- 📖 [Full Documentation](README.md)
- ⚙️ [Setup Guide](SETUP.md)
- 🐛 [Report Issues](https://github.com/ctsdownloads/clarity-os/issues)
- 💬 [Discussions](https://github.com/ctsdownloads/clarity-os/discussions)

## What's Next?

After installation:

1. **Explore COSMIC Desktop** - Try the tiling features and workspaces
2. **Customize your shell** - Starship prompt is pre-installed
3. **Install more apps** - Use Warehouse or `flatpak install`
4. **Set up Homebrew** - Run `ujust brew-bundle` for CLI tools
5. **Join the community** - Share your experience!

---

**Welcome to ClarityOS!** 🌟

Clear vision. Powerful tools. Beautiful desktop.
