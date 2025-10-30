# Flatpak Preinstall Configuration

This directory contains flatpak preinstall configuration files that define which applications will be automatically installed on first boot.

## File Format

Files use the INI format with `[Flatpak Preinstall ID]` sections:

```ini
[Flatpak Preinstall org.example.App]
Branch=stable
```

## Included Applications

The default configuration (`default.preinstall`) includes:

### Development & System Tools
- **Bazaar** - Browse and install GNOME apps
- **Warehouse** - Flatpak management tool
- **Flatseal** - Flatpak permissions manager

### Office Suite
- **LibreOffice** - Complete office suite

### Media Applications
- **Celluloid** - Modern video player
- **gcolor3** - Color picker utility

### GNOME Core Applications
- **Loupe** - Image viewer
- **Papers** - Document viewer
- **Baobab** - Disk usage analyzer
- **FileRoller** - Archive manager

## Adding Applications

1. Find the flatpak ID on [Flathub](https://flathub.org/)
2. Add a new section to `default.preinstall`:
   ```ini
   [Flatpak Preinstall com.example.NewApp]
   Branch=stable
   ```
3. Test with validation workflow: Push to a PR to validate

## Notes

- COSMIC-specific applications are included in the COSMIC Desktop installation, not as flatpaks
- Applications are installed from Flathub on first boot
- The validation workflow checks that all listed apps exist on Flathub
