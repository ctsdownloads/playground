# ClarityOS Setup Guide

This document provides detailed setup instructions for ClarityOS development and deployment.

## Prerequisites

Before building ClarityOS, ensure you have:
- A Linux system with Podman or Docker
- At least 20GB of free disk space
- Internet connection for downloading packages

## Initial Setup

### 1. Clone the Repository

```bash
git clone https://github.com/ctsdownloads/clarity-os
cd clarity-os
```

### 2. Enable GitHub Actions

If you forked this repository:
1. Go to the **Actions** tab on GitHub
2. Click **"I understand my workflows, go ahead and enable them"**
3. Workflows will now run on commits and pull requests

### 3. Configure Secrets (Optional)

For image signing (production use):
1. Generate signing keys: `cosign generate-key-pair`
2. Add `cosign.key` contents to GitHub Secrets as `SIGNING_SECRET`
3. Commit your `cosign.pub` file to the repository
4. Uncomment signing steps in `.github/workflows/build.yml`

## Building ClarityOS

### Local Build

Build the container image locally:

```bash
# Build with Podman
podman build --tag localhost/clarity-os:stable .

# Or build with Docker
docker build --tag localhost/clarity-os:stable .
```

### Build with Just

If you have `just` installed:

```bash
# Build container image
just build

# Build QCOW2 VM image
just build-qcow2

# Build ISO installer
just build-iso

# Build and test in VM
just run-vm-qcow2
```

## Testing ClarityOS

### Test in Virtual Machine

1. Build QCOW2 image:
   ```bash
   just build-qcow2
   ```

2. Run in browser-based VM:
   ```bash
   just run-vm-qcow2
   ```

3. Connect to `http://localhost:8006` (port may vary)

### Test with bootc

Switch an existing Fedora/Universal Blue system:

```bash
# Switch to your local build
sudo bootc switch localhost/clarity-os:stable

# Or switch to published image
sudo bootc switch ghcr.io/ctsdownloads/clarity-os:stable

# Reboot to apply
sudo systemctl reboot
```

## Architecture Details

### Base Image

ClarityOS is built on `ghcr.io/ublue-os/base-main:gts`:
- **gts**: Guaranteed Technical Support variant
- Based on Fedora Atomic Desktop
- Provides a stable, minimal base for customization

### COSMIC Desktop

COSMIC Desktop is installed from:
- **Primary**: Fedora 43 main repositories (when available)
- **Fallback**: COPR repository (ryanabx/cosmic-epoch)

The build script automatically detects availability and chooses the appropriate source.

### Initramfs Configuration

ClarityOS uses bootc's built-in initramfs generation:

1. **Automatic Generation**: bootc automatically generates initramfs on deployment
2. **Regeneration**: Use `ujust regenerate-initramfs` to force regeneration
3. **Custom Modules**: Add modules in `/etc/dracut.conf.d/` (via `usr/etc/dracut.conf.d/`)

#### Adding Custom Initramfs Modules

Create a file in `usr/etc/dracut.conf.d/clarity.conf`:

```bash
# Add custom modules
add_dracutmodules+=" custom-module "

# Add custom drivers
add_drivers+=" driver-name "
```

The build process copies this to the final image, and bootc will include it in the initramfs.

### Image Layers

The ClarityOS image consists of:
1. **Base Layer**: Universal Blue base-main:gts
2. **COSMIC Layer**: COSMIC Desktop packages
3. **CLI Tools Layer**: Developer tools and utilities
4. **Custom Layer**: Branding, configurations, and customizations

### Container Structure

```
clarity-os/
├── /etc/                     # System configuration
├── /usr/bin/                 # Binaries and executables
├── /usr/lib/                 # Libraries
├── /usr/share/               # Shared data
│   ├── ublue-os/
│   │   ├── homebrew/         # Brewfiles
│   │   └── just/             # ujust commands
├── /etc/flatpak/             # Flatpak configuration
│   └── preinstall.d/         # Flatpak preinstalls
└── /var/                     # Mutable data (user space)
```

## Customization

### Adding System Packages

Edit `build/10-build.sh`:

```bash
dnf5 install -y \
    your-package \
    another-package
```

### Adding Flatpak Applications

Edit `custom/flatpaks/default.preinstall`:

```ini
[Flatpak Preinstall org.example.App]
Branch=stable
```

### Adding Homebrew Packages

Edit `custom/brew/default.Brewfile`:

```ruby
brew "package-name"
cask "application-name"
```

### Custom Branding

Place files in:
- `usr/etc/` → copied to `/etc/`
- `usr/share/` → copied to `/usr/share/`

Example branding structure:
```
usr/
├── etc/
│   └── profile.d/
│       └── clarity-defaults.sh
└── share/
    ├── wallpapers/clarityos/
    │   └── default.png
    └── icons/clarity/
        └── logo.svg
```

### Custom ujust Commands

Add `.just` files to `custom/ujust/`:

```just
my-command:
    echo "Running my custom command"
```

Users can then run: `ujust my-command`

## ISO Generation

### Creating Bootable ISOs

ISOs are built using bootc-image-builder:

```bash
just build-iso
```

