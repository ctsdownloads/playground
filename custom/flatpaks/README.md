# Flatpak Preinstall Configuration

This directory contains flatpak preinstall configuration files for ClarityOS.

## How It Works

Files with `.preinstall` extension in this directory will be automatically installed on first boot of your ClarityOS system.

## Format

The format follows the Flatpak preinstall specification:

```ini
[Flatpak Preinstall application.id]
Branch=stable
```

## Included Applications

ClarityOS includes the following flatpak applications by default:

### COSMIC Desktop Apps
- **COSMIC Tweaks** - Customize your COSMIC desktop
- **COSMIC Money** - Finance management application

### System Utilities
- **Bazaar** - Browse and manage GNOME extensions
- **Warehouse** - Flatpak manager
- **Flatseal** - Manage Flatpak permissions

### Productivity
- **LibreOffice** - Complete office suite

### Media
- **Celluloid** - Modern video player
- **Loupe** - Image viewer
- **Papers** - Document viewer

### Utilities
- **Color Picker (gcolor3)** - Color selection tool
- **Baobab** - Disk usage analyzer
- **FileRoller** - Archive manager

## Adding More Applications

To add more flatpaks:

1. Add a new section to `default.preinstall`:
   ```ini
   [Flatpak Preinstall org.example.App]
   Branch=stable
   ```

2. Find the application ID on [Flathub](https://flathub.org/)

3. Build and deploy your updated image

## Validation

The flatpak IDs are validated during the build process to ensure they exist on Flathub.
