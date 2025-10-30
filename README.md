# ClarityOS

A beautiful, modern Linux desktop operating system featuring System76's COSMIC Desktop Environment, built on Universal Blue's reliable foundation. ClarityOS combines cutting-edge desktop technology with enterprise-grade stability.

## Features

### 🌟 COSMIC Desktop Environment
- **Modern Wayland Desktop**: Built from the ground up in Rust for System76's Pop!_OS
- **Beautiful & Fast**: Smooth animations, responsive UI, and efficient resource usage
- **Customizable**: Extensive theming and configuration options via COSMIC Tweaks
- **Productive**: Tiling window management, workspaces, and keyboard-driven workflows

### 🛠️ Powerful CLI Tools
Pre-installed developer and power-user tools:
- **Modern shell tools**: `ripgrep`, `fd`, `fzf`, `bat`, `eza`, `zoxide`
- **System monitoring**: `htop`, `btop`
- **Text editors**: `vim`, `neovim`
- **Terminal multiplexer**: `tmux`
- **Shell prompt**: `starship`
- **Alternative shells**: `fish`, `zsh`

### 📦 Curated Application Suite
Essential applications pre-configured via Flatpak:
- **Office**: LibreOffice complete suite
- **Media**: Celluloid video player, Loupe image viewer, Papers document reader
- **Utilities**: Warehouse (Flatpak manager), Flatseal (permissions), Baobab (disk usage), FileRoller (archives)
- **COSMIC Apps**: COSMIC Tweaks, COSMIC Money (finance management)
- **Tools**: Bazaar, Color Picker (gcolor3)

### 🔒 Enterprise Foundation
- **Base**: Built on Universal Blue's `base-main:gts` (Guaranteed Technical Support)
- **Atomic Updates**: Reliable, rollback-capable system updates
- **Container Native**: Built using bootc for modern infrastructure
- **Automated Security**: Regular automated updates via Renovate

## Quick Start

📚 **New to ClarityOS?** Check out the [Quick Start Guide](QUICKSTART.md) for a fast introduction!

### Installation

#### Option 1: Rebase from existing Fedora/Universal Blue system

```bash
# Switch to ClarityOS
sudo bootc switch ghcr.io/ctsdownloads/clarity-os:stable

# Reboot to complete the transition
sudo systemctl reboot
```

#### Option 2: Install from ISO (Automated)

**⚠️ Note:** The ISO performs automated installation (no user prompts). See `INSTALLER_AUDIT.md` for details.