Configuration files:
- `iso/iso.toml` - ISO-specific configuration
- `iso/disk.toml` - Disk layout for VM images

### ⚠️ Important: Automated Installation

**ISOs created by bootc-image-builder perform AUTOMATED installation.**

The installer will:
- Automatically detect and use the first available disk
- Automatically partition and format the disk
- Install ClarityOS without user interaction
- Reboot when complete

**This is by design** - bootc-image-builder creates deployment ISOs, not interactive installers.

See `INSTALLER_AUDIT.md` for complete technical details.

### ISO Configuration Options

Edit `iso/iso.toml` to customize the **image** (not the installer behavior):

**Valid configurations:**
- User accounts (pre-configured)
- Filesystem modifications
- Hostname and system settings

Example:
```toml
# ISO Configuration for ClarityOS
# Note: Installation is automated by bootc-image-builder

[[customizations.user]]
name = "clarityos"
description = "ClarityOS User"
password = "$6$rounds=4096$..."  # Generate with: openssl passwd -6
groups = ["wheel"]
```

**Invalid configurations** (silently ignored by bootc-image-builder):
```toml
[customizations.installer]  # ❌ Not supported by BIB
unattended = false          # ❌ Has no effect
```

### Interactive Installation Alternatives

If you need interactive installation with manual partitioning and user creation:

**Option 1: Use `bootc switch` from Live USB (Recommended)**
```bash
# Boot any Fedora or Universal Blue live USB
# Open terminal:
sudo bootc switch ghcr.io/ctsdownloads/clarity-os:stable
sudo systemctl reboot
```

**Option 2: Install base Fedora first**
```bash
# Install Fedora interactively
# After installation, switch to ClarityOS:
sudo bootc switch ghcr.io/ctsdownloads/clarity-os:stable
sudo systemctl reboot
```

**Option 3: Use pre-configured user**
Edit `iso/iso.toml` to add a default user (see example above), then rebuild the ISO.

## Deployment

### Option 1: Rebase from Existing System

On an existing Fedora/Universal Blue installation:

```bash
sudo bootc switch ghcr.io/ctsdownloads/clarity-os:stable
sudo systemctl reboot
```

### Option 2: Install from ISO

1. Download ISO from releases
2. Flash to USB with Fedora Media Writer or Ventoy
3. Boot from USB
4. Follow installation prompts

### Option 3: Deploy to Server/VM

Use the QCOW2 or RAW image:

```bash
just build-qcow2
# Use output/qcow2/disk.qcow2 with your VM manager
```

## Maintenance

### Updating ClarityOS

On the system:
```bash
ujust update
```

Or manually:
```bash
sudo bootc upgrade
sudo systemctl reboot
```

### Cleaning Old Deployments

```bash
ujust cleanup
```

Or manually:
```bash
sudo bootc upgrade --clean
```

### Regenerating Initramfs

If you need to regenerate the initramfs:

```bash
ujust regenerate-initramfs
sudo systemctl reboot
```

## Troubleshooting

### Build Fails

1. Check GitHub Actions logs for error details
2. Look for the last successful `::group::` marker
3. Test locally: `just build`
4. Check shell scripts: `shellcheck build/*.sh`

### COSMIC Desktop Doesn't Start

1. Verify COSMIC packages installed:
   ```bash
   rpm -qa | grep cosmic
   ```

2. Check display manager:
   ```bash
   systemctl status cosmic-greeter
   ```

3. Select COSMIC at login screen

### Flatpaks Don't Install

1. Check Flatpak IDs are correct:
   ```bash
   flatpak remote-ls flathub | grep app-id
   ```

2. Manually install:
   ```bash
   flatpak install flathub org.example.App
   ```

### Boot Issues

1. Boot to previous deployment:
   - At bootloader, select previous entry

2. Rollback:
   ```bash
   sudo bootc rollback
   ```

## GitHub Actions Workflows

### build.yml
- **Trigger**: Push to main, PRs, daily schedule
- **Function**: Builds and publishes container image
- **Output**: `ghcr.io/ctsdownloads/clarity-os:stable`

### clean.yml
- **Trigger**: Weekly (Sundays 2am UTC)
- **Function**: Removes old container images
- **Keeps**: Latest 10 versions plus tagged

### validate-flatpaks.yml
- **Trigger**: PRs modifying flatpak files
- **Function**: Validates Flatpak IDs exist on Flathub

### validate-shellcheck.yml
- **Trigger**: PRs modifying shell scripts
- **Function**: Runs shellcheck on all `.sh` files

## Resources

- [bootc Documentation](https://containers.github.io/bootc/)
- [Universal Blue Docs](https://universal-blue.org/)
- [COSMIC Desktop](https://github.com/pop-os/cosmic-epoch)
- [Fedora Silverblue](https://fedoraproject.org/silverblue/)
- [Flatpak Documentation](https://docs.flatpak.org/)

## Getting Help

- [GitHub Issues](https://github.com/ctsdownloads/clarity-os/issues)
- [GitHub Discussions](https://github.com/ctsdownloads/clarity-os/discussions)
- [Universal Blue Forum](https://universal-blue.discourse.group/)
- [Universal Blue Discord](https://discord.gg/WEu6BdFEtp)
