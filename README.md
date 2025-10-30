# ClarityOS

A custom Linux distribution featuring the COSMIC Desktop Environment, built on Universal Blue's foundation.

## Features

- **COSMIC Desktop**: System76's modern desktop environment built in Rust
- **Base Image**: Universal Blue's base-main:gts for stability
- **Fedora 43 Repositories**: COSMIC installed from official Fedora 43 repos
- **Essential CLI Tools**: Pre-installed development and system utilities
- **Curated Applications**: Carefully selected Flatpaks for productivity and media
- **Bootc-based**: Modern image-based Linux with atomic updates
- **ISO Support**: Bootable installation media via bootc-image-builder

## Included Software

### Desktop Environment
- COSMIC Desktop (complete suite from Fedora 43)
- COSMIC Session, Greeter, Compositor
- COSMIC Apps: Files, Edit, Terminal, Settings
- COSMIC System Components: Panel, Launcher, Applets

### CLI Tools
- btop, htop - System monitoring
- fish, starship - Modern shell experience
- neovim - Text editor
- ripgrep, zoxide - Enhanced search and navigation
- tmux - Terminal multiplexer
- git, curl, wget - Development essentials
- kitty - GPU-accelerated terminal

### Flatpak Applications
- **Development**: Bazaar, COSMIC Tweaks
- **System**: Warehouse, Flatseal
- **Office**: LibreOffice
- **Media**: Celluloid (video player), Color Picker (gcolor3)
- **Utilities**: Loupe (image viewer), Papers (document viewer), Baobab (disk usage), FileRoller (archive manager)

## Installation

### From ISO (Recommended)

1. Download the latest ISO from GitHub Actions artifacts
2. Write to USB: `dd if=clarityos.iso of=/dev/sdX bs=4M status=progress`
3. Boot from USB and follow the installer

### Rebase Existing System

If you're already running a bootc-compatible system:

```bash
sudo bootc switch ghcr.io/ctsdownloads/playground:stable
sudo systemctl reboot
```

## Building Locally

### Prerequisites
- Podman installed
- Just command runner (optional but recommended)

### Build Container Image

```bash
# Using just
just build

# Or using podman directly
podman build -t localhost/clarity-os:stable .
```

### Build ISO

```bash
# Using just
just build-iso

# The ISO will be in output/bootiso/
```

### Test in VM

```bash
# Build and run QCOW2 image in browser-based VM
just run-vm
```

## Customization

### Modify Packages

Edit `build/10-build.sh` to add or remove CLI tools:
```bash
dnf5 install -y your-package-here
```

Edit `build/20-cosmic-desktop.sh` to modify COSMIC components.

### Add Flatpaks

Edit `custom/flatpaks/default.preinstall` to add applications:
```ini
[Flatpak Preinstall com.example.App]
Branch=stable
```

### Custom Branding

Place custom files in:
- `custom/usr/etc/` - System configuration
- `custom/usr/share/` - Shared data (icons, themes, etc.)

## Development

### GitHub Actions

The repository includes automated workflows:
- **Build**: Builds and publishes container images
- **ISO Builder**: Creates bootable ISO images
- Runs on every push to main and daily schedule

### Enable Image Signing (Optional)

1. Generate signing keys:
   ```bash
   cosign generate-key-pair
   ```

2. Add `cosign.key` to GitHub Secrets as `SIGNING_SECRET`

3. Update `cosign.pub` with your public key

4. Uncomment signing steps in `.github/workflows/build.yml`

## Project Structure

```
.
├── Containerfile           # Main image definition
├── Justfile               # Build automation commands
├── build/                 # Build-time scripts
│   ├── 10-build.sh       # Base system setup
│   └── 20-cosmic-desktop.sh  # COSMIC installation
├── custom/               # Customization files
│   ├── flatpaks/        # Flatpak preinstall configs
│   └── usr/             # System file overlays
├── iso/                  # ISO build configurations
│   ├── disk.toml        # Disk image config
│   └── iso.toml         # ISO installer config
└── .github/
    └── workflows/        # CI/CD automation
        └── build.yml    # Main build workflow
```

## Why ClarityOS?

ClarityOS brings together:
- **Modern Desktop**: COSMIC's fresh, Rust-based desktop experience
- **Stability**: Universal Blue's proven base with GTS support
- **Simplicity**: Curated application selection for immediate productivity
- **Transparency**: Fully open-source, inspectable, and customizable

## Support

- **Issues**: [GitHub Issues](https://github.com/ctsdownloads/playground/issues)
- **Universal Blue**: [Documentation](https://universal-blue.org/)
- **COSMIC Desktop**: [Project Page](https://github.com/pop-os/cosmic-epoch)

## License

Licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

## Credits

Built with:
- [Universal Blue](https://universal-blue.org/) - Base system and tooling
- [COSMIC Desktop](https://system76.com/cosmic) - Desktop environment by System76
- [Fedora Project](https://fedoraproject.org/) - Underlying distribution
- [bootc](https://containers.github.io/bootc/) - Image-based Linux infrastructure