1. Download the latest ISO from the [Releases](https://github.com/ctsdownloads/clarity-os/releases) page
2. Flash to USB drive using [Fedora Media Writer](https://flathub.org/apps/org.fedoraproject.MediaWriter) or Ventoy
3. Boot from USB - installation proceeds automatically
4. System reboots after installation completes

**For interactive installation:** Boot a live USB (Fedora/Universal Blue) and use:
```bash
sudo bootc switch ghcr.io/ctsdownloads/clarity-os:stable
sudo systemctl reboot
```

### First Boot

On first boot, ClarityOS will:
1. Initialize COSMIC Desktop Environment
2. Install all configured Flatpak applications
3. Set up container runtime (Podman)
4. Configure system defaults

Select "COSMIC" at the login screen to start your session.

## Building from Source

### Prerequisites
- Podman or Docker
- Just command runner (optional, recommended)
- Git

### Build Container Image

```bash
# Clone the repository
git clone https://github.com/ctsdownloads/clarity-os
cd clarity-os

# Build with Podman
podman build --tag localhost/clarity-os:stable .

# Or build with Just
just build
```

### Build Bootable ISO

```bash
# Build ISO image
just build-iso

# The ISO will be in output/bootiso/install.iso
```

### Build QCOW2 VM Image

```bash
# Build QCOW2 virtual machine image
just build-qcow2

# Test in browser-based VM
just run-vm-qcow2
```

## Customization

### Adding Packages

Edit `build/10-build.sh` to add system packages:

```bash
dnf5 install -y your-package-name
```

### Adding Flatpaks

Edit `custom/flatpaks/default.preinstall`:

```ini
[Flatpak Preinstall org.example.YourApp]
Branch=stable
```

Find application IDs on [Flathub](https://flathub.org/).

### Custom Branding

Place custom files in:
- `usr/etc/` - System configuration files
- `usr/share/` - Shared data files (icons, themes, etc.)

These will be copied during image build.

## Development Workflow

### Making Changes

1. Create a new branch:
   ```bash
   git checkout -b feature/your-feature
   ```

2. Make your changes to:
   - `Containerfile` - Base image configuration
   - `build/10-build.sh` - Package installation
   - `custom/flatpaks/` - Flatpak applications
   - `usr/` - Custom branding files

3. Test your changes:
   ```bash
   just build
   just build-qcow2
   just run-vm-qcow2
   ```

4. Validate:
   ```bash
   # Check shell scripts
   just lint
   
   # Format shell scripts
   just format
   ```

5. Open a pull request

### Pull Request Workflow

All changes should go through pull requests:
1. PR is opened → Automated validation runs
2. Checks pass → Review and merge
3. Merge to main → Automatic build and publish to GHCR

## GitHub Actions Workflows

ClarityOS includes several automated workflows:

- **Build** (`build.yml`): Builds and publishes container images
- **Clean** (`clean.yml`): Removes old container images weekly
- **Validate Flatpaks** (`validate-flatpaks.yml`): Ensures Flatpak IDs are valid
- **Validate Shell Scripts** (`validate-shellcheck.yml`): Runs ShellCheck on scripts

### Enabling Actions

If you forked this repository:
1. Go to the "Actions" tab
2. Click "I understand my workflows, go ahead and enable them"

## System Requirements

### Minimum
- **CPU**: 2 cores, x86_64
- **RAM**: 4 GB
- **Disk**: 32 GB
- **Graphics**: OpenGL 3.3 or Vulkan support

### Recommended
- **CPU**: 4+ cores, x86_64
- **RAM**: 8 GB or more
- **Disk**: 64 GB SSD
- **Graphics**: Modern GPU with Vulkan 1.1+

## Architecture

ClarityOS is built using several modern technologies:

- **bootc**: Modern container-native OS builder
- **Universal Blue**: Community-maintained Fedora Atomic Desktop images
- **COSMIC Desktop**: System76's next-generation desktop written in Rust
- **Flatpak**: Sandboxed application distribution
- **Podman**: Daemonless container runtime
- **bootc-image-builder**: Creates ISOs and disk images from container images

## Documentation

- [Setup Guide](SETUP.md) - Complete setup and configuration guide
- [Build System](build/README.md) - Details on the build process
- [Flatpak Management](custom/flatpaks/README.md) - Managing applications
- [Justfile Commands](Justfile) - Available build and test commands

## Community & Support

- **Issues**: [GitHub Issues](https://github.com/ctsdownloads/clarity-os/issues)
- **Discussions**: [GitHub Discussions](https://github.com/ctsdownloads/clarity-os/discussions)
- **Universal Blue**: [Universal Blue Forums](https://universal-blue.discourse.group/)
- **COSMIC Desktop**: [System76 Docs](https://github.com/pop-os/cosmic-epoch)

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

See our [contributing guidelines](CONTRIBUTING.md) for more details.

## License

Apache License 2.0 - See [LICENSE](LICENSE) file for details.

## Acknowledgments

- **Universal Blue Project**: Foundation and tooling
- **System76**: COSMIC Desktop Environment
- **Fedora Project**: Base operating system
- **finpilot template**: Build system inspiration ([@castrojo/finpilot](https://github.com/castrojo/finpilot))

## Related Projects

- [Universal Blue](https://universal-blue.org/) - Community Fedora Atomic images
- [Bluefin](https://projectbluefin.io/) - Developer-focused desktop
- [Bazzite](https://bazzite.gg/) - Gaming-focused desktop
- [COSMIC Desktop](https://github.com/pop-os/cosmic-epoch) - System76's desktop environment

---

**ClarityOS** - Clear vision, powerful tools, beautiful desktop. 🌟
